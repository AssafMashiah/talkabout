//
//  CellProgressView.m
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "CellProgressView.h"

@interface CellProgressView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@end

@implementation CellProgressView
@synthesize imageView;
@synthesize label;
@synthesize labelName;
@synthesize labelProgress;
@synthesize imageViewMedal;
@synthesize progress;

-(void)setText:(NSString*)text{
    [label setText:text];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 1;
    [label setTextColor:[UIColor whiteColor]];
}

-(void)setTextName:(NSString*)text{
    [labelName setText:text];
    labelName.numberOfLines = 2;
    labelName.adjustsFontSizeToFitWidth = YES;
    labelName.minimumFontSize = 1;
    [labelName setTextColor:[UIColor whiteColor]];
}

-(void)setTextProgress:(int)place from:(int)from{
//    [labelProgress setTextColor:[UIColor whiteColor]];
//    NSString *initial = [NSString stringWithFormat:@"%d/%d",place,from];
//    NSString *text = [NSString stringWithFormat:@"%d",place];
//    
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:initial];
//    NSRange range=[initial rangeOfString:text]; //myLabel is the outlet from where you will get the text, it can be same or different
//    
//    UIColor *color = [UIColor orangeColor];
//    
//    
//    [string addAttribute:NSForegroundColorAttributeName
//                   value:color
//                   range:range];
//    
//    [labelProgress setAttributedText:string];
    [labelProgress setTextColor:[UIColor whiteColor]];
    [labelProgress setText:[NSString stringWithFormat:@"%d/%d",place,from]];
    
    labelProgress.adjustsFontSizeToFitWidth = YES;
    labelProgress.minimumFontSize = 1;
}

-(void)setImagee:(UIImage*)newImage size:(int)size{
    float realSize = ((float)size - ((float)size * 0.18 + 3 + (float)size * 0.04))-30;
    imageView.layer.cornerRadius = realSize / 2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1.0f;
    if (newImage != nil) {
        [imageView setImage:newImage];
    }
    imageView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
}

-(void)setMedal{
    imageViewMedal.layer.masksToBounds = YES;
    [imageViewMedal setImage:[UIImage imageNamed:@"medal.png"]];
}

-(void)setProgresss:(float)ratio{
    [progress setProgress:ratio];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _customConstraints = [[NSMutableArray alloc] init];
    
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CellProgress"
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    
    if (view != nil) {
        _containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
    }
}

- (void)updateConstraints
{
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self.containerView != nil) {
        UIView *view = self.containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}
@end
