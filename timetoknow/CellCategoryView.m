//
//  SCCustomView.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "CellCategoryView.h"

@interface CellCategoryView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@end

@implementation CellCategoryView
@synthesize label;
@synthesize imageView;
@synthesize progress;

-(void)setProgresss:(float)ratio{
    [progress setProgress:ratio];
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

-(void)setText:(NSString*)text{
    [label setText:text];
    [label sizeToFit];
}

-(void)setCategory:(Categoryy*)categoryy{
    category = categoryy;
}

-(Categoryy*)getCategory{
    return category;
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
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CellCat"
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