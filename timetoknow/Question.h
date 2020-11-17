//
//  Question.h
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject{
    NSString* text;
    NSString* image_url;
    NSString* failure_text;
    NSMutableArray* answers;
    NSString* success_text;
    int solution_number;
    long idd;
}

-(id)init_with_text:(NSString* )text1 image_url:(NSString* )image_url1 failure_text:(NSString* )failure_text1 id:(long)id1 success_text:(NSString* )success_text1 answers:(NSMutableArray* )answers1 solution_number:(int)solution_number1;

-(NSString*)getText;
-(NSString*)getImageName;
-(NSMutableArray*)getAnswers;
-(int)getSolutionNumber;
-(NSString*)getSuccessText;
-(NSString*)getFailureText;
-(long)getIdd;

@end
