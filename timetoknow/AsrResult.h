//
//  AsrResult.h
//  TalkAbout
//
//  Created by Alon on 9/14/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsrResult : NSObject

@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) int count;

@end
