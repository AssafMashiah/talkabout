//
//  CellCategoryView.h
//  timetoknow
//
//  Created by Alon on 6/8/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categoryy.h"

@interface CellCategoryView : UIView{
    Categoryy* category;
}

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIProgressView *progress;

-(void)setProgresss:(float)ratio;
-(void)setImagee:(UIImage*)newImage size:(int)size;
-(void)setText:(NSString*)text;
-(void)setCategory:(Categoryy*)categoryy;
-(Categoryy*)getCategory;

@end