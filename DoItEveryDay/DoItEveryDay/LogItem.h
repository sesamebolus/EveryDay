//
//  LogItem.h
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-25.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogItem : NSObject
{
    int rowid;
    NSDate *date;
}

@property (nonatomic, assign) int rowid;
@property (nonatomic, copy) NSDate *date;

@end
