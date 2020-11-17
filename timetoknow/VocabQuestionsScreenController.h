//
//  VocabQuestionsScreenController.h
//  TalkAbout
//
//  Created by Alon on 6/27/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "Categoryy.h"
#import "Subject.h"
#import "Static.h"
#import "CellVocabQuestionView.h"
#import "CellNextController.h"
#import "Question.h"
#import <SpeechKit/SKTransaction.h>
#import "Progress.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "OperationScreenController.h"
#import "SummaryScreenController.h"
#import "CellVocabAnswersView.h"
#import "CellAlertView.h"

@class CellAnswersView;
@class SKRecognizedPhrase;

@interface VocabQuestionsScreenController : UIViewController {
    Question* curQuestion;
    CellAnswersView *cellAnswer;
    CellVocabAnswersView* cellAnswers;
    NSString* rightAnswer;
    int indexOfQuestion;
    int counter;
}

@property (assign, nonatomic) Categoryy* category;
@property (assign, nonatomic) Subject* subject;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageWhite;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;
@property (weak, nonatomic) IBOutlet UIView *viewForDialog;


@property (weak, nonatomic) IBOutlet UIImageView *ImageParrot;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBack;
- (IBAction)clickNext:(id)sender;


@end
