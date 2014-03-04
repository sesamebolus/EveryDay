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
    
    self.calendar = [[VRGCalendarView alloc] init];
    self.calendar.delegate = self;
    [self.view addSubview:self.calendar];
    
    // database
    self.dbAccess = [[SqliteAccess alloc] init];
    
    // gesture recognizer
    UISwipeGestureRecognizer *recognizer;
	
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	[recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
	[self.calendar addGestureRecognizer:recognizer];
	recognizer = nil;
	
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	[recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
	[self.calendar addGestureRecognizer:recognizer];
	recognizer = nil;
}

#pragma mark - Calendar
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    
    [self.dbAccess openDatabase];
    self.dataArray = [self.dbAccess getRecordListForMonth:[dateFormat stringFromDate: calendarView.currentMonth]];
    [calendarView markDates:self.dataArray];
    [self.dbAccess closeDatabse];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
	if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [self.calendar showPreviousMonth];
        return;
	}
    
	if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [self.calendar showNextMonth];
        return;
	}
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
