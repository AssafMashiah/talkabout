//
//  CellVocabAnswersView.m
//  TalkAbout
//
//  Created by Alon on 6/27/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import "CellVocabAnswersView.h"

@interface CellVocabAnswersView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@end

@implementation CellVocabAnswersView
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;

-(void)setAnswers:(NSMutableArray*)answers heightView:(int)heightView widthView:(int)widthView correctId:(int)newCorrectId{
    if (answers == nil) {
        return;
    }
    correctId = newCorrectId;
    curAnswers = answers;
    NSMutableArray* answersStrings = [[NSMutableArray alloc]init];
    NSMutableArray* fontSizes = [[NSMutableArray alloc]init];
    for (int i = 0; i < [answers count]; i++) {
        Answer* answer = [answers objectAtIndex:i];
        [answersStrings addObject:[answer getText]];
    }
    int i = 0;
    UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    for (NSString* string in answersStrings) {
        NSMutableAttributedString* atrString = [[NSMutableAttributedString alloc]init];
        UILabel* label;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",(i+1)] attributes:attrsDictionary];
        [atrString appendAttributedString:attrString];
        if (i == 0) {
            label = label1;
            NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@". ",string]];
            [atrString appendAttributedString:str];
        }
        else if (i == 1) {
            label = label2;
            NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@". ",string]];
            [atrString appendAttributedString:str];
        }
        else if (i == 2) {
            label = label3;
            NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@". ",string]];
            [atrString appendAttributedString:str];
        }
        else if (i == 3) {
            label = label4;
            NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",@". ",string]];
            [atrString appendAttributedString:str];
        }
        [label setTextColor:[UIColor whiteColor]];
        //label.adjustsFontSizeToFitWidth = NO;
        [label sizeToFit];
        label.numberOfLines = 0;
       // label.minimumFontSize = 1;
        label.attributedText = atrString;
        UITapGestureRecognizer *tapGR1;
        tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTappp:)];
        tapGR1.numberOfTapsRequired = 1;
        tapGR1.cancelsTouchesInView = NO;
        [label setUserInteractionEnabled:YES];
        [label addGestureRecognizer:tapGR1];
        i++;
    }
}

//-(void)handleTap:(UIGestureRecognizer *)sender
//{
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        UILabel *label = (UILabel*)sender.view;
//        int number = [label tag];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificaiton_name" object:[NSString stringWithFormat:@"%d",number]];
//    }
//}

-(void)handleTappp:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [label1 setTextColor:[UIColor whiteColor]];
        [label2 setTextColor:[UIColor whiteColor]];
        [label3 setTextColor:[UIColor whiteColor]];
        [label4 setTextColor:[UIColor whiteColor]];
        UILabel *label = (UILabel*)sender.view;
        if (label == label1) {
            Answer* answer = [curAnswers objectAtIndex:0];
            if (correctId == [answer getNumber]) {
                [label1 setTextColor:[UIColor greenColor]];
                right = YES;
            }else{
                [label1 setTextColor:[UIColor redColor]];
                right = NO;
            }
        }
        else if (label == label2) {
            Answer* answer = [curAnswers objectAtIndex:1];
            if (correctId == [answer getNumber]) {
                [label2 setTextColor:[UIColor greenColor]];
                right = YES;
            }else{
                [label2 setTextColor:[UIColor redColor]];
                right = NO;
            }
        }
        else if (label == label3) {
            Answer* answer = [curAnswers objectAtIndex:2];
            if (correctId == [answer getNumber]) {
                [label3 setTextColor:[UIColor greenColor]];
                right = YES;
            }else{
                [label3 setTextColor:[UIColor redColor]];
                right = NO;
            }
        }
        else if (label == label4) {
            Answer* answer = [curAnswers objectAtIndex:3];
            if (correctId == [answer getNumber]) {
                [label4 setTextColor:[UIColor greenColor]];
                right = YES;
            }else{
                [label4 setTextColor:[UIColor redColor]];
                right = NO;
            }
        }
    }
    
    if (counter < 2) {
        counter++;
        [Progress SetRetries:[Progress GetRetries]+1];
        if (right) {
            int result = ((float)100*(100-(counter-1)*10))/100;
            [Progress SetSumStatistic:([Progress GetSumStatistic]+result)];
            [Progress SetSuccessAnswers:[Progress GetSuccessAnswers]+1];
            //[[NSNotificationCenter defaultCenter] postNotificationName: @"update_text_vocab" object: @"yes"];
        }else{
            int result = ((float)10*(100-(counter-1)*10))/100;
            [Progress SetSumStatistic:([Progress GetSumStatistic]+result)];
            //[[NSNotificationCenter defaultCenter] postNotificationName: @"update_text_vocab" object: @"no"];
        }
    }
    
    if (right) {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"update_text_vocab" object: @"yes"];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName: @"update_text_vocab" object: @"no"];
    }
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
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CellVocabAnswers"
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