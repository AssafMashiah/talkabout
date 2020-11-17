//
//  CategotyScreenController.h
//  timetoknow
//
//  Created by Alon on 6/8/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categoryy.h"
#import "Static.h"
#import "Subject.h"
#import "CellSubjectView.h"
#import "OperationScreenController.h"
#import "CellAlertView.h"

@interface CategoryScreenController : UIViewController{
    NSMutableArray* subjects;
    Subject* selectedSubject;
}

@property (assign, nonatomic) Categoryy* category;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *ImageParrot;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBack;
@property (weak, nonatomic) IBOutlet UIView *viewForDialog;

@end
