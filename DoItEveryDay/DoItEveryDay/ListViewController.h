//
//  ListViewController.h
//  DoItEveryDay
//
//  Created by 张智超 on 14-2-18.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteAccess.h"

@interface ListViewController : UITableViewController

@property (nonatomic, retain) SqliteAccess *dbAccess;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end
