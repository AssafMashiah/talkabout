//
//  CellQuestionView.h
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellVocabQuestionView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

-(void)setImagee:(UIImage*)newImage size:(int)size;

@end
