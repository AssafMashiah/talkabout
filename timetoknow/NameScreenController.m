//
//  NameScreenController.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "NameScreenController.h"
#import "Static.h"

@interface NameScreenController ()

@end

@implementation NameScreenController
@synthesize EditTextEmail;
@synthesize EditTextPassword;
@synthesize ButtonForgot;
@synthesize ButtonNew;
@synthesize ButtonApply;
@synthesize viewForDialog;

- (void)viewDidLoad {
    [super viewDidLoad];
        [EditTextEmail setText:[Static GetMyName]];
    ButtonApply.layer.borderWidth = 1.0f;
    ButtonApply.layer.borderColor = [UIColor whiteColor].CGColor;
    UIColor *color = [UIColor colorWithRed:173 green:173 blue:173 alpha:0.5];
    EditTextEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: color}];
    EditTextPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: color}];
        [Static SetMyClassName:[NSString stringWithFormat:@"%@, %@",[Static GetSchool],[Static GetTeacher]]];
    }

-(void)viewDidAppear:(BOOL)animated{
    UILabel* label = [[UILabel alloc]init];
    UIFont* font = [UIFont fontWithName:label.font.fontName size:15.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @"Sign in"] attributes:attrsDictionary];
    [answersString appendAttributedString:attrString1];
        CellAlertView* cell = [[CellAlertView alloc]initWithFrame:CGRectMake(0, viewForDialog.frame.size.height*0.25, viewForDialog.frame.size.width, viewForDialog.frame.size.height*0.6)];
    [cell setText:answersString];
    [viewForDialog addSubview:cell];

}


- (IBAction)ButtonApply:(id)sender {
    NSString* newName = [EditTextEmail text];
    NSString* password = [EditTextPassword text];
//    [self performSegueWithIdentifier:@"segue0_5_onvego" sender:self];
    if ([[newName lowercaseString] isEqualToString:@"onvego"] && [[password lowercaseString] isEqualToString:@"onvego123"]) {
         [self performSegueWithIdentifier:@"segue0_5_onvego" sender:self];
    }else{
        [Static SetMyName:newName];
        [self performSegueWithIdentifier:@"segue0_5_1" sender:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
