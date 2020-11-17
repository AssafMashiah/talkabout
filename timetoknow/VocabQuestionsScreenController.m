//
//  VocabQuestionsScreenController.m
//  TalkAbout
//
//  Created by Alon on 6/27/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import "VocabQuestionsScreenController.h"

@implementation VocabQuestionsScreenController
@synthesize ImageViewBackground;
@synthesize ScrollView;
@synthesize category;
@synthesize subject;
@synthesize ImageParrot;
@synthesize ImageBack;
@synthesize imageWhite;
@synthesize buttonNext;
@synthesize viewForDialog;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* imageName = [category getImageName];
    UIImage* image = [Static getImage:imageName];
    [ImageViewBackground setImage:image];
    
    UITapGestureRecognizer *tapGR1;
    tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTappp:)];
    tapGR1.numberOfTapsRequired = 1;
    tapGR1.cancelsTouchesInView = NO;
    UITapGestureRecognizer *tapGR2;
    tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTappp:)];
    tapGR2.numberOfTapsRequired = 1;
    tapGR2.cancelsTouchesInView = NO;
    [ImageParrot setUserInteractionEnabled:YES];
    [ImageBack setUserInteractionEnabled:YES];
    [ImageParrot addGestureRecognizer:tapGR1];
    [ImageBack addGestureRecognizer:tapGR2];
    
    indexOfQuestion = 0;
    counter = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:) name:@"update_text_vocab" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) updateText:(NSNotification *)notification{
    NSString *theString = [notification object];
    if([theString isEqualToString:@"yes"]) {
        UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[curQuestion getSuccessText]] attributes:attrsDictionary];
        NSMutableAttributedString *answersStringg = [[NSMutableAttributedString alloc]init];
        [answersStringg appendAttributedString:attrString];
        [cellAnswer setAnswers:answersStringg heightView:((float)cellAnswer.frame.size.height/(float)1.5) widthView:cellAnswer.frame.size.width/1.2 answer:YES];
    }
    else if([theString isEqualToString:@"no"]) {
        UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[curQuestion getFailureText]] attributes:attrsDictionary];
        NSMutableAttributedString *answersStringg = [[NSMutableAttributedString alloc]init];
        [answersStringg appendAttributedString:attrString];
        [cellAnswer setAnswers:answersStringg heightView:((float)cellAnswer.frame.size.height/(float)1.5) widthView:cellAnswer.frame.size.width/1.2 answer:YES];
    }
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [LabelTop setText:[NSString stringWithFormat:@"%@%@",@"Progress:\r",theString]];
//    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [self fillUI];
    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
    UILabel* label = [[UILabel alloc]init];
    UIFont* font = [UIFont fontWithName:label.font.fontName size:13.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    UIFont* font1 = [UIFont fontWithName:label.font.fontName size:15.0];
    NSDictionary *attrsDictionary1 = [NSDictionary dictionaryWithObject:font1
                                                                 forKey:NSFontAttributeName];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"Select\r"] attributes:attrsDictionary1];
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"The correct answer"] attributes:attrsDictionary];
    
    [answersString appendAttributedString:attrString1];
    [answersString appendAttributedString:attrString2];
    
        CellAlertView* cell = [[CellAlertView alloc]initWithFrame:CGRectMake(0, viewForDialog.frame.size.height*0.25, viewForDialog.frame.size.width, viewForDialog.frame.size.height*0.6)];
    [cell setText:answersString];
    [viewForDialog addSubview:cell];

}

-(void)handleTappp:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue5_54" sender:self];
    }
}


- (IBAction)clickNext:(id)sender {
    indexOfQuestion++;
    if (indexOfQuestion < [[subject getQuestionsVocab] count]) {
        [self fillUI];
    }else{
        [self performSegueWithIdentifier:@"segue5_56" sender:self];
    }
}

-(void)fillUI{
    
    NSMutableArray *myArray = [subject getQuestionsVocab];
    if (myArray != nil && [myArray count] > 0) {
        curQuestion = [myArray objectAtIndex:indexOfQuestion];
        NSMutableArray* answers = [curQuestion getAnswers];
        
        counter = 0;
        [Progress SetTotalQuestions:[Progress GetTotalQuestions]+1];
        NSArray *viewsToRemove = [ScrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        int count = [myArray count];
        int height = self.ScrollView.frame.size.width/2.5;
        if (count != 0) {
            CellVocabQuestionView* cell1 = [[CellVocabQuestionView alloc]initWithFrame:CGRectMake(0, 0, self.ScrollView.frame.size.width, height)];
            NSString* imageName = [curQuestion getImageName];
            UIImage* image = [Static getImage:imageName];
            [cell1 setImagee:image size:height];
            [self.ScrollView addSubview:cell1];
            
            int ansHeight = 0;
            NSMutableArray* answers = [curQuestion getAnswers];
            if (answers != nil) {
                ansHeight = height/2.4*[answers count];
                cellAnswers = [[CellVocabAnswersView alloc]initWithFrame:CGRectMake(0, height, self.ScrollView.frame.size.width, ansHeight)];
                //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerPressed:) name:@"notificaiton_name" object:nil];
                [cellAnswers setAnswers:answers heightView:ansHeight widthView:self.ScrollView.frame.size.width/1.2 correctId:[curQuestion getSolutionNumber]];
                [self.ScrollView addSubview:cellAnswers];
                
                
                if (!(indexOfQuestion == 0)) {
                    CGPoint startPoint = (CGPoint){-(self.ScrollView.frame.size.width/2), height+ansHeight/2};
                    CGPoint middlePoint = (CGPoint){self.ScrollView.frame.size.width/2, height+ansHeight/2};
                    
                    CGMutablePathRef thePath = CGPathCreateMutable();
                    CGPathMoveToPoint(thePath, NULL, startPoint.x, startPoint.y);
                    CGPathAddLineToPoint(thePath, NULL, middlePoint.x, middlePoint.y);
                    
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                    animation.duration = 0.7f;
                    animation.path = thePath;
                    [cellAnswers.layer addAnimation:animation forKey:@"position"];
                    cellAnswers.layer.position = middlePoint;
                }
                
                cellAnswer = [[CellAnswersView alloc]initWithFrame:CGRectMake(0, height + ansHeight, self.ScrollView.frame.size.width, height/1.5)];
                
                [self.ScrollView addSubview:cellAnswer];
            }
        }
        for (Answer* answer in [curQuestion getAnswers]) {
            if ([answer getNumber] == [curQuestion getSolutionNumber]) {
                rightAnswer = [answer getText];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue5_54"]) {
        OperationScreenController *OSC = [segue destinationViewController];
        OSC.category = self.category;
        OSC.subject = self.subject;
    }
    if ([[segue identifier] isEqualToString:@"segue5_56"]) {
        SummaryScreenController *SSC = [segue destinationViewController];
        SSC.category = self.category;
        SSC.subject = self.subject;
    }
}

@end
