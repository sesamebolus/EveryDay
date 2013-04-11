//
//  MainViewController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-9.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "MainViewController.h"

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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.clickButton setFrame:CGRectMake(
                                          ((UIView *)sender).frame.origin.x,
                                          ((UIView *)sender).frame.origin.y + ((UIView *)sender).frame.size.height / 2,
                                          ((UIView *)sender).frame.size.width,
                                          ((UIView *)sender).frame.size.height
                                          )];
    [UIView commitAnimations];
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

@end
