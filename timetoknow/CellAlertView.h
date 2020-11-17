//
//  CellAlertView.h
//  TalkAbout
//
//  Created by Alon on 6/26/16.
//  Copyright © 2016 t2k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellAlertView : UIView

@property (nonatomic, strong) IBOutlet UILabel *label;

-(void)setText:(NSMutableAttributedString*)text;

@end
