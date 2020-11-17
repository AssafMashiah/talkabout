//
//  School.h
//  TalkAbout
//
//  Created by Alon on 6/26/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface School : NSObject{
    NSString* name;
    NSMutableArray* teachers;
}

-(id)init_with_name:(NSString *)newName teachers:(NSMutableArray *)newTeachers;
-(NSString*)getName;
-(NSMutableArray*)getTeachers;

@end
