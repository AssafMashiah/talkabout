//
//  OperationScreenController.h
//  timetoknow
//
//  Created by Alon on 6/8/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categoryy.h"
#import "Subject.h"
#import "Static.h"
#import "CellSubjectView.h"
#import "CellImageView.h"
#import "CellWooHooView.h"
#import "QuestionsScreenController.h"
#import "CategoryScreenController.h"
#import "CellAlertView.h"
#import "VocabQuestionsScreenController.h"

@interface OperationScreenController : UIViewController

@property (assign, nonatomic) Categoryy* category;
@property (assign, nonatomic) Subject* subject;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *ImageParrot;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBack;
@property (weak, nonatomic) IBOutlet UIView *viewForDialog;
@property (weak, nonatomic) IBOutlet UIImageView *ImageSpeak;
@property (weak, nonatomic) IBOutlet UIImageView *ImageVocab;

@end
