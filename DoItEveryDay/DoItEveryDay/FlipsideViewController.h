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

@interface FlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) SqliteAccess *dbAccess;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end