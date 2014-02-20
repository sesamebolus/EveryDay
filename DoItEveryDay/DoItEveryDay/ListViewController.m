//
//  ListViewController.m
//  DoItEveryDay
//
//  Created by 张智超 on 14-2-18.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#import "ListViewController.h"
#import "LogItem.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // database
    self.dbAccess = [[SqliteAccess alloc] init];
    [self.dbAccess openDatabase];
    self.dataArray = [self.dbAccess getRecordList];
    
    // header view
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [headerView setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]];
    UILabel* totalLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    [totalLabel setTextAlignment:NSTextAlignmentCenter];
    [totalLabel setFont:[UIFont systemFontOfSize:15]];
    [totalLabel setTextColor:[UIColor darkGrayColor]];
    [totalLabel setText:[NSString stringWithFormat:@"共完成%u次", [self.dbAccess getTotalRecord]]];
    [headerView addSubview:totalLabel];
    [self.tableView setTableHeaderView:headerView];
    
    [self.dbAccess closeDatabse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
    }
    
    LogItem *logItem = [self.dataArray objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年M月d日 (EEEE) HH:mm"];
    [cell.textLabel setText:[[NSString alloc] initWithFormat:@"%@", [dateFormat stringFromDate: logItem.date]]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    LogItem *logItem = [self.dataArray objectAtIndex:indexPath.row];
    
    [self.dbAccess openDatabase];
    [self.dbAccess deleteRecordAtIndex:logItem.rowid];
    [self.dbAccess closeDatabse];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

@end
