//
//  Categoryy.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "Categoryy.h"

@implementation Categoryy

-(id)init_with_name:(NSString *)name1 subtitle:(NSString *)subtitle1 image_url:(NSString *)image_url1 id:(long)id1 subjects:(NSMutableArray *)subjects1{
    self = [super init];
    name = name1;
    subtitle = subtitle1;
    image_url = image_url1;
    idd = id1;
    subjects = subjects1;
    return self;
}

-(NSString*)getName{
    return name;
}

-(NSString*)getImageName{
    return image_url;
}

-(NSMutableArray*)getSubjects{
    return subjects;
}

-(long)getIdd{
    return idd;
}

@end
