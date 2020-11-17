//
//  CellSubjectView.h
//  timetoknow
//
//  Created by Alon on 6/8/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"

@interface CellSubjectView : UIView{
    Subject* subject;
}

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *ViewTop;
@property (nonatomic, strong) IBOutlet UIView *ViewBot;

-(void)setImagee:(UIImage*)newImage size:(int)size;
-(void)setText:(NSString*)text;
-(void)setSubject:(Subject*)subjectt;
-(Subject*)getSubject;
-(void)removeTopLine;
-(void)removeBotLine;

@end