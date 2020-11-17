//
//  QuestionsScreenController.m
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "QuestionsScreenController.h"
#import "CellAnswersView.h"
#import "SKSConfiguration.h"
#import <SpeechKit/SpeechKit.h>

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

#if !defined(MIN)
#define MIN(A,B)((A) < (B) ? (A) : (B))
#endif

enum {
    SKSIdle = 1,
    SKSListening = 2,
    SKSProcessing = 3
};
typedef NSUInteger SKSState;


@interface QuestionsScreenController () <SKTransactionDelegate> {
    SKSession* _skSession;
    SKTransaction *_skTransaction;
    
    SKSState _state;
    
    NSTimer *_volumePollTimer;
}

@end

@implementation QuestionsScreenController
@synthesize ImageViewBackground;
@synthesize ScrollView;
@synthesize category;
@synthesize subject;
@synthesize ImageParrot;
@synthesize imageWhite;
@synthesize buttonNext;
@synthesize viewForDialog;
@synthesize ImageBack;

@synthesize toggleRecogButton = _toggleRecogButton;
@synthesize language = _language;
@synthesize recognitionType = _recognitionType;
@synthesize endpointer = _endpointer;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* imageName = [category getImageName];
    UIImage* image = [Static getImage:imageName];
    [ImageViewBackground setImage:image];
    
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
    
    UITapGestureRecognizer *tapGR1;
    tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTappp:)];
    tapGR1.numberOfTapsRequired = 1;
    tapGR1.cancelsTouchesInView = NO;
    UITapGestureRecognizer *tapGR2;
    tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTappp:)];
    tapGR2.numberOfTapsRequired = 1;
    tapGR2.cancelsTouchesInView = NO;
    [ImageParrot setUserInteractionEnabled:YES];
    [ImageBack setUserInteractionEnabled:YES];
    [ImageParrot addGestureRecognizer:tapGR1];
    [ImageBack addGestureRecognizer:tapGR2];
    
    indexOfQuestion = 0;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIndexOfQuestion:) name:@"update_index" object:nil];
    counter = 0;
    
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

-(void)viewDidAppear:(BOOL)animated{
    [self fillUI];
    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
    UILabel* label = [[UILabel alloc]init];
    UIFont* font = [UIFont fontWithName:label.font.fontName size:13.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    UIFont* font1 = [UIFont fontWithName:label.font.fontName size:15.0];
    NSDictionary *attrsDictionary1 = [NSDictionary dictionaryWithObject:font1
                                                                 forKey:NSFontAttributeName];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"Speak\r"] attributes:attrsDictionary1];
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"Record the correct reply"] attributes:attrsDictionary];
    [answersString appendAttributedString:attrString1];
    [answersString appendAttributedString:attrString2];
    CellAlertView* cell = [[CellAlertView alloc]initWithFrame:CGRectMake(0, viewForDialog.frame.size.height*0.25, viewForDialog.frame.size.width, viewForDialog.frame.size.height*0.6)];
    [cell setText:answersString];
    [viewForDialog addSubview:cell];
    UITapGestureRecognizer *tapGR;
    tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapp:)];
    tapGR.numberOfTapsRequired = 1;
    tapGR.cancelsTouchesInView = NO;
    [cell setUserInteractionEnabled:YES];
    [cell addGestureRecognizer:tapGR];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleTapp:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (lastPhrase != nil && lastPhrase.count > 1) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Last Phrase"
                                                               message:[NSString stringWithFormat:@"Text:%@, Grade:%d",[lastPhrase objectAtIndex:0],(int)([[lastPhrase objectAtIndex:1] floatValue]/(float)10)]
                                                              delegate:nil cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

-(void)handleTappp:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue54" sender:self];
    }
}

- (IBAction)clickNext:(id)sender {
    indexOfQuestion++;
    if (indexOfQuestion < [[subject getQuestions] count]) {
        [self fillUI];
    }else{
        [self performSegueWithIdentifier:@"segue56" sender:self];
    }
}

-(void) updateIndexOfQuestion:(NSNotification *) obj{
    indexOfQuestion++;
    if (indexOfQuestion < [[subject getQuestions] count]) {
        [self fillUI];
    }else{
        [self performSegueWithIdentifier:@"segue56" sender:self];
    }
}

