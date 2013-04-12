//
//  FlipsideViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "FlipsideViewController.h"
#import "FMDatabase.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

//@synthesize dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // open SQLite database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    
    if (![database open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    // setup date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // read database
    self.dataArray = [[NSMutableArray alloc] init];
    FMResultSet *results = [database executeQuery:@"select * from log order by date desc limit 7"];
    while([results next]) {
        NSDate *targetDate = [results dateForColumn:@"date"];
        [self.dataArray addObject:targetDate];
    }
    [results close];
    
    // close database
    [database close];
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
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [cell.textLabel setText:
        [[NSString alloc] initWithFormat:@"%@", [dateFormat stringFromDate: [self.dataArray objectAtIndex:indexPath.row]]]
    ];
    [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
    return cell;
}

@end
