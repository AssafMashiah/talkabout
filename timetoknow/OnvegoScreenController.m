//
//  OnvegoScreenController.m
//  TalkAbout
//
//  Created by Alon on 8/28/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#define ip @"192.168.1.5"
#define port @"8080"
#define serverName @"TalkAboutServer"
//#define appKey [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey]
#define appKey @"il_t2k_talkabout"
#define password @"jhjhvjh9879h88g8sg7g7g27sg72f"

#define baseUrl @"http://proxy.onvegoServer.xyz"

#define OnvegoAppKeyNotFoundException @"err-1"
#define OnvegoLicenseExpiredException @"err-2"
#define OnvegoPhraseNotFoundException @"err-3"
#define OnvegoGeneralException @"err-0"

#import "OnvegoScreenController.h"
#import "SKSConfiguration.h"
#import <SpeechKit/SpeechKit.h>

enum {
    SKSIdle = 1,
    SKSListening = 2,
    SKSProcessing = 3
};
typedef NSUInteger SKSState;

@interface OnvegoScreenController () <SKTransactionDelegate> {
    NSMutableArray *phrasesApp;
    NSMutableArray *phrasesOnvego;
    BOOL showPhrases;
    UIView* currPhrases;
    NSArray *constraintHeight;
    NSArray *constraintRel;
    UIView* viewForChoosePhrase;
    NSString* currPhrase;
    
    NSArray* currPhrasesOnvego;
    
    SKSession* _skSession;
    SKTransaction *_skTransaction;
    SKSState _state;
    NSTimer *_volumePollTimer;
}

@end

@implementation OnvegoScreenController
@synthesize viewPhrases;
@synthesize buttonChoosePhrase;
@synthesize buttonTalk= _toggleRecogButton;
@synthesize buttonListPhrases;
@synthesize imageBack;
@synthesize imageParrot;

@synthesize language = _language;
@synthesize recognitionType = _recognitionType;
@synthesize endpointer = _endpointer;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* sdt = appKey;
    showPhrases= NO;
    NSMutableArray* tableDataTemp = [[NSMutableArray alloc]init];
    NSMutableArray* categories = [Static getCategories];
    for (Categoryy* category in categories) {
        for (Subject* subject in [category getSubjects]) {
            for (Question* question in [subject getQuestions]) {
                for (Answer* answer in [question getAnswers]) {
                    [tableDataTemp addObject:[answer getText]];
                }
            }
            for (Question* question in [subject getQuestionsVocab]) {
                for (Answer* answer in [question getAnswers]) {
                    [tableDataTemp addObject:[answer getText]];
                }
            }
        }
    }
    phrasesApp = tableDataTemp;
    [self uploadPhrases];
    
    [buttonChoosePhrase setBackgroundColor:[UIColor blackColor]];
    
    NSDictionary *viewsDictionary = @{@"redView":buttonChoosePhrase};
    constraintHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[redView]"
                                                               options:0
                                                               metrics:nil
                                                                 views:viewsDictionary];
    [buttonChoosePhrase.superview addConstraints:constraintHeight];
    
    UITapGestureRecognizer *tapGR2;
    tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToApplication:)];
    tapGR2.numberOfTapsRequired = 1;
    tapGR2.cancelsTouchesInView = NO;
    [imageBack setUserInteractionEnabled:YES];
    [imageBack addGestureRecognizer:tapGR2];
    
    UITapGestureRecognizer *tapGR1;
    tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToApplication:)];
    tapGR1.numberOfTapsRequired = 1;
    tapGR1.cancelsTouchesInView = NO;
    [imageParrot setUserInteractionEnabled:YES];
    [imageParrot addGestureRecognizer:tapGR1];
    
    _recognitionType = SKTransactionSpeechTypeDictation;
    _endpointer = SKTransactionEndOfSpeechDetectionShort;
    if ([Static GetDialect] == nil) {
        _language = LANGUAGE;
    }else{
        if ([[Static GetDialect] isEqualToString:@""]) {
            _language = @"eng-USA";
        }else{
            _language = [Static GetDialect];
        }
    }
    
    _state = SKSIdle;
    _skTransaction = nil;
    
    // Create a session
    _skSession = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl] appToken:SKSAppKey];
    
    if (!_skSession) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"SpeechKit"
                                                           message:@"Failed to initialize SpeechKit session."
                                                          delegate:nil cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self loadEarcons];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"start"
                                         ofType:@"mp3"]];
    playStart = [[AVAudioPlayer alloc]
                 initWithContentsOfURL:url
                 error:nil];
    [playStart setVolume: 1.0];
    
    url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                  pathForResource:@"finish"
                                  ofType:@"mp3"]];
    stopStart = [[AVAudioPlayer alloc]
                 initWithContentsOfURL:url
                 error:nil];
    [stopStart setVolume: 1.0];
}

