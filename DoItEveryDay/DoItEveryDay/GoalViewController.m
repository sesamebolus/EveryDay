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
    
    [goalTextField setText:[self.dbAccess getGoal]];
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
    [goalTextField resignFirstResponder];
}

- (IBAction)saveGoal:(id)sender {
    [self.dbAccess setGoal:[goalTextField text]];
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
