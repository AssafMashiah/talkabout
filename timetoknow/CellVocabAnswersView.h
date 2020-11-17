//
//  CellVocabAnswersView.h
//  TalkAbout
//
//  Created by Alon on 6/27/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"
#import "Progress.h"

@interface CellVocabAnswersView : UIView{
    NSMutableArray* curAnswers;
    int correctId;
    int counter;
    BOOL right;
}

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

-(void)setAnswers:(NSMutableArray*)answers heightView:(int)heightView widthView:(int)widthView correctId:(int)newCorrectId;

@end
