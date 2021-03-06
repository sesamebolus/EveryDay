//
//  MainViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "MainViewController.h"
#import "GlobalNavigationController.h"
#import "GloabalUI.h"
#import "HistoryViewController.h"
#import "GoalViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateStatus];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // click button
    [self.clickButton setBackgroundColor:[UIColor blackColor]];
    [self.clickButton.layer setCornerRadius:80.0f];

    // date label
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"M月d日\nEEEE"];
    [self.dateLabel setText:[dateFormat stringFromDate:date]];
    
    self.dbAccess = [[SqliteAccess alloc] init];
    [self.dbAccess openDatabase];
    [self.dbAccess createDatabase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update Status and Gradient Background

- (void)updateStatus
{
    // read from NSUserDefaults
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"myGoal"]) {
        NSLog(@"There is no goal.");
        [self.textLabel setText:@"请设定你的目标"];
        [self.clickButton setHidden:YES];
        [self performSelector:NSSelectorFromString(@"showGoal:") withObject:nil afterDelay:1];
    } else {
        NSLog(@"I do have a goal.");
        if ([self.dbAccess getLastRecord] != NULL) {
            NSDateComponents *lastDay = [[NSCalendar currentCalendar]
                                         components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                         fromDate:[self.dbAccess getLastRecord]];
            NSDateComponents *today = [[NSCalendar currentCalendar]
                                       components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                       fromDate:[NSDate date]];
            if([today day] == [lastDay day] && [today month] == [lastDay month] && [today year] == [lastDay year] && [today era] == [lastDay era]) {
                NSLog(@"You have finished it today!");
                [self.textLabel setText:@"很好，明天继续加油！"];
                [self endingAnimation];
            } else {
                NSLog(@"You havn't finished it today!");
                [self.textLabel setText:[NSString stringWithFormat:@"你今天%@了吗？", [[NSUserDefaults standardUserDefaults] stringForKey:@"myGoal"]]];
                [self resetCLickButton];
            }
        } else {
            NSLog(@"First day, not finished.");
            [self.textLabel setText:[NSString stringWithFormat:@"你今天%@了吗？", [[NSUserDefaults standardUserDefaults] stringForKey:@"myGoal"]]];
            [self resetCLickButton];
        }
    }
    
    [self updateProgressLabel];
}

- (void)resetCLickButton
{
    [self.clickButton setHidden:NO];
    [self.tickImage setHidden:YES];
    [self.clickButton setFrame:CGRectMake(
                                          (self.view.frame.size.width - self.clickButton.frame.size.width) / 2,
                                          self.view.frame.size.height - (self.clickButton.frame.size.height / 2),
                                          self.clickButton.frame.size.width,
                                          self.clickButton.frame.size.height)];
}

- (void)updateProgressLabel
{
    [self.progressLabel setText:[NSString stringWithFormat:@"%u%%", [self.dbAccess getProgress] * 100 / 7]];
}

- (void)drawGradientLayer
{
    NSArray *colorArray = [NSArray arrayWithObjects:
                           RGBCOLOR(51, 52, 80), // 0:00-1:00
                           RGBCOLOR(81, 83, 138), // 2:00-3:00
                           RGBCOLOR(146, 90, 146), // 4:00-5:00
                           RGBCOLOR(251, 104, 121), // 6:00-7:00
                           RGBCOLOR(131, 121, 167), // 8:00-9:00
                           RGBCOLOR(95, 203, 253), // 10:00-11:00
                           RGBCOLOR(42, 178, 234), // 12:00-13:00
                           RGBCOLOR(27, 134, 201), // 14:00-15:00
                           RGBCOLOR(22, 110, 183), // 16:00-17:00
                           RGBCOLOR(12, 77, 149), // 18:00-19:00
                           RGBCOLOR(10, 57, 112), // 20:00-21:00
                           RGBCOLOR(2, 32, 60), // 22:00-23:00
                           RGBCOLOR(0, 6, 13), // 24:00-00:00
                           nil];
    
    // get current time
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    int hour = [dateComponent hour];
    
    // darw a gradient color background
    UIColor *topColor = colorArray[hour/2];
    UIColor *bottomColor = hour/2 > 11 ? colorArray[0] : colorArray[hour/2 + 1];
    
    self.gradient = [CAGradientLayer layer];
    _gradient.frame = self.view.bounds;
    _gradient.colors = [NSArray arrayWithObjects:
                        (id)topColor.CGColor,
                        (id)bottomColor.CGColor,
                        nil];
    _gradient.locations = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.7],
                           nil];
    [self.backgroundView.layer addSublayer:self.gradient];
}

#pragma mark - Submit Button

- (IBAction)submitButton:(id)sender
{
    [self endingAnimation];
        
    // insert a record to database
    NSDate *today = [NSDate date];
    [self.dbAccess insertRecord:today];
    
    NSUInteger progress = [self.dbAccess getProgress] * 100 / 7;
    if (progress >= 100) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everSuccess"]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"恭喜你做到了！"
                                                            message:[NSString stringWithFormat:@"在过去的一周里，你每天都坚持%@，做得非常好！",
                                                                     [[NSUserDefaults standardUserDefaults] stringForKey:@"myGoal"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everSuccess"];
        }
    }
}

- (void)endingAnimation
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.clickButton setFrame:CGRectMake(
                                                               self.clickButton.frame.origin.x,
                                                               self.clickButton.frame.origin.y + self.clickButton.frame.size.height / 2,
                                                               self.clickButton.frame.size.width,
                                                               self.clickButton.frame.size.height
                                                               )];
                     }
                     completion:^(BOOL finished){
                         [self animationFinished];
                     }];
}

- (void)animationFinished
{
    [self.textLabel setText:@"很好，明天继续加油！"];
    [self updateProgressLabel];
    
    [self.tickImage setAlpha:0.0f];
    [self.tickImage setHidden:NO];
    
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.tickImage setAlpha:1.0f];
                     } 
                     completion:^(BOOL finished){
                     }];
}

#pragma mark - Flipside View and Goal View

- (IBAction)showInfo:(id)sender
{    
    HistoryViewController *controller = [[HistoryViewController alloc] init];
    GlobalNavigationController *navigation = [[GlobalNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (IBAction)showGoal:(id)sender
{
    GoalViewController *controller = [[GoalViewController alloc] initWithNibName:@"GoalViewController" bundle:nil];
    GlobalNavigationController *navigation = [[GlobalNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark - Unload
- (void)viewDidUnload {
    [self setTextLabel:nil];
    [self setTickImage:nil];
    [self setDateLabel:nil];
    [self setProgressLabel:nil];
    [super viewDidUnload];
    [self.dbAccess closeDatabse];
}
@end
