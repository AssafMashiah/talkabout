//
//  CategotyScreenController.m
//  timetoknow
//
//  Created by Alon on 6/8/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "CategoryScreenController.h"

@implementation CategoryScreenController
@synthesize ImageViewBackground;
@synthesize ScrollView;
@synthesize category;
@synthesize ImageParrot;
@synthesize viewForDialog;
@synthesize ImageBack;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* imageName = [category getImageName];
    UIImage* image = [Static getImage:imageName];
    [ImageViewBackground setImage:image];
    subjects = [category getSubjects];
    
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
    UILabel* label = [[UILabel alloc]init];
    UIFont* font = [UIFont fontWithName:label.font.fontName size:15.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[category getName]] attributes:attrsDictionary];
    [answersString appendAttributedString:attrString1];
        CellAlertView* cell = [[CellAlertView alloc]initWithFrame:CGRectMake(0, viewForDialog.frame.size.height*0.25, viewForDialog.frame.size.width, viewForDialog.frame.size.height*0.6)];
    [cell setText:answersString];
    [viewForDialog addSubview:cell];
    if (subjects != nil) {
        int count = [subjects count];
        int height = self.ScrollView.frame.size.width/2.5;
        for (int i = 0; i<count; i++) {
            CellSubjectView* cell = [[CellSubjectView alloc]initWithFrame:CGRectMake(0, i*height, self.ScrollView.frame.size.width, height)];
            Subject* subject = [subjects objectAtIndex:i];
            NSString* imageName = [subject getImageName];
            UIImage* image = [Static getImage:imageName];
            [cell setImagee:image size:height];
            [cell setText:[subject getName]];
            [cell setSubject:subject];
            if (i == 0) {
                [cell removeBotLine];
            }
            if (i == (count-1)) {
                [cell removeTopLine];
            }
            UITapGestureRecognizer *tapGR;
            tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            tapGR.numberOfTapsRequired = 1;
            [cell addGestureRecognizer:tapGR];
            [self.ScrollView addSubview:cell];
        }
        self.ScrollView.contentSize = CGSizeMake(self.ScrollView.frame.size.width, (count+1)*height);
    }
}

-(void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CellSubjectView *cell = (CellSubjectView*)sender.view;
        Subject* Subject = [cell getSubject];
        selectedSubject = Subject;
        [self performSegueWithIdentifier:@"segue34" sender:sender];
    }
}

-(void)handleTappp:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue32" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue34"]) {
        OperationScreenController *OSC = [segue destinationViewController];
        OSC.category = self.category;
        OSC.subject = selectedSubject;
    }
}


@end
