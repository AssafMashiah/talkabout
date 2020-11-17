//
//  Progress.m
//  timetoknow
//
//  Created by Alon on 6/13/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "Progress.h"

@implementation Progress

static int successAnswers = 0;
static int retries = 0;
static int totalQuestions = 0;
static float sumStatistic = 0;

+(int)GetSuccessAnswers{
    return successAnswers;
}
+(void)SetSuccessAnswers:(int)newSuccessAnswers{
    successAnswers = newSuccessAnswers;
}

+(int)GetRetries{
    return retries;
}
+(void)SetRetries:(int)newRetries{
    retries = newRetries;
}

+(int)GetTotalQuestions{
    return totalQuestions;
}
+(void)SetTotalQuestions:(int)newTotalQuestions{
    totalQuestions = newTotalQuestions;
}

+(float)GetSumStatistic{
    return sumStatistic;
}

+(void)SetSumStatistic:(float)newSumStatistic{
    sumStatistic = newSumStatistic;
}

@end
