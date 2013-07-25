//
//  GoalViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-18.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "GoalViewController.h"

@interface GoalViewController ()

@end

@implementation GoalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // read plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ([[data objectForKey: @"myGoal"] length] != 0)
    {
        [self.goalTextField setText:[data objectForKey: @"myGoal"]];
    }
    
    if ([[data objectForKey:@"isClockOn"] boolValue]) {
        self.clockSwitch.on = YES;
        self.clockTimePicker.hidden = NO;
    } else {
        self.clockSwitch.on = NO;
        self.clockTimePicker.hidden = YES;
    }
    
    NSDate *selectedTime = [data objectForKey:@"clockTime"];
    [self.clockTimePicker setDate:selectedTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate *) tomorrowTime: (NSDate *) targetTime
{
    NSDateComponents* tomorrowComponents = [NSDateComponents new];
    tomorrowComponents.day = 1;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* tomorrow = [calendar dateByAddingComponents:tomorrowComponents toDate:targetTime options:0];
    
    NSDateComponents* tomorrowAtHourComponents = [calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:tomorrow];
    return [calendar dateFromComponents:tomorrowAtHourComponents];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate GoalViewControllerDidFinish:self];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.goalTextField resignFirstResponder];
}

- (IBAction)clockSwitchChanged:(id)sender {
    self.clockTimePicker.hidden = !self.clockSwitch.isOn;
}

- (IBAction)saveGoal:(id)sender {
    // read plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    // localNotification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if ([[self.goalTextField text] length] != 0 && self.clockSwitch.isOn) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil) return;
        NSDate *fireTime = [self tomorrowTime:[self.clockTimePicker date]];
        localNotif.fireDate = fireTime;
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.alertBody = [NSString stringWithFormat:@"你今天%@了吗？", [self.goalTextField text]];
        localNotif.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    
    // write plist
    [data setObject:[self.goalTextField text] forKey:@"myGoal"];
    [data setObject:[NSNumber numberWithBool:self.clockSwitch.isOn] forKey:@"isClockOn"];
    [data setObject:[self.clockTimePicker date] forKey:@"clockTime"];
    [data writeToFile:plistPath atomically:YES];
    
    // exit
    [self.goalTextField resignFirstResponder];
    [self done:nil];
}

#pragma mark - Unload

- (void)viewDidUnload {
    [self setGoalTextField:nil];
    [self setClockTimePicker:nil];
    [self setClockSwitch:nil];
    [super viewDidUnload];
}
@end
