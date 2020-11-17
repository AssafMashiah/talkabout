//
//  Static.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "Static.h"

@implementation Static

static NSString* myName;
static NSString* myClassName;
static NSMutableArray* categoriess;
static NSMutableArray* schools;
static NSString* mySchool;
static NSString* myTeacher;
static NSString* myDialect;

static BOOL sharedPref = FALSE;

+(NSString*)GetMyName {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (!([preferences objectForKey:@"myName"] == nil))
    {
        myName = [preferences objectForKey:@"myName"];
    }else{
        myName = @"";
    }
    return myName;
}
+(void)SetMyName:(NSString* )newName {
    [[NSUserDefaults standardUserDefaults] setObject:newName forKey:@"myName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    myName = newName;
}

+(void)downloadImage:(NSString* )url{
    NSString *string = [self getSubStringURL:url];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"update_text" object: string];
    
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:string];
    
    NSData* imageData;
    if (sharedPref) {
        imageData = [[NSUserDefaults standardUserDefaults] objectForKey:url];
    }else{
        imageData = [NSData dataWithContentsOfFile:fileAtPath];
    }

    if (imageData == nil)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

        [request setURL:[NSURL URLWithString:url]];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

        UIImage* image = [UIImage imageWithData:returnData];
        
        if (image != nil) {
            if (sharedPref) {
                [[NSUserDefaults standardUserDefaults] setObject:returnData forKey:url];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString* fileAtPath = [filePath stringByAppendingPathComponent:string];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
                    [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
                }
                [returnData writeToFile:fileAtPath atomically:NO];
            }
        }
    }
}

+(UIImage*)getImage:(NSString* )url{
    UIImage* image;
    if (sharedPref) {
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:url];
        image = [UIImage imageWithData:imageData];
    }else{
        NSString *string = [self getSubStringURL:url];
        NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* fileAtPath = [filePath stringByAppendingPathComponent:string];
        NSData* imageData = [NSData dataWithContentsOfFile:fileAtPath];
        image = [UIImage imageWithData:imageData];
    }
    return image;
}

+(void)setCategories:(NSMutableArray*)categories{
    categoriess = categories;
}

+(NSMutableArray*)getCategories{
    return categoriess;
}

+(void)SetMyClassName:(NSString *)newName{
    [[NSUserDefaults standardUserDefaults] setObject:newName forKey:@"myClassName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    myClassName = newName;
}

+(NSString*)GetMyClassName{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (!([preferences objectForKey:@"myClassName"] == nil))
    {
        myClassName = [preferences objectForKey:@"myClassName"];
    }else{
        myClassName = @"";
    }
    return myClassName;
}

+(NSString*)GetSchool{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (!([preferences objectForKey:@"mySchool"] == nil))
    {
        mySchool = [preferences objectForKey:@"mySchool"];
    }else{
        mySchool = @"";
    }
    return mySchool;
}

+(void)SetSchool:(NSString* )newSchool{
    [[NSUserDefaults standardUserDefaults] setObject:newSchool forKey:@"mySchool"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    mySchool = newSchool;
}

+(NSString*)GetTeacher{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (!([preferences objectForKey:@"myTeacher"] == nil))
    {
        myTeacher = [preferences objectForKey:@"myTeacher"];
    }else{
        myTeacher = @"";
    }
    return myTeacher;
}

+(void)SetTeacher:(NSString* )newTeacher{
    [[NSUserDefaults standardUserDefaults] setObject:newTeacher forKey:@"myTeacher"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    myTeacher = newTeacher;
}

+(NSString*)GetDialect{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if (!([preferences objectForKey:@"myDialect"] == nil))
    {
        myDialect = [preferences objectForKey:@"myDialect"];
    }else{
        myDialect = @"";
    }
    return myDialect;
}

+(void)SetDialect:(NSString* )newDialect{
    [[NSUserDefaults standardUserDefaults] setObject:newDialect forKey:@"myDialect"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    myDialect = newDialect;
}

+(void)setSchools:(NSMutableArray*)newSchools{
    schools = newSchools;
}

+(NSMutableArray*)getSchools{
    return schools;
}

+(NSString*)getSubStringURL:(NSString*)url{
    int index = -1;
    for (int i = 0; i < [url length]; i++) {
        NSString *string = [url substringWithRange:NSMakeRange([url length]-1-i, 1)];
        if ([@"/" isEqualToString:string]) {
            index = i;
            break;
        }
    }
    NSString *string = [url substringWithRange:NSMakeRange([url length]-index, index)];
    return string;
}

@end
