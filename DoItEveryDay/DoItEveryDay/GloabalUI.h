//
//  GloabalUI.h
//  DoItEveryDay
//
//  Created by 张 智超 on 14-2-12.
//  Copyright (c) 2014年 张 智超. All rights reserved.
//

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define navigationColor RGBCOLOR(32, 189, 241)

#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )

@interface UIBarButtonItem(GlobalUIBarButtonItem)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)barItemWithTitle:(NSString*)title target:(id)target action:(SEL)action;

@end