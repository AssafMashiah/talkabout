//
//  SummaryScreenController.h
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Static.h"
#import "CellProgressView.h"
#import "CellNextTalkAboutView.h"
#import "CellLabelView.h"
#import "Progress.h"
#import "CellAnswersView.h"
#import "CellProgressPersonalView.h"
#import "OperationScreenController.h"
#import "CellAlertView.h"

@interface SummaryScreenController : UIViewController

@property (assign, nonatomic) Categoryy* category;
@property (assign, nonatomic) Subject* subject;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewBackground;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *viewScrollHolder;
@property (weak, nonatomic) IBOutlet UIImageView *ImageParrot;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBack;
@property (weak, nonatomic) IBOutlet UIView *viewForDialog;

@end
