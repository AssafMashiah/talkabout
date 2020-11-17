//
//  CellAnswersView.m
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "CellAnswersView.h"

@interface CellAnswersView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@end

@implementation CellAnswersView

@synthesize ViewToFill;

-(void)setAnswers:(NSMutableAttributedString*)answers heightView:(int)heightView widthView:(int)widthView answer:(BOOL)boolean{
    NSArray *viewsToRemove = [ViewToFill subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    if (answers == nil) {
        return;
    }
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, widthView ,heightView)];
    [label setTextColor:[UIColor whiteColor]];
    if (boolean) {
            label.textAlignment = NSTextAlignmentCenter;
    }
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.minimumFontSize = 1;
    label.attributedText = answers;
    //[label setFont:[UIFont systemFontOfSize:20]];
    //        UITapGestureRecognizer *tapGR;
    //        tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //        tapGR.numberOfTapsRequired = 1;
    //        tapGR.cancelsTouchesInView = NO;
    //        [label addGestureRecognizer:tapGR];
    [ViewToFill addSubview:label];
    
}

//-(void)handleTap:(UIGestureRecognizer *)sender
//{
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        UILabel *label = (UILabel*)sender.view;
//        int number = [label tag];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificaiton_name" object:[NSString stringWithFormat:@"%d",number]];
//    }
//}

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
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CellAnswers"
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
