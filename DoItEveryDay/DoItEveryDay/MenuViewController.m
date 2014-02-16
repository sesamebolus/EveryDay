//
//  MenuViewController.m
//  DoItEveryDay
//
//  Created by 张智超 on 14-2-15.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#import "MenuViewController.h"
#import "GloabalUI.h"
#import "FlipsideViewController.h"
#import "GoalViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"更多"];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"backButton"] target:self action:@selector(backHandler)];
    
    self.tableData = [[NSArray alloc] initWithObjects:@"历史记录", @"日历", @"目标设置", nil];
}

- (void)backHandler
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [cell.textLabel setText:[self.tableData objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    
    switch (indexPath.row) {
        case 0:
            vc = [[FlipsideViewController alloc] init];
            break;
        case 1:
            break;
        case 2:
            vc = [[GoalViewController alloc] init];
            break;
        default:
            break;
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
