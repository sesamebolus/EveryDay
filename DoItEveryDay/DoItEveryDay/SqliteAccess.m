//
//  SqliteAccess.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-19.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "SqliteAccess.h"
#import "FMDatabase.h"
#import "LogItem.h"

#define kDataBaseName @"database.sqlite"

@implementation SqliteAccess

-(id) init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:kDataBaseName];
        
        self.database = [FMDatabase databaseWithPath:path];
    }
    return self;
}

-(void) creatDatabase
{
    [self.database executeUpdate:@"create table log(date date primary key)"];
    [self.database executeUpdate:@"create table config(name text primary key, value text)"];
}

-(void) openDatabase
{
    if (![self.database open]) {
        [self.database open];
    }
}

-(void) closeDatabse
{
    if ([self.database open]) {
        [self.database close];
    }
}

#pragma mark - Log Table

-(NSDate *)getLastRecord
{
    FMResultSet *results = [self.database executeQuery:@"select * from log where rowid = (select max(rowid) from log)"];
    NSDate *lastRecord;
    while([results next]) {
        lastRecord = [results dateForColumn:@"date"];
    }
    [results close];
    return lastRecord;
}

-(void) deleteRecordAtIndex: (NSInteger)index
{
    [self.database executeUpdate:@"delete from log where rowid = ?", [NSNumber numberWithInt:index]];
    if ([self.database hadError]) {
        NSLog(@"Err %d: %@", [self.database lastErrorCode], [self.database lastErrorMessage]);
    }
}

-(void) insertRecord: (NSDate *)date
{
    [self.database executeUpdate:@"insert into log(date) values(?)", date, nil];
}

-(NSMutableArray *) getRecordList
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *results = [self.database executeQuery:@"select rowid, * from log order by date desc limit 30"];
    while([results next]) {
        LogItem *logItem = [[LogItem alloc] init];
        logItem.rowid = [results intForColumn:@"rowid"];
        logItem.date = [results dateForColumn:@"date"];
        [dataArray addObject:logItem];
    }
    [results close];
    return dataArray;
}

#pragma mark - Config Table


-(void) setGoal: (NSString *)goal
{
    [self.database executeUpdate:@"insert or replace into config(name, value) values(?, ?)", @"goal", goal];
}

-(void) deleteGoal
{
   [self.database executeUpdate:@"delete from config where name = ?", @"goal"];
}

-(NSString *) getGoal
{
    NSString *goal;
    FMResultSet *results = [self.database executeQuery:@"select value from config where name = ?", @"goal"];
    while([results next]) {
        goal = [results stringForColumn:@"value"];
    }
    [results close];
    return goal;
}


@end