-(void)fillUI{
    //    [UIView animateWithDuration:0.05f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
    //        [imageWhite setAlpha:0.2f];
    //    } completion:^(BOOL finished) {
    //        [UIView animateWithDuration:0.05f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
    //            [imageWhite setAlpha:0.f];
    //        } completion:nil];
    //    }];
    
    NSMutableArray *myArray = [subject getQuestions];
    curQuestion = [myArray objectAtIndex:indexOfQuestion];
    NSMutableArray* answers = [curQuestion getAnswers];
    UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    answersString = [[NSMutableAttributedString alloc]init];
    for (int i = 0; i < [answers count]; i++) {
        Answer* answer = [answers objectAtIndex:i];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",(i+1)] attributes:attrsDictionary];
        NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",@". ",[answer getText],@"\r\r"]];
        [answersString appendAttributedString:attrString];
        [answersString appendAttributedString:str];
    }
    
    counter = 0;
    [Progress SetTotalQuestions:[Progress GetTotalQuestions]+1];
    NSArray *viewsToRemove = [ScrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    int count = [myArray count];
    int height = self.ScrollView.frame.size.width/2.5;
    if (count != 0) {
        CellQuestionView* cell1 = [[CellQuestionView alloc]initWithFrame:CGRectMake(0, 0, self.ScrollView.frame.size.width, height)];
        NSString* imageName = [curQuestion getImageName];
        UIImage* image = [Static getImage:imageName];
        [cell1 setText:[curQuestion getText]];
        [cell1 setImagee:image size:height];
        [self.ScrollView addSubview:cell1];
        
        int ansHeight = 0;
        NSMutableArray* answers = [curQuestion getAnswers];
        if (answers != nil) {
            ansHeight = height/3*[answers count];
            cellAnswers = [[CellAnswersView alloc]initWithFrame:CGRectMake(0, height, self.ScrollView.frame.size.width, ansHeight)];
            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerPressed:) name:@"notificaiton_name" object:nil];
            [cellAnswers setAnswers:answersString heightView:ansHeight widthView:self.ScrollView.frame.size.width/1.2 answer:NO];
            [self.ScrollView addSubview:cellAnswers];
            
            if (!(indexOfQuestion == 0)) {
                CGPoint startPoint = (CGPoint){-(self.ScrollView.frame.size.width/2), height+ansHeight/2};
                CGPoint middlePoint = (CGPoint){self.ScrollView.frame.size.width/2, height+ansHeight/2};
                
                CGMutablePathRef thePath = CGPathCreateMutable();
                CGPathMoveToPoint(thePath, NULL, startPoint.x, startPoint.y);
                CGPathAddLineToPoint(thePath, NULL, middlePoint.x, middlePoint.y);
                
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                animation.duration = 0.7f;
                animation.path = thePath;
                [cellAnswers.layer addAnimation:animation forKey:@"position"];
                cellAnswers.layer.position = middlePoint;
            }
            
            cellAnswer = [[CellAnswersView alloc]initWithFrame:CGRectMake(0, height + ansHeight, self.ScrollView.frame.size.width, height/1.5)];
            
            [self.ScrollView addSubview:cellAnswer];
        }
    }
    for (Answer* answer in [curQuestion getAnswers]) {
        if ([answer getNumber] == [curQuestion getSolutionNumber]) {
            rightAnswer = [answer getText];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ASR Actions

- (IBAction)toggleRecognition:(UIButton *)sender
{
    switch (_state) {
        case SKSIdle:
            [cellAnswer setAnswers:nil heightView:((float)cellAnswer.frame.size.height/(float)1.5) widthView:cellAnswer.frame.size.width/1.2 answer:YES];
            
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
    [buttonNext setEnabled:NO];
    curQuestion = [[subject getQuestions] objectAtIndex:indexOfQuestion];
    NSMutableArray* answers = [curQuestion getAnswers];
    UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    answersString = [[NSMutableAttributedString alloc]init];
    for (int i = 0; i < [answers count]; i++) {
        Answer* answer = [answers objectAtIndex:i];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",(i+1)] attributes:attrsDictionary];
        NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",@". ",[answer getText],@"\r\r"]];
        [answersString appendAttributedString:attrString];
        [answersString appendAttributedString:str];
    }
    int height = self.ScrollView.frame.size.width/2.5;
    int ansHeight = height/3*[answers count];
    [cellAnswers setAnswers:answersString heightView:ansHeight widthView:self.ScrollView.frame.size.width/1.2 answer:NO];
    
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
    [buttonNext setEnabled:YES];
    // Stop recording the user.
    [_skTransaction stopRecording];
    // Disable the button until we received notification that the transaction is completed.
    [_toggleRecogButton setEnabled:NO];
}

- (void)cancel
{
    [_toggleRecogButton.layer removeAllAnimations];
    [buttonNext setEnabled:YES];
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
    [self log:[NSString stringWithFormat:@"didReceiveRecognition: %@", recognition.text]];
    _state = SKSIdle;
    
    NSArray* phrases = [recognition details];
    
    NSString* asrResults = @"";
    NSString* confLevels = @"";
    for (SKRecognizedPhrase* phrase in phrases) {
        asrResults = [asrResults stringByAppendingString:[NSString stringWithFormat:@"%@|",phrase.text]];
        confLevels = [confLevels stringByAppendingString:[NSString stringWithFormat:@"%@|",[NSString stringWithFormat:@"%ld",(long)phrase.confidence]]];
    }
    
    if (asrResults.length != 0) {
        asrResults = [asrResults substringToIndex:asrResults.length - 1];
    }
    if (confLevels.length != 0) {
        confLevels = [confLevels substringToIndex:confLevels.length - 1];
    }
    
    NSString* answerTemp = [self getPhraseFromAsrResults:asrResults confLevels:confLevels];
    
    NSString* string = [curQuestion getFailureText];
    
    if ([self checkException:answerTemp]) {
        if ([answerTemp isEqualToString:OnvegoPhraseNotFoundException] || [answerTemp isEqualToString:@"ERR-1002-noMatch"]) {
            
            lastPhrase = [[NSMutableArray alloc] init];
            [lastPhrase addObject:@""];
            [lastPhrase addObject:[NSString stringWithFormat:@"%d",-1]];
            
            for (SKRecognizedPhrase* phrase in phrases) {
                if ([phrase confidence] > [[lastPhrase objectAtIndex:1] floatValue]) {
                    lastPhrase = [[NSMutableArray alloc] init];
                    [lastPhrase addObject:[phrase text]];
                    [lastPhrase addObject:[NSString stringWithFormat:@"%ld",(long)[phrase confidence]]];
                }
            }
            
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:string
                                                               message:[NSString stringWithFormat:@"%@%@\rAccuracy:%d%@",[lastPhrase objectAtIndex:0],@"\rWas not found",(int)([[lastPhrase objectAtIndex:1] floatValue]/(float)10),@"%"]
                                                              delegate:nil cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
            counter++;
            [Progress SetRetries:[Progress GetRetries]+1];
            int result = (((float)10*(float)0.5 + ([[lastPhrase objectAtIndex:1] floatValue]/(float)10)*(float)0.5)*(100-(counter-1)*10))/100;
            [Progress SetSumStatistic:([Progress GetSumStatistic]+result)];
            if (result > 100) {
                NSLog(@"XXX progress error");
            }
            [buttonNext setEnabled:YES];
            return;
        }
    }else{
        return;
    }
    
    lastPhrase = [answerTemp componentsSeparatedByString:@"|"];
    
    if (lastPhrase.count < 2) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:string
                                                           message:@"Phrase not found"
                                                          delegate:nil cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    float grade = [[lastPhrase objectAtIndex:1] floatValue] * 1000;
    
    [lastPhrase removeObjectAtIndex:1];
    [lastPhrase addObject:[NSString stringWithFormat:@"%d",grade]];
    
    BOOL right = false;
    
    BOOL found = false;
    
    int index = -1;
    
    int i = 0;
    for (Answer* answer in [curQuestion getAnswers]) {
        if ([[[answer getText] lowercaseString] isEqualToString:[[lastPhrase objectAtIndex:0] lowercaseString]]) {
            index = i;
            found = true;
            if ([[rightAnswer lowercaseString] isEqualToString:[[lastPhrase objectAtIndex:0] lowercaseString]]) {
                right = true;
            }
        }
        i++;
    }
    grade = MIN(1000, grade);
    
    if (right) {
        string = [NSString stringWithFormat:@"%@\rAccuracy:%d%@",[curQuestion getSuccessText],(int)((float)grade/(float)10),@"%"];
        NSMutableArray *myArray = [subject getQuestions];
        curQuestion = [myArray objectAtIndex:indexOfQuestion];
        NSMutableArray* answers = [curQuestion getAnswers];
        UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
        answersString = [[NSMutableAttributedString alloc]init];
        for (int i = 0; i < [answers count]; i++) {
            Answer* answer = [answers objectAtIndex:i];
            if (i == index) {
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor greenColor]
                                                                            forKey:NSForegroundColorAttributeName];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%@%@%@",(i+1),@". ",[answer getText],@"\r\r"] attributes:attrsDictionary];
                [answersString appendAttributedString:attrString];
            }else{
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                            forKey:NSFontAttributeName];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",(i+1)] attributes:attrsDictionary];
                NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",@". ",[answer getText],@"\r\r"]];
                
                [answersString appendAttributedString:attrString];
                [answersString appendAttributedString:str];
            }
        }
        int height = self.ScrollView.frame.size.width/2.5;
        int ansHeight = height/3*[answers count];
        [cellAnswers setAnswers:answersString heightView:ansHeight widthView:self.ScrollView.frame.size.width/1.2 answer:NO];
    }else if(found){
        string = [NSString stringWithFormat:@"%@\rAccuracy:%d%@",[curQuestion getFailureText],(int)((float)grade/(float)10),@"%"];
        NSMutableArray *myArray = [subject getQuestions];
        curQuestion = [myArray objectAtIndex:indexOfQuestion];
        NSMutableArray* answers = [curQuestion getAnswers];
        UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
        answersString = [[NSMutableAttributedString alloc]init];
        for (int i = 0; i < [answers count]; i++) {
            Answer* answer = [answers objectAtIndex:i];
            if (i == index) {
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor redColor]
                                                                            forKey:NSForegroundColorAttributeName];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%@%@%@",(i+1),@". ",[answer getText],@"\r\r"] attributes:attrsDictionary];
                [answersString appendAttributedString:attrString];
            }else{
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                            forKey:NSFontAttributeName];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",(i+1)] attributes:attrsDictionary];
                NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",@". ",[answer getText],@"\r\r"]];
                
                [answersString appendAttributedString:attrString];
                [answersString appendAttributedString:str];
            }
        }
        int height = self.ScrollView.frame.size.width/2.5;
        int ansHeight = height/3*[answers count];
        [cellAnswers setAnswers:answersString heightView:ansHeight widthView:self.ScrollView.frame.size.width/1.2 answer:NO];
    }else{
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:string
                                                           message:[NSString stringWithFormat:@"%@%@\rAccuracy:%d%@",[lastPhrase objectAtIndex:0],@"\rWas not found",(int)([[lastPhrase objectAtIndex:1] floatValue]/(float)10),@"%"]
                                                          delegate:nil cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil, nil];
        [alertView show];

    }
    
    UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string] attributes:attrsDictionary];
    NSMutableAttributedString *answersStringg = [[NSMutableAttributedString alloc]init];
    [answersStringg appendAttributedString:attrString];
    [cellAnswer setAnswers:answersStringg heightView:((float)cellAnswer.frame.size.height/(float)1.5) widthView:cellAnswer.frame.size.width/1.2 answer:YES];
    
    
    if (counter < 2) {
        counter++;
        [Progress SetRetries:[Progress GetRetries]+1];
        if (right) {
            int result = (((float)100*(float)0.5 + ((float)grade/(float)10)*(float)0.5)*(100-(counter-1)*10))/100;
            [Progress SetSumStatistic:([Progress GetSumStatistic]+result)];
            [Progress SetSuccessAnswers:[Progress GetSuccessAnswers]+1];
            if (result > 100) {
                NSLog(@"XXX progress error");
            }
        }else{
            int result = (((float)10*(float)0.5 + ((float)grade/(float)10)*(float)0.5)*(100-(counter-1)*10))/100;
            [Progress SetSumStatistic:([Progress GetSumStatistic]+result)];
            if (result > 100) {
                NSLog(@"XXX progress error");
            }
        }
    }
    [buttonNext setEnabled:YES];
}

