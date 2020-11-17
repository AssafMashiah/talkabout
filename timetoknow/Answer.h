//
//  Answer.h
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject{
    NSString* text;
    int number;
}

-(id)init_with_text:(NSString* )text1 number:(int)number1;

-(NSString*)getText;
-(int)getNumber;
@end
