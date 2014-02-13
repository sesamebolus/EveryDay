//
//  GloabalUI.m
//  DoItEveryDay
//
//  Created by 张 智超 on 14-2-12.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#import "GloabalUI.h"

@implementation UIBarButtonItem(GlobalUIBarButtonItem)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customUIBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return customUIBarButtonItem;
}

+ (UIBarButtonItem*)barItemWithTitle:(NSString*)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setFrame:CGRectMake(0, 0, [button.titleLabel.text sizeWithFont:button.titleLabel.font].width + 3, 24)];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customUIBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return customUIBarButtonItem;
}

@end