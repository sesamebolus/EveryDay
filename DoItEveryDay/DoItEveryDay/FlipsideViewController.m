//
//  FlipsideViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "FlipsideViewController.h"
#import "SqliteAccess.h"
#import "LogItem.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

//@synthesize dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.dbAccess = [[SqliteAccess alloc] init];
    [self.dbAccess openDatabase];
    self.dataArray = [self.dbAccess getRecordList];
    [self.dbAccess closeDatabse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)tableViewEdit:(id)sender
{
    [self.tableview setEditing:!self.tableview.editing animated:YES];
    if (self.tableview.editing) {
        [sender setImage:[UIImage imageNamed:@"done@2x.png"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"edit@2x.png"] forState:UIControlStateNormal];
    }

}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    LogItem *logItem = [self.dataArray objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年M月d日 (EEEE) HH:mm"];
    [cell.textLabel setText:
        [[NSString alloc] initWithFormat:@"%@", [dateFormat stringFromDate: logItem.date]]
    ];
    [cell.textLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
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
    [self.tableview deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - unload

- (void)viewDidUnload {
    [self setTableview:nil];
    [super viewDidUnload];
}
@end
