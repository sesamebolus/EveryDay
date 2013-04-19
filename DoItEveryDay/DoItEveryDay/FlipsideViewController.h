//
//  FlipsideViewController.h
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteAccess.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) SqliteAccess *dbAccess;
@property (nonatomic, retain) NSMutableArray *dataArray;

- (IBAction)done:(id)sender;

@end
