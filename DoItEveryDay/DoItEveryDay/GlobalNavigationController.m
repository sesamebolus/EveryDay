//
//  GlobalNavigationController.m
//  DoItEveryDay
//
//  Created by 张 智超 on 14-2-13.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#import "GlobalNavigationController.h"
#import "GloabalUI.h"

@interface GlobalNavigationController ()

@end

@implementation GlobalNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (IOS7_OR_LATER) {
        UIView * statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
        [statusBarBackground setBackgroundColor:navigationColor];
        [self.navigationBar addSubview:statusBarBackground];
    }
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundColor:navigationColor];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    if (IOS7_OR_LATER) [self.navigationBar setBarTintColor:navigationColor];
    if (IOS6_OR_LATER) [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], UITextAttributeTextColor,
                                                          [UIColor clearColor], UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
                                                          [UIFont systemFontOfSize:21], UITextAttributeFont, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
