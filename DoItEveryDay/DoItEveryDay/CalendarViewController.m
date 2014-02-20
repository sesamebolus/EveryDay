//
//  CalendarViewController.m
//  DoItEveryDay
//
//  Created by 张智超 on 14-2-18.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate = self;
    [self.view addSubview:calendar];
    
    // database
    self.dbAccess = [[SqliteAccess alloc] init];
    [self.dbAccess openDatabase];
    self.dataArray = [self.dbAccess getRecordListForCalendar];
    [self.dbAccess closeDatabse];
}

#pragma mark - Calendar
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
//    if (month == 2) {
//        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:5], nil];
//        [calendarView markDates:dates];
//    }
    
    [calendarView markDates:self.dataArray];
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
