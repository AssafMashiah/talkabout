//
//  Categoryy.h
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categoryy : NSObject{
    NSString* image_url;
    NSString* subtitle;
    long idd;
    NSString* name;
    NSMutableArray* subjects;
}

-(id)init_with_name:(NSString* )name1 subtitle:(NSString* )subtitle1 image_url:(NSString* )image_url1 id:(long)id1 subjects:(NSMutableArray* )subjects1;

-(NSString*)getName;
-(NSString*)getImageName;
-(NSMutableArray*)getSubjects;
-(long)getIdd;

@end
