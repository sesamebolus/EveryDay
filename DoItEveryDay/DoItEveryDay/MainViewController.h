//
//  MainViewController.h
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "FlipsideViewController.h"
#import <QuartzCore/QuartzCore.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (nonatomic, retain) CAGradientLayer *gradient;

- (IBAction)showInfo:(id)sender;

- (void)drawGradientLayer;

@end
