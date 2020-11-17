//
//  CellImageView.h
//  timetoknow
//
//  Created by Alon on 6/8/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellImageView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

-(void)setImagee:(UIImage*)newImage;

@end
