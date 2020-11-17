//
//  Question.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "Question.h"

@implementation Question

-(id)init_with_text:(NSString *)text1 image_url:(NSString *)image_url1 failure_text:(NSString *)failure_text1 id:(long)id1 success_text:(NSString *)success_text1 answers:(NSMutableArray *)answers1 solution_number:(int)solution_number1{
     self = [super init];
    text = text1;
    image_url = image_url1;
    failure_text = failure_text1;
    success_text = success_text1;
    answers = answers1;
    solution_number = solution_number1;
    idd = id1;
    return self;
}

-(NSString*)getText{
    return text;
}

-(NSString*)getImageName{
    return image_url;
}

-(NSMutableArray*)getAnswers{
    return answers;
}

-(int)getSolutionNumber{
    return solution_number;
}

-(NSString*)getSuccessText{
    return success_text;
}

-(NSString*)getFailureText{
    return failure_text;
}

-(long)getIdd{
    return idd;
}


@end
