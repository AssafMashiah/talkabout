//
//  CellQuestionView.h
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellQuestionView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *label;

-(void)setImagee:(UIImage*)newImage size:(int)size;
-(void)setText:(NSString*)text;

@end