-(void)backToApplication:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue_onvego_0_5" sender:self];
    }
}

- (void) clickSwitch:(id)sender{
    UISwitch* clickSwitcher = sender;
    int index = clickSwitcher.tag;
    currPhrase = ((Phrase*)[phrasesOnvego objectAtIndex:index]).text;
    [buttonChoosePhrase setTitle:currPhrase forState:UIControlStateNormal];
    viewForChoosePhrase.removeFromSuperview;
    clickSwitcher.on = NO;
}

- (void) clickCancel:(id)sender{
    viewForChoosePhrase.removeFromSuperview;
    [buttonChoosePhrase setTitle:@"Choose phrase" forState:UIControlStateNormal];
}

- (NSMutableArray*)getPhrases{
    NSString* servletName = @"GetPhrases";
    NSString* urlString = [NSString stringWithFormat:@"http://%@:%@/%@/%@",ip,port,serverName,servletName];
    urlString = [NSString stringWithFormat:@"%@/%@",baseUrl,servletName];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"orgName=%@&appKey=%@&controller=%@&password=%@",@"TimeToKnow", appKey,[NSString stringWithFormat:@"%@_controller",appKey],password] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    [self ValidateChars:returnData];
    if (![self checkException:returnString]) {
        NSMutableArray* emptyArray = [[NSMutableArray alloc] init];
        return emptyArray;
    }
    NSString* fixedString = [self getValidateString:returnString];
   // NSString * strRR = [NSString stringWithFormat:@"%@%@%@", @"{\"phrases\":", returnString, @"}"];
    NSData *data = [fixedString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* answer = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:&error];
    NSMutableArray *temp_phrases = [answer objectForKey:@"phrases"];
    
    NSMutableArray* phrases = [[NSMutableArray alloc] init];
    for (int i = 0; i < temp_phrases.count; i++) {
        NSDictionary* dic = [temp_phrases objectAtIndex:i];
        Phrase* phrase = [[Phrase alloc]init];
        NSString* text = [dic objectForKey:@"phrase"];
        NSLog(text);
        phrase.text = text;
        int count = [[dic objectForKey:@"count"] integerValue];
        phrase.count = count;
        NSMutableArray* asrResults = [[NSMutableArray alloc] init];
        NSMutableArray* temp_asrRestults = [dic objectForKey:@"AsrResults"];
        for (int j = 0; j < temp_asrRestults.count; j++) {
            NSDictionary* dic = [temp_asrRestults objectAtIndex:j];
            AsrResult* asrResult = [[AsrResult alloc]init];
            NSString* text = [dic objectForKey:@"phrase"];
            asrResult.text = text;
            int count = [[dic objectForKey:@"count"] integerValue];
            asrResult.count = count;
            [asrResults addObject:asrResult];
        }
        phrase.asrResults = asrResults;
        [phrases addObject:phrase];
    }
    return phrases;
}

