//
//  NameScreenController.h
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellAlertView.h"

@interface NameScreenController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *EditTextEmail;
@property (weak, nonatomic) IBOutlet UITextField *EditTextPassword;
@property (weak, nonatomic) IBOutlet UIButton *ButtonForgot;
@property (weak, nonatomic) IBOutlet UIButton *ButtonNew;
@property (weak, nonatomic) IBOutlet UIButton *ButtonApply;
@property (weak, nonatomic) IBOutlet UIView *viewForDialog;

- (IBAction)ButtonApply:(id)sender;

@end
