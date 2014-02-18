//
//  HistoryViewController.m
//  DoItEveryDay
//
//  Created by 张智超 on 14-2-18.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#import "HistoryViewController.h"
#import "GloabalUI.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"历史记录"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"backButton"] target:self action:@selector(backHandler)];
    
    self.editButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"edit"] target:self action:@selector(editHandler:)];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    [self.view addSubview:contentView];
    
    self.calendarViewController = [[CalendarViewController alloc] init];
    [self.calendarViewController.view setFrame:contentView.bounds];
    [contentView addSubview:self.calendarViewController.view];
    [self.calendarViewController.view setHidden:NO];
    
    self.listViewController = [[ListViewController alloc] init];
    [self.listViewController.view setFrame:contentView.bounds];
    [contentView addSubview:self.listViewController.tableView];
    [self.listViewController.tableView setHidden:YES];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"日历",@"列表", nil]];
    [segmentControl addTarget:self action:@selector(didChangeSegmentControl:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:0];
    [self.navigationItem setTitleView:segmentControl];
}

-(IBAction)didChangeSegmentControl:(id)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self.calendarViewController.view setHidden:NO];
            [self.listViewController.tableView setHidden:YES];
            [self.navigationItem setRightBarButtonItem:nil];
            break;
        default:
            [self.calendarViewController.view setHidden:YES];
            [self.listViewController.tableView setHidden:NO];
            [self.navigationItem setRightBarButtonItem:self.editButton];
            break;
    }
}

#pragma mark - Actions

- (void)backHandler
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editHandler:(id)sender
{
    [self.listViewController.tableView setEditing:!self.listViewController.tableView.editing animated:YES];
    if (self.listViewController.tableView.editing) {
        [sender setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
