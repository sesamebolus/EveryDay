//
//  GoalViewController.h
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-18.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteAccess.h"

@class GoalViewController;

@protocol GoalViewControllerDelegate
- (void)GoalViewControllerDidFinish:(GoalViewController *)controller;
@end

@interface GoalViewController : UIViewController

@property (weak, nonatomic) id <GoalViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *goalTextField;
@property (nonatomic, retain) SqliteAccess *dbAccess;

- (IBAction)saveGoal:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
