//
//  MainViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "MainViewController.h"
#import "FMDatabase.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.clickButton setBackgroundColor:[UIColor blackColor]];
    [self.clickButton.layer setCornerRadius:80.0f];
}

- (void)updateStatus
{
    // setup and open SQLite database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    
    self.database = [FMDatabase databaseWithPath:path];
    
    if (![self.database open]) {
        NSLog(@"Could not open db.");
        return;
    }
    [self.database executeUpdate:@"create table log(date date primary key)"];
    
    // read the latest record from database
    FMResultSet *results = [self.database executeQuery:@"select * from log where rowid = (select max(rowid) from log)"];
    while([results next]) {
        NSDateComponents *lastDay = [[NSCalendar currentCalendar]
                                     components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                     fromDate:[results dateForColumn:@"date"]];
        NSDateComponents *today = [[NSCalendar currentCalendar]
                                   components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                   fromDate:[NSDate date]];
        if([today day] == [lastDay day] && [today month] == [lastDay month] && [today year] == [lastDay year] && [today era] == [lastDay era]) {
            NSLog(@"You have finished it today!");
            [self endingAnimation];
        } else {
            [self.textLabel setText:@"你今天运动了吗？"];
        }
    }
    [results close];
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

- (IBAction)submitButton:(id)sender
{
    [self endingAnimation];
        
    // insert a record to database
    NSDate *today = [NSDate date];
    [self.database executeUpdate:@"insert into log(date) values(?)", today, nil];
    
    // close database
    [self.database close];
}

#pragma mark - Ending Animation

- (void)endingAnimation
{
    [self.textLabel setText:@"很好，继续加油！"];
    
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
                         [self.clickButton removeFromSuperview];
                         [self animationFinished];
                     }];
}

- (void)animationFinished
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setTextLabel:nil];
    [self setTickImage:nil];
    [super viewDidUnload];
}
@end
