//
//  Phrase.h
//  TalkAbout
//
//  Created by Alon on 9/14/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Phrase : NSObject

@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) int count;
@property (nonatomic, strong) NSMutableArray* asrResults;

@end
