//
//  MainViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "MainViewController.h"
#import "SqliteAccess.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    if ([self.dbAccess getGoal] == NULL) {
        [self.textLabel setText:@"请设定你的目标"];
        [self.clickButton setHidden:YES];
        NSLog(@"There is no goal.");
        [self performSelector:NSSelectorFromString(@"showGoal:") withObject:nil afterDelay:1];
    } else {
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
                [self.textLabel setText:[NSString stringWithFormat:@"你今天%@了吗？", [self.dbAccess getGoal]]];
                [self resetCLickButton];
            }
        } else {
            NSLog(@"First day, not finished.");
            [self.textLabel setText:[NSString stringWithFormat:@"你今天%@了吗？", [self.dbAccess getGoal]]];
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
                           RGBCOLOR(35, 46, 102), // 0:00-1:00
                           RGBCOLOR(83, 53, 124), // 2:00-3:00
                           RGBCOLOR(156, 48, 92), // 4:00-5:00
                           RGBCOLOR(255, 46, 1), // 6:00-7:00
                           RGBCOLOR(255, 103, 52), // 8:00-9:00
                           RGBCOLOR(255, 205, 85), // 10:00-11:00
                           RGBCOLOR(116, 232, 255), // 12:00-13:00
                           RGBCOLOR(4, 203, 255), // 14:00-15:00
                           RGBCOLOR(0, 189, 255), // 16:00-17:00
                           RGBCOLOR(0, 156, 255), // 18:00-19:00
                           RGBCOLOR(41, 87, 207), // 20:00-21:00
                           RGBCOLOR(81, 45, 158), // 22:00-23:00
                           RGBCOLOR(35, 14, 105), // 24:00-00:00
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

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateStatus];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)GoalViewControllerDidFinish:(GoalViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateStatus];
}

- (IBAction)showGoal:(id)sender
{
    GoalViewController *controller = [[GoalViewController alloc] initWithNibName:@"GoalViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
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
