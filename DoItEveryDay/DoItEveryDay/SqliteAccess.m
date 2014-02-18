//
//  SqliteAccess.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-19.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "SqliteAccess.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
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

-(void) createDatabase
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

-(NSUInteger) getTotalRecord
{
    NSUInteger count = [self.database intForQuery:@"select count(date) from log"];
    return count;
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
    FMResultSet *results = [self.database executeQuery:@"select rowid, * from log order by date desc"];
    while([results next]) {
        LogItem *logItem = [[LogItem alloc] init];
        logItem.rowid = [results intForColumn:@"rowid"];
        logItem.date = [results dateForColumn:@"date"];
        [dataArray addObject:logItem];
    }
    [results close];
    return dataArray;
}

-(NSUInteger) getProgress
{
    NSUInteger count = [self.database intForQuery:@"select count(date) from log where date between ? and ?",
                        [NSDate dateWithTimeInterval:-86400*7 sinceDate:[NSDate date]],
                        [NSDate date]];
    return count;
}

@end
