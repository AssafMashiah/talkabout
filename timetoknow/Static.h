//
//  Static.h
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Categoryy.h"
#import "School.h"
#import <UIKit/UIKit.h>

@interface Static : NSObject

+(void)setCategories:(NSMutableArray*)categories;
+(NSMutableArray*)getCategories;
+(NSString*)GetMyName;
+(void)SetMyName:(NSString* )newName;
+(UIImage*)getImage:(NSString* )url;
+(void)downloadImage:(NSString* )url;
+(NSString*)GetMyClassName;
+(void)SetMyClassName:(NSString* )newName;
+(NSString*)GetSchool;
+(void)SetSchool:(NSString* )newSchool;
+(NSString*)GetTeacher;
+(void)SetTeacher:(NSString* )newTeacher;
+(NSString*)GetDialect;
+(void)SetDialect:(NSString* )newDialect;
+(void)setSchools:(NSMutableArray*)newSchools;
+(NSMutableArray*)getSchools;

@end
