//
//  SplashScreenController.h
//  TalkAbout
//
//  Created by Alon on 6/16/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Static.h"
#import "JsonWorker.h"

@interface SplashScreenController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *LabelTop;
@property (weak, nonatomic) IBOutlet UILabel *labelPowered;
@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (weak, nonatomic) IBOutlet UILabel *labelTalkAbout;

@end
