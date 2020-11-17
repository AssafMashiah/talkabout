//
//  SummaryScreenController.m
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "SummaryScreenController.h"

@interface SummaryScreenController ()

@end

@implementation SummaryScreenController
@synthesize ImageViewBackground;
@synthesize ScrollView;
@synthesize headerView;
@synthesize viewScrollHolder;
@synthesize ImageParrot;
@synthesize ImageBack;
@synthesize viewForDialog;

- (void)viewDidLoad {
    [super viewDidLoad];
    ImageViewBackground.contentMode = UIViewContentModeScaleAspectFill;
    ImageViewBackground.clipsToBounds = YES;
    [ImageViewBackground setImage:[UIImage imageNamed:@"bgpicture.png"]];
    
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
}

- (void)viewDidAppear:(BOOL)animated{
    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
    UILabel* label = [[UILabel alloc]init];
    UIFont* font = [UIFont fontWithName:label.font.fontName size:13.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    UIFont* font1 = [UIFont fontWithName:label.font.fontName size:15.0];
    NSDictionary *attrsDictionary1 = [NSDictionary dictionaryWithObject:font1
                                                                 forKey:NSFontAttributeName];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"Nice job!\r"] attributes:attrsDictionary1];
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"Look how far you have come"] attributes:attrsDictionary];
    
    [answersString appendAttributedString:attrString1];
    [answersString appendAttributedString:attrString2];
    
        CellAlertView* cell = [[CellAlertView alloc]initWithFrame:CGRectMake(0, viewForDialog.frame.size.height*0.25, viewForDialog.frame.size.width, viewForDialog.frame.size.height*0.6)];
    [cell setText:answersString];
    [viewForDialog addSubview:cell];
        int height = self.viewScrollHolder.frame.size.height/3.36;
    int heightPersonal = height*1.8;

    CellProgressPersonalView* cell1 = [[CellProgressPersonalView alloc]initWithFrame:CGRectMake(0, 0, self.ScrollView.frame.size.width, heightPersonal)];
    [cell1 setText:@"Your personal progress:"];
    [cell1 setTextName:[Static GetMyName]];
    [cell1 setImagee:[UIImage imageNamed:@"man.png"] size:height];
    float ratioProgress = [Progress GetSumStatistic]/[Progress GetRetries];
    [cell1 setTextProgress:[NSString stringWithFormat:@"%d%@",(int)ratioProgress,@"%"]];
    [cell1 setProgresss:(float)ratioProgress/(float)100];
    [cell1 setTextAnswer:[NSString stringWithFormat:@"%@%d",@"Number of success answers: ",[Progress GetSuccessAnswers]]];
    [cell1 setTextQuestions:[NSString stringWithFormat:@"%@%d",@"Number of total questions: ",[Progress GetTotalQuestions]]];
    [cell1 setTextRetries:[NSString stringWithFormat:@"%@%d",@"Number of retries: ",[Progress GetRetries]]];
    [self.ScrollView addSubview:cell1];
    
//    int heightLabel = self.ScrollView.frame.size.width/2.5;
//    UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:labelTop.font.pointSize];
//    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
//    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
//                                                                forKey:NSFontAttributeName];
//    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d",@"Number of success answers: ",[Progress GetSuccessAnswers]]];
//    NSAttributedString* str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d",@"\r\rNumber of retries: ",[Progress GetRetries]]];
//    NSAttributedString* str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d",@"\r\rNumber of total questions: ",[Progress GetTotalQuestions]]];
//    [answersString appendAttributedString:str1];
//    [answersString appendAttributedString:str2];
//    [answersString appendAttributedString:str3];
//    CellAnswersView* cellAnswers = [[CellAnswersView alloc]initWithFrame:CGRectMake(0, height, self.ScrollView.frame.size.width, heightLabel)];
//    [cellAnswers setAnswers:answersString heightView:heightLabel widthView:self.ScrollView.frame.size.width/1.2 answer:NO];
//    [self.ScrollView addSubview:cellAnswers];
//        int heightLabel = self.ScrollView.frame.size.width/8;
//        CellLabelView* cellLabel = [[CellLabelView alloc]initWithFrame:CGRectMake(0, height, self.ScrollView.frame.size.width, heightLabel)];
//        [cellLabel setText:[NSString stringWithFormat:@"%@%d",@"Number of success answers: ",[Progress GetSuccessAnswers]]];
//        [self.ScrollView addSubview:cellLabel];
//    
//        CellLabelView* cell2 = [[CellLabelView alloc]initWithFrame:CGRectMake(0, height+heightLabel, self.ScrollView.frame.size.width, heightLabel)];
//        [cell2 setText:[NSString stringWithFormat:@"%@%d",@"Number of retries: ",[Progress GetRetries]]];
//        [cell2 setFontSize:[cellLabel getFontSize]];
//        [self.ScrollView addSubview:cell2];
//    
//        cell2 = [[CellLabelView alloc]initWithFrame:CGRectMake(0, height+2*heightLabel, self.ScrollView.frame.size.width, heightLabel)];
//        [cell2 setText:[NSString stringWithFormat:@"%@%d",@"Number of total questions: ",[Progress GetTotalQuestions]]];
//        [cell2 setFontSize:[cellLabel getFontSize]];
//        [self.ScrollView addSubview:cell2];

    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, height+heightPersonal, ScrollView.frame.size.width, height)];
    CellProgressView* cell2 = [[CellProgressView alloc]initWithFrame:CGRectMake(0, heightPersonal, self.ScrollView.frame.size.width, height)];
    [cell2 setText:@"Your class`s position:"];
    if ([[Static GetMyClassName] isEqualToString:@", "]) {
        [cell2 setTextName:@""];
    }else{
        [cell2 setTextName:[Static GetMyClassName]];
    }
    [cell2 setTextProgress:115 from:457];
    [cell2 setProgresss:(float)1 - (float)115/(float)457];
    [cell2 setImagee:[UIImage imageNamed:@"classStudents.png"] size:height];
    [cell2 setMedal];
    [self.ScrollView addSubview:cell2];
    
    int heightNext = headerView.frame.size.height;
    CellNextTalkAboutView* cell3 = [[CellNextTalkAboutView alloc]initWithFrame:CGRectMake(0, self.viewScrollHolder.frame.size.height - heightNext, self.ScrollView.frame.size.width, heightNext)];
    [cell3 setText:@"What do you want to TALKABOUT next?"];
    UITapGestureRecognizer *tapGR;
    tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapNext:)];
    tapGR.numberOfTapsRequired = 1;
    tapGR.cancelsTouchesInView = NO;
    [cell3 setUserInteractionEnabled:YES];
    [cell3 addGestureRecognizer:tapGR];
    [self.ScrollView addSubview:cell3];
    
//    self.ScrollView.contentSize = CGSizeMake(self.ScrollView.frame.size.width, (height + heightNext +heightPersonal +5)*1.2);
}

-(void)handleTapNext:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue62" sender:sender];
    }
}

-(void)handleTappp:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue64" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue64"]) {
        OperationScreenController *OSC = [segue destinationViewController];
        OSC.category = self.category;
        OSC.subject = self.subject;
    }
}

@end
