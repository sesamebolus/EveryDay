//
//  SqliteAccess.m
//  DoItEveryDay
//
//  Created by 张 智超 on 13-4-19.
//  Copyright (c) 2013年 张 智超. All rights reserved.
//

#import "SqliteAccess.h"
#import "FMDatabase.h"

#define kDataBaseName @"database.sqlite"

@implementation SqliteAccess

-(void) openDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:kDataBaseName];
    
    self.database = [FMDatabase databaseWithPath:path];
    
    if (![self.database open]) {
        NSLog(@"Could not open db.");
    }
}

-(void) creatDatabase
{
    [self.database executeUpdate:@"create table log(date date primary key)"];
    [self.database executeUpdate:@"create table goal(name text primary key)"];
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

-(void) deleteLastRecord
{
    [self.database executeUpdate:@"delete from log where rowid = (select max(rowid) from log)"];
}

-(void) insertRecord: (NSDate *)date
{
    [self.database executeUpdate:@"insert into log(date) values(?)", date, nil];
}

-(NSMutableArray *) getRecordList
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *results = [self.database executeQuery:@"select * from log order by date desc limit 30"];
    while([results next]) {
        NSDate *targetDate = [results dateForColumn:@"date"];
        [dataArray addObject:targetDate];
    }
    [results close];
    return dataArray;
}

#pragma mark - Goal Table


-(void) setGoal: (NSString *)goal
{
    [self deleteGoal];
    [self.database executeUpdate:@"insert into goal(name) values(?)", goal];
}

-(void) deleteGoal
{
   [self.database executeUpdate:@"delete from goal"]; 
}

-(NSString *) getGoal
{ 
    NSString *goal;
    FMResultSet *results = [self.database executeQuery:@"select * from goal where rowid = (select max(rowid) from goal)"];
    while([results next]) {
        goal = [results stringForColumn:@"name"];
    }
    [results close];
    return goal;
}


@end
