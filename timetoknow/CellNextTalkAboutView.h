//
//  CellNextTalkAboutView.h
//  timetoknow
//
//  Created by Alon on 6/13/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellNextTalkAboutView : UIView

@property (nonatomic, strong) IBOutlet UILabel *label;

-(void)setText:(NSString*)text;

@end
