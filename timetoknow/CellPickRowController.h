//
//  CellNextController.h
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellPickRowController : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

-(void)setText:(NSString*)text;
-(void)clickSwitch:(BOOL)boolean;

@end
