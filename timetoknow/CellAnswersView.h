//
//  CellAnswersView.h
//  timetoknow
//
//  Created by Alon on 6/9/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"
#import "QuestionsScreenController.h"

@interface CellAnswersView : UIView

@property (nonatomic, strong) IBOutlet UIView *ViewToFill;

-(void)setAnswers:(NSMutableArray*)answers heightView:(int)heightView widthView:(int)widthView answer:(BOOL)boolean;

@end
