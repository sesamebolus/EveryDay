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
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = documentPaths[0];
    NSString *filePathInDocsDir = [docsDir stringByAppendingPathComponent:@"config.plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:filePathInDocsDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePathInDocsDir]) {
        self.clockSwitch.on = YES;
        self.clockTimePicker.hidden = NO;
    } else {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = documentPaths[0];
    NSString *filePathInDocsDir = [docsDir stringByAppendingPathComponent:@"config.plist"];
    NSLog(@"file path: %@", filePathInDocsDir);
    
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
    
    // write to plist
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [self.goalTextField text], @"myGoal",
                                  [NSNumber numberWithBool:self.clockSwitch.isOn], @"isClockOn",
                                  [self.clockTimePicker date], @"clockTime",
                                  nil
                                  ];
    [data writeToFile:filePathInDocsDir atomically:YES];
    
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
