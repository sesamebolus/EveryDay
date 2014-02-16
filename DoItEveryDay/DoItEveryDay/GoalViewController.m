//
//  GoalViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-18.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "GoalViewController.h"
#import "GloabalUI.h"

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
    
    // nav bar
    self.title = @"设定目标";
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"myGoal"]) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"backButton"] target:self action:@selector(backHandler)];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithTitle:@"确定" target:self action:@selector(saveGoal)];
    
    // read from NSUserDefaults
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"myGoal"]) {
        self.clockSwitch.on = YES;
        self.clockTimePicker.hidden = NO;
    } else {
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"myGoal"] length] != 0){
            [self.goalTextField setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"myGoal"]];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isClockOn"]) {
            self.clockSwitch.on = YES;
            self.clockTimePicker.hidden = NO;
        } else {
            self.clockSwitch.on = NO;
            self.clockTimePicker.hidden = YES;
        }
        
        NSDate *selectedTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"clockTime"];
        [self.clockTimePicker setDate:selectedTime];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)backHandler
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.goalTextField resignFirstResponder];
}

- (IBAction)clockSwitchChanged:(id)sender {
    self.clockTimePicker.hidden = !self.clockSwitch.isOn;
}

- (void)saveGoal {
    // localNotification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if ([[self.goalTextField text] length] != 0 && self.clockSwitch.isOn) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil) return;
        NSDate *fireTime = [self.clockTimePicker date];
        localNotif.fireDate = fireTime;
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.alertBody = [NSString stringWithFormat:@"你今天%@了吗？", [self.goalTextField text]];
        localNotif.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    
    // write to NSUserDefaults
    NSString *goalString = [[self.goalTextField text] isEqualToString:@"例如：运动、泡脚"] ? @"运动" : [self.goalTextField text];
    [[NSUserDefaults standardUserDefaults] setObject:goalString forKey:@"myGoal"];
    [[NSUserDefaults standardUserDefaults] setBool:self.clockSwitch.isOn forKey:@"isClockOn"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.clockTimePicker date] forKey:@"clockTime"];
    
    // exit
    [self.goalTextField resignFirstResponder];
    [self backHandler];
}

#pragma mark - Unload

- (void)viewDidUnload {
    [self setGoalTextField:nil];
    [self setClockTimePicker:nil];
    [self setClockSwitch:nil];
    [super viewDidUnload];
}
@end
