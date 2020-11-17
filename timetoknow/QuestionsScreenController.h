//
//  QuestionsScreenController.h
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categoryy.h"
#import "Subject.h"
#import "Static.h"
#import "CellQuestionView.h"
#import "CellNextController.h"
#import "Question.h"
#import <SpeechKit/SKTransaction.h>
#import "Progress.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "OperationScreenController.h"
#import "SummaryScreenController.h"
#import "CellAlertView.h"

@class CellAnswersView;
@class SKRecognizedPhrase;

@interface QuestionsScreenController : UIViewController {
    Question* curQuestion;
    CellAnswersView *cellAnswer;
    CellAnswersView* cellAnswers;
    NSString* rightAnswer;
    NSMutableArray* lastPhrase;
    int indexOfQuestion;
    int counter;
    NSMutableAttributedString *answersString;
    AVAudioPlayer *playStart;
     AVAudioPlayer *stopStart;
}

@property (assign, nonatomic) Categoryy* category;
@property (assign, nonatomic) Subject* subject;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageWhite;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *viewForDialog;

@property (weak, nonatomic) IBOutlet UIButton *toggleRecogButton;
@property (weak, nonatomic) IBOutlet UIImageView *ImageParrot;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBack;
- (IBAction)clickNext:(id)sender;

// Settings
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *recognitionType;
@property (assign, nonatomic) SKTransactionEndOfSpeechDetection endpointer;


@end
