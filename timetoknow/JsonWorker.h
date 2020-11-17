//
//  JsonWorker.h
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface JsonWorker : NSObject

+(void)DownloadAndParseJson;
+(void)DownloadAndParseJsonSchools;
@end
