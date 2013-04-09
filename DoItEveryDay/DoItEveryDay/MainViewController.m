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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *colorArray = [NSArray arrayWithObjects:
                           RGBCOLOR(0, 0, 0),
                           RGBCOLOR(76, 16, 0),
                           RGBCOLOR(141, 29, 0),
                           RGBCOLOR(255, 46, 1),
                           RGBCOLOR(255, 115, 5),
                           RGBCOLOR(255, 213, 5),
                           RGBCOLOR(127, 210, 226),
                           RGBCOLOR(90, 178, 209),
                           RGBCOLOR(83, 141, 210),
                           RGBCOLOR(41, 87, 207),
                           RGBCOLOR(82, 54, 99),
                           RGBCOLOR(64, 34, 82),
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
    [self.view.layer addSublayer:self.gradient];
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
