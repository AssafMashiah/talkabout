//
//  SchoolScreenController.h
//  TalkAbout
//
//  Created by Alon on 6/26/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellAlertView.h"
#import "Static.h"
#import "School.h"

#define schoolMode 1
#define teacherMode 2
#define dialectMode 3

@interface SchoolScreenController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableArray* pickerData;
    UIPickerView* picker;
    UIView* viewForPicker;
    NSString* selectedString;
    int currMode;
    NSMutableArray* schoolsList;
    NSMutableArray* teachersList;
    NSMutableArray* dialects;
    NSString* selectedSchool;
    NSString* selectedDialect;
    NSString* selectedTeacher;
}

@property (weak, nonatomic) IBOutlet UIButton *ButtonApply;
@property (weak, nonatomic) IBOutlet UIView *viewForDialog;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UILabel *labelSchool;
@property (weak, nonatomic) IBOutlet UILabel *labelTeacher;
@property (weak, nonatomic) IBOutlet UILabel *labelDialect;


- (IBAction)buttonClickApply:(id)sender;
- (IBAction)buttonClickSkip:(id)sender;

- (IBAction)buttonClickSchool:(id)sender;
- (IBAction)buttonClickTeacher:(id)sender;
- (IBAction)buttonClickDialect:(id)sender;


@end
