//
//  MainScreenController.h
//  timetoknow
//
//  Created by Alon on 6/6/16.
//  Copyright © 2016 3diz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categoryy.h"
#import "CellAlertView.h"

@interface MainScreenController : UIViewController{
    NSMutableArray* categories;
    Categoryy* selectedCategory;
}

@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageBack;
@property (weak, nonatomic) IBOutlet UIView *viewForDialog;


@end
