//
//  SchoolScreenController.m
//  TalkAbout
//
//  Created by Alon on 6/26/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import "SchoolScreenController.h"

@interface SchoolScreenController ()

@end

@implementation SchoolScreenController
@synthesize ButtonApply;
@synthesize viewForDialog;
@synthesize viewMain;
@synthesize labelDialect;
@synthesize labelSchool;
@synthesize labelTeacher;

- (void)viewDidLoad {
    [super viewDidLoad];
    ButtonApply.layer.borderWidth = 1.0f;
    ButtonApply.layer.borderColor = [UIColor whiteColor].CGColor;
    dialects = [[NSMutableArray alloc]init];
    [dialects addObject:@"eng-USA"];
    [dialects addObject:@"eng-AUS"];
    [dialects addObject:@"eng-GBR"];
    [dialects addObject:@"eng-IND"];
    //[dialects addObject:@"eng-IRL"];
    //[dialects addObject:@"eng-SCT"];
    //[dialects addObject:@"eng-ZAF"];
    selectedDialect = [Static GetDialect];
    selectedTeacher = [Static GetTeacher];
    selectedSchool = [Static GetSchool];
    
    schoolsList = [[NSMutableArray alloc]init];
    for (School* school in [Static getSchools]) {
        [schoolsList addObject:[school getName]];
    }
    for (School* school in [Static getSchools]) {
        if ([selectedSchool isEqualToString:[school getName]]) {
            teachersList = [school getTeachers];
        }
    }
    [self updateButtons];
    
    pickerData = [[NSMutableArray alloc] init];
    [pickerData addObject:@""];
    viewForPicker = [[UIView alloc]initWithFrame:CGRectMake(0, viewMain.frame.size.height - (viewMain.frame.size.height*0.3), viewMain.frame.size.width, (viewMain.frame.size.height*0.3))];
    UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewMain.frame.size.width, (viewMain.frame.size.height*0.3))];
    [image setImage:[UIImage imageNamed:@"pickerBackground.png"]];
    [viewForPicker addSubview:image];
    picker = [[UIPickerView alloc]init];
    [viewForPicker addSubview:picker];
    viewForPicker.backgroundColor = [UIColor clearColor];
    picker.dataSource = self;
    picker.delegate = self;
    [viewMain addSubview:viewForPicker];
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handleSingleTap:)];
//    viewMain.userInteractionEnabled = YES;
//    [viewMain addGestureRecognizer:singleFingerTap];
    viewForPicker.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
    UILabel* label = [[UILabel alloc]init];
    UIFont* font = [UIFont fontWithName:label.font.fontName size:15.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @"Add your school"] attributes:attrsDictionary];
    [answersString appendAttributedString:attrString1];
    CellAlertView* cell = [[CellAlertView alloc]initWithFrame:CGRectMake(0, viewForDialog.frame.size.height*0.25, viewForDialog.frame.size.width, viewForDialog.frame.size.height*0.6)];
    [cell setText:answersString];
    [viewForDialog addSubview:cell];
}

//- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
//    viewForPicker.hidden = YES;
//    if (currMode == schoolMode) {
//        selectedSchool = selectedString;
//        for (School* school in [Static getSchools]) {
//            if ([selectedSchool isEqualToString:[school getName]]) {
//                teachersList = [school getTeachers];
//                if ([teachersList objectAtIndex:0] != nil) {
//                    selectedTeacher = [teachersList objectAtIndex:0];
//                }
//            }
//        }
//    }else if(currMode == teacherMode){
//        selectedTeacher = selectedString;
//    }else if(currMode == dialectMode){
//        selectedDialect = selectedString;
//    }
//    
//    [self updateButtons];
//}

- (IBAction)buttonClickApply:(id)sender {
    [Static SetTeacher:selectedTeacher];
    [Static SetDialect:selectedDialect];
    [Static SetSchool:selectedSchool];
    [self performSegueWithIdentifier:@"segue12" sender:self];
}

- (IBAction)buttonClickSkip:(id)sender {
    [self performSegueWithIdentifier:@"segue12" sender:self];
}

- (IBAction)buttonClickSchool:(id)sender {
    selectedString = selectedSchool;
    currMode = schoolMode;
    pickerData = schoolsList;
    [picker reloadAllComponents];
    viewForPicker.hidden = NO;
}

- (IBAction)buttonClickTeacher:(id)sender {
    selectedString = selectedTeacher;
    currMode = teacherMode;
    pickerData = teachersList;
    [picker reloadAllComponents];
    viewForPicker.hidden = NO;
}

- (IBAction)buttonClickDialect:(id)sender {
    selectedString = selectedDialect;
    currMode = dialectMode;
    pickerData = dialects;
    [picker reloadAllComponents];
     viewForPicker.hidden = NO;
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedString = pickerData[row];
    viewForPicker.hidden = YES;
    if (currMode == schoolMode) {
        selectedSchool = selectedString;
        for (School* school in [Static getSchools]) {
            if ([selectedSchool isEqualToString:[school getName]]) {
                teachersList = [school getTeachers];
                if ([teachersList objectAtIndex:0] != nil) {
                    selectedTeacher = [teachersList objectAtIndex:0];
                }
            }
        }
    }else if(currMode == teacherMode){
        selectedTeacher = selectedString;
    }else if(currMode == dialectMode){
        selectedDialect = selectedString;
    }
    
    [self updateButtons];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *pickerViewLabel = (id)view;
    
    if (!pickerViewLabel) {
        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
    }
    
    pickerViewLabel.backgroundColor = [UIColor clearColor];
     pickerViewLabel.textAlignment = NSTextAlignmentCenter;
    pickerViewLabel.text = pickerData[row];
    return pickerViewLabel;
}

- (void)updateButtons{
    if ([selectedDialect isEqualToString:@""]) {
        [labelDialect setText:@"dialect"];
    }else{
        [labelDialect setText:selectedDialect];
    }
    if ([selectedSchool isEqualToString:@""]) {
        [labelSchool setText:@"school"];
    }else{
        [labelSchool setText:selectedSchool];
    }
    if ([selectedTeacher isEqualToString:@""]) {
        [labelTeacher setText:@"teacher"];
    }else{
        [labelTeacher setText:selectedTeacher];
    }
}

@end
