//
//  School.m
//  TalkAbout
//
//  Created by Alon on 6/26/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import "School.h"

@implementation School

-(id)init_with_name:(NSString *)newName teachers:(NSMutableArray *)newTeachers{
    self = [super init];
    name = newName;
    teachers = newTeachers;
    return self;
}

-(NSString*)getName{
    return name;
}

-(NSMutableArray*)getTeachers{
    return teachers;
}

@end
