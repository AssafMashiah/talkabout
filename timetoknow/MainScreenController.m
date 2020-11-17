//
//  MainScreenController.m
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import "MainScreenController.h"
#import "Static.h"
#import "CellCategoryView.h"
#import "CategoryScreenController.h"


#define random(min,max) ((arc4random() % (max-min+1)) + min)
@interface MainScreenController ()

@end

@implementation MainScreenController
@synthesize ImageBack;
@synthesize viewForDialog;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCategories];
    ImageBack.contentMode = UIViewContentModeScaleAspectFill;
    ImageBack.clipsToBounds = YES;
    [ImageBack setImage:[UIImage imageNamed:@"bgpicture.png"]];
    [Progress SetRetries:0];
    [Progress SetSuccessAnswers:0];
    [Progress SetTotalQuestions:0];
    [Progress SetSumStatistic:0];
}

- (void)viewDidAppear:(BOOL)animated{
    UILabel* label = [[UILabel alloc]init];
    UIFont* font = [UIFont fontWithName:label.font.fontName size:15.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSMutableAttributedString* answersString = [[NSMutableAttributedString alloc]init];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"Hi ", [Static GetMyName], @", what do you want to TALKABOUT today?"] attributes:attrsDictionary];
    [answersString appendAttributedString:attrString1];
        CellAlertView* cell = [[CellAlertView alloc]initWithFrame:CGRectMake(0, viewForDialog.frame.size.height*0.25, viewForDialog.frame.size.width, viewForDialog.frame.size.height*0.6)];
    [cell setText:answersString];
    [viewForDialog addSubview:cell];
    if (categories != nil) {
        int count = [categories count];
        int height = self.ScrollView.frame.size.width/2.5;
        for (int i = 0; i<count; i++) {
            //
            CellCategoryView* cell = [[CellCategoryView alloc]initWithFrame:CGRectMake(0, i*(height + 10), self.ScrollView.frame.size.width, height)];
            Categoryy* category = [categories objectAtIndex:i];
            NSString* imageName = [category getImageName];
            UIImage* image = [Static getImage:imageName];
            [cell setImagee:image size:height];
            [cell setText:[category getName]];
            [cell setProgresss:(float)random(40, 90)/(float)100];
            [cell setCategory:category];
            UITapGestureRecognizer *tapGR;
            tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            tapGR.numberOfTapsRequired = 1;
            [cell addGestureRecognizer:tapGR];
            [self.ScrollView addSubview:cell];
        }
        self.ScrollView.contentSize = CGSizeMake(self.ScrollView.frame.size.width, (count+1)*(height+10));
    }
}

- (void)loadCategories{
    categories = [Static getCategories];
}

-(void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CellCategoryView *cell = (CellCategoryView*)sender.view;
        Categoryy* category = [cell getCategory];
        selectedCategory = category;
        [self performSegueWithIdentifier:@"segue23" sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue23"]) {
        CategoryScreenController *CSC = [segue destinationViewController];
        CSC.category = selectedCategory;
    }
}


@end
