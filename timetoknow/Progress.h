//
//  Progress.h
//  timetoknow
//
//  Created by Alon on 6/13/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Progress : NSObject

+(int)GetSuccessAnswers;
+(void)SetSuccessAnswers:(int)newSuccessAnswers;
+(int)GetRetries;
+(void)SetRetries:(int)newRetries;
+(int)GetTotalQuestions;
+(void)SetTotalQuestions:(int)newTotalQuestions;
+(float)GetSumStatistic;
+(void)SetSumStatistic:(float)newSumStatistic;

@end
