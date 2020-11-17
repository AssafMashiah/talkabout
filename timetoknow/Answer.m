//
//  Answer.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "Answer.h"

@implementation Answer

-(id)init_with_text:(NSString *)text1 number:(int)number1{
    self = [super init];
    text = text1;
    number = number1;
    return self;
}
-(NSString*)getText{
    return text;
}

-(int)getNumber{
    return number;
}

@end
