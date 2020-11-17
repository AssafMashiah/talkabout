//
//  Subject.h
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subject : NSObject{
    NSString* image_url;
    NSString* subtitle;
    long idd;
    NSString* name;
    NSMutableArray* questions;
    NSMutableArray* questions_vocab;
}

-(id)init_with_name:(NSString* )name1 subtitle:(NSString* )subtitle1 image_url:(NSString* )image_url1 id:(long)id1 questions:(NSMutableArray* )questions1 questions_vocab:(NSMutableArray* )questions_vocab1;

-(NSString*)getName;
-(NSString*)getImageName;
-(NSMutableArray*)getQuestions;
-(NSMutableArray*)getQuestionsVocab;
-(long)getIdd;

-(void)setVocabQuestions:(NSMutableArray*)vocabQuestons;

@end
