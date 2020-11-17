//
//  OnvegoScreenController.h
//  TalkAbout
//
//  Created by Alon on 8/28/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Static.h"
#import "Categoryy.h"
#import "Subject.h"
#import "Question.h"
#import "Answer.h"
#import "CellPickRowController.h"
#import <SpeechKit/SKTransaction.h>
#import "AVFoundation/AVAudioPlayer.h"
#import "AsrResult.h"
#import "Phrase.h"

@class CellAnswersView;
@class SKRecognizedPhrase;

@interface OnvegoScreenController : UIViewController <UIAlertViewDelegate>{
    NSMutableAttributedString *answersString;
    AVAudioPlayer *playStart;
    AVAudioPlayer *stopStart;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonListPhrases;
@property (weak, nonatomic) IBOutlet UIImageView *imageParrot;
- (IBAction)clickChoosepPhrase:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *viewPhrases;
@property (weak, nonatomic) IBOutlet UIButton *buttonChoosePhrase;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;
@property (weak, nonatomic) IBOutlet UIButton *buttonTalk;

// Settings
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *recognitionType;
@property (assign, nonatomic) SKTransactionEndOfSpeechDetection endpointer;
@end
