//
//  SplashScreenController.m
//  TalkAbout
//
//  Created by Alon on 6/16/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import "SplashScreenController.h"

@interface SplashScreenController ()

@end

@implementation SplashScreenController
@synthesize LabelTop;
@synthesize labelPowered;
@synthesize labelVersion;
@synthesize labelTalkAbout;

static double finishTime = 0;
static double startTime = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    LabelTop.layer.borderWidth = 1.0f;
    LabelTop.layer.borderColor = [UIColor whiteColor].CGColor;
    LabelTop.adjustsFontSizeToFitWidth = YES;
    LabelTop.minimumFontSize = 0;
    [LabelTop setText:@"Loading"];
    [LabelTop setTextColor:[UIColor whiteColor]];
    [labelPowered setText:@"Powered by TimeToKnow"];
    labelPowered.adjustsFontSizeToFitWidth = YES;
    [labelVersion setText:[NSString stringWithFormat:@"%@%@",@"Version ",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [labelTalkAbout setText:@"TALKABOUT"];
    labelTalkAbout.adjustsFontSizeToFitWidth = YES;
    
    [LabelTop setText:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"go_next" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:) name:@"update_text" object:nil];
    startTime = [[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1] doubleValue];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [JsonWorker DownloadAndParseJsonSchools];
        [JsonWorker DownloadAndParseJson];
            finishTime = [[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1] doubleValue];
        double dif = finishTime  - startTime ;
        double timeToWait = 2.0 - dif;
        if (timeToWait > 0) {
            NSLog([NSString stringWithFormat:@"%f",timeToWait]);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (timeToWait+2) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"segue0_0_5" sender:self];
        });
    });
}

- (void) updateText:(NSNotification *)notification{
     NSString *theString = [notification object];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [LabelTop setText:[NSString stringWithFormat:@"%@%@",@"Progress:\r",theString]];
        //LabelTop.text = [NSString stringWithFormat:@"%@",@"Progress:\r",theString];
    }];
}

@end