//- (void)transaction:(SKTransaction *)transaction didReceiveRecognition:(SKRecognition *)recognition
//{
//    NSLog([NSString stringWithFormat:@"%@", @"-----------------------"]);
//
//    NSArray* phrases = [recognition details];
//
//    BOOL right = false;
//
//    BOOL found = false;
//
//    float grade = 0;
//
//    float wrongGrade = 0;
//
//    int index = -1;
//
//    SKRecognizedPhrase* wrongPhrase;
//
//    for (SKRecognizedPhrase* phrase in phrases) {
//        NSLog([NSString stringWithFormat:@"Text:%@,confidence:%ld", [phrase text],(long)[phrase confidence]]);
//        int i = 0;
//        for (Answer* answer in [curQuestion getAnswers]) {
//            if ([[[answer getText] lowercaseString] isEqualToString:[[phrase text] lowercaseString]]) {
//                found = true;
//                grade = [phrase confidence];
//                index = i;
//                lastPhrase = phrase;
//                if ([[rightAnswer lowercaseString] isEqualToString:[[lastPhrase text] lowercaseString]]) {
//                    right = true;
//                }
//            }
//            i++;
//        }
//        if ([phrase confidence] > wrongGrade) {
//            wrongPhrase = phrase;
//            wrongGrade = [phrase confidence];
//        }
//    }
//
//    wrongGrade = MIN(1000, wrongGrade);
//    grade = MIN(1000, grade);
//    _state = SKSIdle;
//    NSLog([NSString stringWithFormat:@"%@", @"-----------------------"]);
//
//    [self log:[NSString stringWithFormat:@"didReceiveRecognition: %@", recognition.text]];
//
//    NSString* string = [curQuestion getFailureText];
//    if (found) {
//        if (right) {
//            string = [NSString stringWithFormat:@"%@\rAccuracy:%d%@",[curQuestion getSuccessText],(int)((float)grade/(float)10),@"%"];
//            NSMutableArray *myArray = [subject getQuestions];
//            curQuestion = [myArray objectAtIndex:indexOfQuestion];
//            NSMutableArray* answers = [curQuestion getAnswers];
//            UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
//            answersString = [[NSMutableAttributedString alloc]init];
//            for (int i = 0; i < [answers count]; i++) {
//                Answer* answer = [answers objectAtIndex:i];
//                if (i == index) {
//                    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor greenColor]
//                                                                                forKey:NSForegroundColorAttributeName];
//                    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%@%@%@",(i+1),@". ",[answer getText],@"\r\r"] attributes:attrsDictionary];
//                    [answersString appendAttributedString:attrString];
//                }else{
//                    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
//                                                                                forKey:NSFontAttributeName];
//                    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",(i+1)] attributes:attrsDictionary];
//                    NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",@". ",[answer getText],@"\r\r"]];
//
//                    [answersString appendAttributedString:attrString];
//                    [answersString appendAttributedString:str];
//                }
//            }
//            int height = self.ScrollView.frame.size.width/2.5;
//            int ansHeight = height/3*[answers count];
//            [cellAnswers setAnswers:answersString heightView:ansHeight widthView:self.ScrollView.frame.size.width/1.2 answer:NO];
//        }else{
//            string = [NSString stringWithFormat:@"%@\rAccuracy:%d%@",[curQuestion getFailureText],(int)((float)grade/(float)10),@"%"];
//            NSMutableArray *myArray = [subject getQuestions];
//            curQuestion = [myArray objectAtIndex:indexOfQuestion];
//            NSMutableArray* answers = [curQuestion getAnswers];
//            UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
//            answersString = [[NSMutableAttributedString alloc]init];
//            for (int i = 0; i < [answers count]; i++) {
//                Answer* answer = [answers objectAtIndex:i];
//                if (i == index) {
//                    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor redColor]
//                                                                                forKey:NSForegroundColorAttributeName];
//                    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%@%@%@",(i+1),@". ",[answer getText],@"\r\r"] attributes:attrsDictionary];
//                    [answersString appendAttributedString:attrString];
//                }else{
//                    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
//                                                                                forKey:NSFontAttributeName];
//                    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",(i+1)] attributes:attrsDictionary];
//                    NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",@". ",[answer getText],@"\r\r"]];
//
//                    [answersString appendAttributedString:attrString];
//                    [answersString appendAttributedString:str];
//                }
//            }
//            int height = self.ScrollView.frame.size.width/2.5;
//            int ansHeight = height/3*[answers count];
//            [cellAnswers setAnswers:answersString heightView:ansHeight widthView:self.ScrollView.frame.size.width/1.2 answer:NO];
//        }
//        UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
//        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
//                                                                    forKey:NSFontAttributeName];
//        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string] attributes:attrsDictionary];
//        NSMutableAttributedString *answersStringg = [[NSMutableAttributedString alloc]init];
//        [answersStringg appendAttributedString:attrString];
//        [cellAnswer setAnswers:answersStringg heightView:((float)cellAnswer.frame.size.height/(float)1.5) widthView:cellAnswer.frame.size.width/1.2 answer:YES];
//    }else{
//        lastPhrase = wrongPhrase;
//        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:string
//                                                           message:[NSString stringWithFormat:@"%@%@\rAccuracy:%d%@",[lastPhrase text],@"\rWas not found",(int)((float)wrongGrade/(float)10),@"%"]
//                                                          delegate:nil cancelButtonTitle:@"Ok"
//                                                 otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//
//    if (counter < 2) {
//        counter++;
//        [Progress SetRetries:[Progress GetRetries]+1];
//        if (right) {
//            int result = (((float)100*(float)0.5 + ((float)grade/(float)10)*(float)0.5)*(100-(counter-1)*10))/100;
//            [Progress SetSumStatistic:([Progress GetSumStatistic]+result)];
//            [Progress SetSuccessAnswers:[Progress GetSuccessAnswers]+1];
//            if (result > 100) {
//                NSLog(@"");
//            }
//        }else{
//            if (found) {
//                int result = (((float)10*(float)0.5 + ((float)grade/(float)10)*(float)0.5)*(100-(counter-1)*10))/100;
//                [Progress SetSumStatistic:([Progress GetSumStatistic]+result)];
//                if (result > 100) {
//                    NSLog(@"");
//                }
//            }else{
//                int result = (((float)10*(float)0.5 + ((float)wrongGrade/(float)10)*(float)0.5)*(100-(counter-1)*10))/100;
//                [Progress SetSumStatistic:([Progress GetSumStatistic]+result)];
//                if (result > 100) {
//                    NSLog(@"");
//                }
//            }
//        }
//    }
//    [buttonNext setEnabled:YES];
//}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue54"]) {
        OperationScreenController *OSC = [segue destinationViewController];
        OSC.category = self.category;
        OSC.subject = self.subject;
    }
    if ([[segue identifier] isEqualToString:@"segue56"]) {
        SummaryScreenController *SSC = [segue destinationViewController];
        SSC.category = self.category;
        SSC.subject = self.subject;
    }
}


