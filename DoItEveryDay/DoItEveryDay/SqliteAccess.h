//
//  SqliteAccess.h
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-19.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface SqliteAccess : NSObject

@property (nonatomic, retain) FMDatabase *database;

-(void) openDatabase;
-(void) createDatabase;
-(void) closeDatabse;

-(NSDate *) getLastRecord;
-(NSUInteger) getTotalRecord;
-(void) deleteRecordAtIndex: (NSInteger)index;
-(void) insertRecord: (NSDate *)date;
-(NSMutableArray *) getRecordList;
-(NSMutableArray *) getRecordListForMonth:(NSString *)monthString;
-(NSUInteger) getProgress;

@end