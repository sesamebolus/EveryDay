//
//  MainViewController.h
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SqliteAccess.h"

@interface MainViewController : UIViewController

@property (nonatomic, retain) CAGradientLayer *gradient;
@property (nonatomic, retain) SqliteAccess *dbAccess;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@property (weak, nonatomic) IBOutlet UIImageView *tickImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

- (IBAction)showInfo:(id)sender;
- (IBAction)submitButton:(id)sender;

- (void)drawGradientLayer;
- (void)updateStatus;

@end