-(NSString*)getPhraseFromAsrResults:(NSString*)asrResults confLevels:(NSString*)confLevels{
    NSString* servletName = @"GetPhraseFromAsrResults";
    NSString* urlString = [NSString stringWithFormat:@"http://%@:%@/%@/%@",ip,port,serverName,servletName];
    urlString = [NSString stringWithFormat:@"%@/%@",baseUrl,servletName];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setHTTPBody:[[NSString stringWithFormat:@"orgName=%@&appKey=%@&controller=%@&password=%@&asrResults=%@&confLevels=%@",@"TimeToKnow", appKey,[NSString stringWithFormat:@"%@_controller",appKey],password,asrResults,confLevels] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(returnString);
    return returnString;
}

- (BOOL)checkException:(NSString*)messageAnswer{
    if (messageAnswer.length > 3 && [[messageAnswer substringToIndex:4] isEqualToString:@"err-"]) {
        NSString* message = @"";
        BOOL show = false;
        if ([messageAnswer isEqualToString:OnvegoAppKeyNotFoundException]) {
            message = @"Onvego application key not found";
            show = true;
        }else if ([messageAnswer isEqualToString:OnvegoLicenseExpiredException]){
            message = @"Onvego license expired";
            show = true;
        }else if ([messageAnswer isEqualToString:OnvegoGeneralException]){
            message = @"Onvego general error";
            show = true;
        }
        if (show) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Onvego"
                                                               message:message
                                                              delegate:nil cancelButtonTitle:@"Close"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
            return false;
        }
    }
    return true;
}


@end
