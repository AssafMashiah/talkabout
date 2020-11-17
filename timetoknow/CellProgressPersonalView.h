//
//  CellProgressPersonalView.h
//  TalkAbout
//
//  Created by Alon on 6/19/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellProgressPersonalView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewMedal;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UILabel *labelName;
@property (nonatomic, strong) IBOutlet UILabel *labelProgress;
@property (nonatomic, strong) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) IBOutlet UILabel *labelAnswer;
@property (nonatomic, strong) IBOutlet UILabel *labelRetries;
@property (nonatomic, strong) IBOutlet UILabel *labelQuestions;

-(void)setImagee:(UIImage*)newImage size:(int)size;
-(void)setText:(NSString*)text;
-(void)setTextName:(NSString*)text;
-(void)setTextProgress:(NSString*)progress;
-(void)setMedal;
-(void)setProgresss:(float)ratio;
-(void)setTextAnswer:(NSString*)text;
-(void)setTextRetries:(NSString*)text;
-(void)setTextQuestions:(NSString*)text;

@end
