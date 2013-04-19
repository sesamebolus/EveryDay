//
//  FlipsideViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "FlipsideViewController.h"
#import "SqliteAccess.h"

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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    [cell.textLabel setText:
        [[NSString alloc] initWithFormat:@"%@", [dateFormat stringFromDate: [self.dataArray objectAtIndex:indexPath.row]]]
    ];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    return cell;
}

@end
