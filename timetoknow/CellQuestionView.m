//
//  CellQuestionView.m
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "CellQuestionView.h"

@interface CellQuestionView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@end

@implementation CellQuestionView
@synthesize imageView;
@synthesize label;

-(void)setText:(NSString*)text{
    [label setText:text];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 0;
    //[label setTextColor:[UIColor colorWithRed:(double)43/(double)255 green:(double)127/(double)255 blue:(double)116/(double)255 alpha:1]];
    [label setTextColor:[UIColor whiteColor]];
}

-(void)setImagee:(UIImage*)newImage size:(int)size{
    float realSize = (float)size * 0.75;
    imageView.layer.cornerRadius = realSize / 2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1.0f;
    if (newImage != nil) {
        [imageView setImage:newImage];
    }
    imageView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
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
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CellQuestion"
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
