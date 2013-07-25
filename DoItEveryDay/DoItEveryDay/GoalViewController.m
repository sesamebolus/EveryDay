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
@synthesize goalTextField;

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
    
    self.dbAccess = [[SqliteAccess alloc] init];
    [self.dbAccess openDatabase];
    
    if ([self.dbAccess getGoal] != NULL) {
        [goalTextField setText:[self.dbAccess getGoal]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Local Notification

- (void) localNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if ([self.dbAccess getGoal]) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil) return;
        NSDate *fireTime = [self tomorrowAtHour:7 withMinute:5]; // AM 7:05
        localNotif.fireDate = fireTime;
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.alertBody = [NSString stringWithFormat:@"你今天%@了吗？", [self.dbAccess getGoal]];
        localNotif.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
}

- (NSDate *) tomorrowAtHour: (NSInteger) targetHour withMinute:(NSInteger) targetMinute
{
    NSDate* now = [NSDate date];
    
    NSDateComponents* tomorrowComponents = [NSDateComponents new];
    tomorrowComponents.day = 1;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* tomorrow = [calendar dateByAddingComponents:tomorrowComponents toDate:now options:0];
    
    NSDateComponents* tomorrowAtHourComponents = [calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:tomorrow];
    tomorrowAtHourComponents.hour = targetHour;
    tomorrowAtHourComponents.minute = targetMinute;
    return [calendar dateFromComponents:tomorrowAtHourComponents];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate GoalViewControllerDidFinish:self];
}

- (IBAction)dismissKeyboard:(id)sender {
    [goalTextField resignFirstResponder];
}

- (IBAction)saveGoal:(id)sender {
    [self.dbAccess setGoal:[goalTextField text]];
    [self localNotification];
    [goalTextField resignFirstResponder];
    [self done:nil];
}

#pragma mark - Unload

- (void)viewDidUnload {
    [self setGoalTextField:nil];
    [super viewDidUnload];
    [self.dbAccess closeDatabse];
}
@end
