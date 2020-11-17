//
//  OperationScreenController.m
//  timetoknow
//
//  Created by Alon on 6/8/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "OperationScreenController.h"

@implementation OperationScreenController
@synthesize ImageViewBackground;
@synthesize category;
@synthesize subject;
@synthesize ImageParrot;
@synthesize viewForDialog;
@synthesize ImageBack;
@synthesize ImageSpeak;
@synthesize ImageVocab;

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
    
    UITapGestureRecognizer *tapGR3;
    tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGR3.numberOfTapsRequired = 1;
    tapGR3.cancelsTouchesInView = NO;
    UITapGestureRecognizer *tapGR4;
    tapGR4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSegue45_5:)];
    tapGR4.numberOfTapsRequired = 1;
    tapGR4.cancelsTouchesInView = NO;
    [ImageSpeak setUserInteractionEnabled:YES];
    [ImageVocab setUserInteractionEnabled:YES];
    [ImageSpeak addGestureRecognizer:tapGR3];
    [ImageVocab addGestureRecognizer:tapGR4];
    //[ImageSpell addGestureRecognizer:tapGR1];
}

- (void)viewDidAppear:(BOOL)animated{
    UILabel* label = [[UILabel alloc]init];
    UIFont* font = [UIFont fontWithName:label.font.fontName size:15.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@"Choose your challenge"] attributes:attrsDictionary];
    [answersString appendAttributedString:attrString1];
    
        CellAlertView* cell = [[CellAlertView alloc]initWithFrame:CGRectMake(0, viewForDialog.frame.size.height*0.25, viewForDialog.frame.size.width, viewForDialog.frame.size.height*0.6)];
    [cell setText:answersString];
    [viewForDialog addSubview:cell];
}

-(void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue45" sender:sender];
    }
}

-(void)handleTapSegue45_5:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue45_5" sender:sender];
    }
}

-(void)handleTappp:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"segue43" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue45"]) {
        QuestionsScreenController *QSC = [segue destinationViewController];
        QSC.category = self.category;
        QSC.subject = self.subject;
    }
    if ([[segue identifier] isEqualToString:@"segue45_5"]) {
        VocabQuestionsScreenController *VQCS = [segue destinationViewController];
        VQCS.category = self.category;
        VQCS.subject = self.subject;
    }
    if ([[segue identifier] isEqualToString:@"segue43"]) {
        CategoryScreenController *CSC = [segue destinationViewController];
        CSC.category = self.category;
    }

}


@end