- (void)uploadPhrases{
    NSString* servletName = @"TeachListOfPhrases";
    NSString* urlString = [NSString stringWithFormat:@"http://%@:%@/%@/%@",ip,port,serverName,servletName];
    urlString = [NSString stringWithFormat:@"%@/%@",baseUrl,servletName];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString* phrasesString = @"";
    for (NSString* phrase in phrasesApp) {
        phrasesString = [phrasesString stringByAppendingString:[NSString stringWithFormat:@"%@|",phrase]];
    }
    if (phrasesString.length != 0) {
        phrasesString = [phrasesString substringToIndex:phrasesString.length - 1];
    }
    
    NSData* dasd = [[NSString stringWithFormat:@"orgName=%@&appKey=%@&controller=%@&password=%@&phrases=%@",@"TimeToKnow" ,appKey,[NSString stringWithFormat:@"%@_controller",appKey],password,phrasesString] dataUsingEncoding:NSUTF8StringEncoding];
    [self ValidateChars:dasd];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"orgName=%@&appKey=%@&controller=%@&password=%@&phrases=%@",@"TimeToKnow" ,appKey,[NSString stringWithFormat:@"%@_controller",appKey],password,phrasesString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(returnString);
    if ([self checkException:returnString]) {
        
    }
    returnString = @"FAIl";
    if ([[returnString lowercaseString] isEqualToString:@"fail"]) {
        NSString* servletName = @"TeachListOfPhrases";
        NSString* urlString = [NSString stringWithFormat:@"http://%@:%@/%@/%@",ip,port,serverName,servletName];
        urlString = [NSString stringWithFormat:@"%@/%@",baseUrl,servletName];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString* phrasesString = @"";
        for (NSString* phrase in phrasesApp) {
            phrasesString = [phrasesString stringByAppendingString:[NSString stringWithFormat:@"%@|",phrase]];
        }
        if (phrasesString.length != 0) {
            phrasesString = [phrasesString substringToIndex:phrasesString.length - 1];
        }
        
        NSData* dasd = [[NSString stringWithFormat:@"orgName=%@&appKey=%@&controller=%@&password=%@&phrases=%@",@"TimeToKnow" ,appKey,[NSString stringWithFormat:@"%@_controller",appKey],password,phrasesString] dataUsingEncoding:NSUTF8StringEncoding];
        [self ValidateChars:dasd];
        
        [request setHTTPBody:[[NSString stringWithFormat:@"orgName=%@&appKey=%@&controller=%@&password=%@&phrases=%@",@"TimeToKnow" ,appKey,[NSString stringWithFormat:@"%@_controller",appKey],password,phrasesString] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setURL:[NSURL URLWithString:urlString]];
        request.HTTPMethod = @"POST";
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString* returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(returnString);
        if ([self checkException:returnString]) {
            
        }
    }
}


-(void)ValidateChars:(NSData*)data{
    unsigned char *bytePtr = (unsigned char *)[data bytes];
    NSInteger totalData = [data length] / sizeof(uint8_t);
    for(int i = 0; i < totalData; i++) {
        int asciiCode = bytePtr[i];
        if (asciiCode > 128 || asciiCode < 32) {
            NSLog(@"Fixed wrong char from TalkAbout Server(Onvego)");
        }
    }
}

-(NSString*)getValidateString:(NSString*)string{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char *bytePtr = (unsigned char *)[data bytes];
    NSInteger totalData = [data length] / sizeof(uint8_t);
    for(int i = 0; i < totalData; i++) {
        int asciiCode = bytePtr[i];
        if (asciiCode > 128 || asciiCode < 32) {
            bytePtr[i] = 32;
        }
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (IBAction)onClickListPhrases:(id)sender {
    int heightButtons = 80;
    if (!showPhrases) {
        phrasesOnvego = [self getPhrases];
        int index = 0;
        UIView* viewToFill = [[UIView alloc] init];
        for (Phrase* phrase in phrasesOnvego) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, index*45, viewPhrases.frame.size.width, 30)];
            [label setTextColor:[UIColor whiteColor]];
            [label setText:[NSString stringWithFormat:@"%@(%d)",phrase.text,phrase.count]];
            label.adjustsFontSizeToFitWidth= YES;
            label.numberOfLines = 0;
            label.minimumFontSize = 1;
            label.textAlignment = NSTextAlignmentCenter;
            [viewToFill addSubview:label];
            index++;
        }
        [viewToFill setFrame:CGRectMake(0, heightButtons, viewPhrases.frame.size.width, index*45)];
        currPhrases = viewToFill;
        [viewPhrases addSubview:viewToFill];
        showPhrases = YES;
        
        int heghtView =viewToFill.frame.size.height + heightButtons + buttonChoosePhrase.frame.size.height + _toggleRecogButton.frame.size.height + 40;
        [viewPhrases setContentSize:CGSizeMake(viewPhrases.frame.size.width, heghtView)];
        
        [buttonChoosePhrase.superview removeConstraints:constraintHeight];
        NSDictionary *viewsDictionary = @{@"redView":buttonChoosePhrase,@"yellowView":viewToFill};
        constraintRel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[yellowView]-8-[redView]"
                                                                options:0
                                                                metrics:nil
                                                                  views:viewsDictionary];
        [buttonListPhrases setTitle:@"Close list of phrases" forState:UIControlStateNormal];
        [buttonChoosePhrase.superview addConstraints:constraintRel];
    }else{
        [currPhrases removeFromSuperview];
        showPhrases = NO;
        
        [buttonListPhrases setTitle:@"Open list of phrases" forState:UIControlStateNormal];
        
        [viewPhrases setContentSize:CGSizeMake(viewPhrases.frame.size.width, self.view.frame.size.height/2)];
        
        [buttonChoosePhrase.superview removeConstraints:constraintRel];
        [buttonChoosePhrase.superview addConstraints:constraintHeight];
    }
}

