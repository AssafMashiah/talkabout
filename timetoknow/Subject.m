//
//  Subject.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "Subject.h"

@implementation Subject

-(id)init_with_name:(NSString *)name1 subtitle:(NSString *)subtitle1 image_url:(NSString *)image_url1 id:(long)id1 questions:(NSMutableArray *)questions1 questions_vocab:(NSMutableArray* )questions_vocab1{
    self = [super init];
    name = name1;
    subtitle = subtitle1;
    image_url = image_url1;
    idd = id1;
    questions = questions1;
    questions_vocab = questions_vocab1;
    return self;
}

-(NSString*)getName{
    return name;
}

-(NSString*)getImageName{
    return image_url;
}

-(NSMutableArray*)getQuestions{
    return questions;
}

-(NSMutableArray*)getQuestionsVocab{
    return questions_vocab;
}

-(long)getIdd{
    return idd;
}

-(void)setVocabQuestions:(NSMutableArray*)vocabQuestons{
    questions_vocab = vocabQuestons;
}

@end
