//
//  HistoryViewController.h
//  DoItEveryDay
//
//  Created by 张智超 on 14-2-18.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#import "ListViewController.h"

@interface HistoryViewController : UIViewController

@property(nonatomic, strong) CalendarViewController *calendarViewController;
@property(nonatomic, strong) ListViewController *listViewController;
@property(nonatomic, strong) UIBarButtonItem *editButton;

@end