- (IBAction)clickChoosepPhrase:(id)sender {
    if (phrasesOnvego == nil) {
        return;
    }
    viewForChoosePhrase = [[UIView alloc] init];
    [viewForChoosePhrase setBackgroundColor:[UIColor blackColor]];
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [button.layer setBorderWidth:2];
    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [viewForChoosePhrase addSubview:button];
    
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    int futureHeight = 15;
    int index = 0;
    for (Phrase* phrase in phrasesOnvego) {
        int length = phrase.text.length;
        int labelHeight = length+20;
        
        UIView* cellView = [[UIView alloc] initWithFrame:CGRectMake(0, futureHeight, viewPhrases.frame.size.width, labelHeight)];
        UISwitch* switcher = [[UISwitch alloc] init];
        switcher.tag = index;
        [switcher addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
        [cellView addSubview:switcher];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(switcher.frame.size.width + 8, 0, viewPhrases.frame.size.width - switcher.frame.size.width - 8, labelHeight)];
        futureHeight += labelHeight;
        futureHeight += labelHeight;
        [label setTextColor:[UIColor whiteColor]];
        [label setText:[NSString stringWithFormat:@"%@(%d)",phrase.text,phrase.count]];
        //label.adjustsFontSizeToFitWidth= YES;
        label.numberOfLines = 0;
        label.minimumFontSize = 1;
        //label.textAlignment = NSTextAlignmentCenter;
        [cellView addSubview:label];
        [scrollView addSubview:cellView];
        index++;
    }
    scrollView.frame = CGRectMake(0, button.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.75 - button.frame.size.height);
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, futureHeight + button.frame.size.height)];
    viewForChoosePhrase.frame = CGRectMake(0, self.view.frame.size.height*0.12, self.view.frame.size.width, self.view.frame.size.height*0.75);
    [viewForChoosePhrase addSubview:scrollView];
    [self.view addSubview:viewForChoosePhrase];
}

#pragma mark - ASR Actions

- (IBAction)toggleRecognition:(UIButton *)sender
{
    if (currPhrase == nil) {
        return;
    }
    switch (_state) {
        case SKSIdle:
            [self recognize];
            break;
        case SKSListening:
            [self stopRecording];
            break;
        case SKSProcessing:
            [self cancel];
            break;
        default:
            break;
    }
}

- (void)recognize
{
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.4];
    [_toggleRecogButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    // Start listening to the user.
    //[_toggleRecogButton setTitle:@"Stop" forState:UIControlStateNormal];
    
    [playStart play];
    
    _skTransaction = [_skSession recognizeWithType:self.recognitionType
                                         detection:self.endpointer
                                          language:self.language
                                          delegate:self];
}

- (void)stopRecording
{
    [_toggleRecogButton.layer removeAllAnimations];
    [_toggleRecogButton setEnabled:YES];
    // Stop recording the user.
    [_skTransaction stopRecording];
    // Disable the button until we received notification that the transaction is completed.
    [_toggleRecogButton setEnabled:NO];
}

- (void)cancel
{
    [_toggleRecogButton.layer removeAllAnimations];
    [_toggleRecogButton setEnabled:YES];
    // Cancel the Reco transaction.
    // This will only cancel if we have not received a response from the server yet.
    [_skTransaction cancel];
}

# pragma mark - SKTransactionDelegate

- (void)transactionDidBeginRecording:(SKTransaction *)transaction
{
    [self log:@"transactionDidBeginRecording"];
    
    _state = SKSListening;
    [self startPollingVolume];
    // [_toggleRecogButton setTitle:@"Listening.." forState:UIControlStateNormal];
}

- (void)transactionDidFinishRecording:(SKTransaction *)transaction
{
    [_toggleRecogButton.layer removeAllAnimations];
    [self log:@"transactionDidFinishRecording"];
    
    _state = SKSProcessing;
    //[_toggleRecogButton setTitle:@"Processing.." forState:UIControlStateNormal];
}

- (void)transaction:(SKTransaction *)transaction didReceiveRecognition:(SKRecognition *)recognition
{
    NSArray* phrases = [recognition details];
    NSString* message = @"";
    for (SKRecognizedPhrase* phrase in phrases) {
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@(%ld)\n",phrase.text,(long)phrase.confidence]];
    }
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:currPhrase
                                                       message:message
                                                      delegate:self cancelButtonTitle:nil
                                             otherButtonTitles:@"Accept", @"Decline", nil];
    [alertView show];
    currPhrasesOnvego = phrases;
}

- (void)transaction:(SKTransaction *)transaction didReceiveServiceResponse:(NSDictionary *)response
{
    [self log:[NSString stringWithFormat:@"didReceiveServiceResponse: %@", response]];
}

- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
    [stopStart play];
    [self log:@"didFinishWithSuggestion"];
    
    _state = SKSIdle;
    [self resetTransaction];
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    [self log:[NSString stringWithFormat:@"didFailWithError: %@. %@", [error description], suggestion]];
    
    // Something went wrong. Ensure that your credentials are correct.
    // The user could also be offline, so be sure to handle this case appropriately.
    
    _state = SKSIdle;
    [self resetTransaction];
}

# pragma mark - Volume level

- (void)startPollingVolume
{
    // Every 50 milliseconds we should update the volume meter in our UI.
    _volumePollTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                        target:self
                                                      selector:@selector(pollVolume)
                                                      userInfo:nil repeats:YES];
}

- (void) pollVolume
{
    float volumeLevel = [_skTransaction audioLevel];
}

- (void) stopPollingVolume
{
    [_volumePollTimer invalidate];
    _volumePollTimer = nil;
}

#pragma mark - Helpers

- (void)log:(NSString *)message
{
    //NSLog([NSString stringWithFormat:@"%@\n", message]);
}

- (void)resetTransaction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _skTransaction = nil;
        //[_toggleRecogButton setTitle:@"recognizeWithType" forState:UIControlStateNormal];
        [_toggleRecogButton setEnabled:YES];
    }];
}

- (void)loadEarcons
{
    // Load all of the earcons from disk
    NSString* startEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_start" ofType:@"pcm"];
    NSString* stopEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_stop" ofType:@"pcm"];
    NSString* errorEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_error" ofType:@"pcm"];
    
    SKPCMFormat* audioFormat = [[SKPCMFormat alloc] init];
    audioFormat.sampleFormat = SKPCMSampleFormatSignedLinear16;
    audioFormat.sampleRate = 16000;
    audioFormat.channels = 1;
    
    // Attach them to the session
    
    //    _skSession.startEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:startEarconPath] pcmFormat:audioFormat];
    //    _skSession.endEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:stopEarconPath] pcmFormat:audioFormat];
    _skSession.errorEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:errorEarconPath] pcmFormat:audioFormat];
}
-(void)TeachPhrase:(NSArray*)rawPhrases{
    NSString* asrResults = @"";
    NSString* confLevels = @"";
    for (SKRecognizedPhrase* phrase in rawPhrases) {
        asrResults = [asrResults stringByAppendingString:[NSString stringWithFormat:@"%@|",phrase.text]];
        confLevels = [confLevels stringByAppendingString:[NSString stringWithFormat:@"%@|",[NSString stringWithFormat:@"%ld",(long)phrase.confidence]]];
    }
    
    if (asrResults.length != 0) {
        asrResults = [asrResults substringToIndex:asrResults.length - 1];
    }
    if (confLevels.length != 0) {
        confLevels = [confLevels substringToIndex:confLevels.length - 1];
    }
    
    [self TeachPhrase:currPhrase asrResults:asrResults confLevels:confLevels];
}

-(void)TeachPhrase:(NSString*)origPhrase asrResults:(NSString*)asrResults confLevels:(NSString*)confLevels{
    NSString* servletName = @"TeachPhrase";
    NSString* urlString = [NSString stringWithFormat:@"http://%@:%@/%@/%@",ip,port,serverName,servletName];
    urlString = [NSString stringWithFormat:@"%@/%@",baseUrl,servletName];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setHTTPBody:[[NSString stringWithFormat:@"orgName=%@&appKey=%@&controller=%@&password=%@&phrase=%@&asrResults=%@&confLevels=%@",@"TimeToKnow", appKey,[NSString stringWithFormat:@"%@_controller",appKey],password,origPhrase,asrResults,confLevels] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(returnString);
    if ([self checkException:returnString]) {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
    }else{
        [self TeachPhrase:currPhrasesOnvego];
    }
}

- (BOOL)checkException:(NSString*)messageAnswer{
    if (messageAnswer.length > 3 && [[messageAnswer substringToIndex:4] isEqualToString:@"err-"]) {
        NSString* message;
        if ([messageAnswer isEqualToString:OnvegoAppKeyNotFoundException]) {
            message = @"Onvego application key not found";
        }else if ([messageAnswer isEqualToString:OnvegoLicenseExpiredException]){
            message = @"Onvego license expired";
        }else if ([messageAnswer isEqualToString:OnvegoGeneralException]){
            message = @"Onvego general error";
        }
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Onvego"
                                                           message:message
                                                          delegate:nil cancelButtonTitle:@"Close"
                                                 otherButtonTitles:nil, nil];
        [alertView show];

        return false;
    }
    return true;
}

@end
