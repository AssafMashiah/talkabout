//
//  CellProgressView.h
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellProgressView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewMedal;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UILabel *labelName;
@property (nonatomic, strong) IBOutlet UILabel *labelProgress;
@property (nonatomic, strong) IBOutlet UIProgressView *progress;

-(void)setImagee:(UIImage*)newImage size:(int)size;
-(void)setText:(NSString*)text;
-(void)setTextName:(NSString*)text;
-(void)setTextProgress:(int)place from:(int)from;
-(void)setMedal;
-(void)setProgresss:(float)ratio;

@end
