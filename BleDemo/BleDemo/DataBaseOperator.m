//
//  DataBaseOperator.m
//  BleDemo
//
//  Created by MacPro on 16/6/23.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import "DataBaseOperator.h"


@implementation DataBaseOperator


- (id) init {
    if (self = [super init]) {
        [self initDB];
    }
    return self;
}

/*
 'RecordID'     主键 自增 integer
 'Temperature'  温度 integer
 'CO'           CO浓度 integer
 'COO'          CO2浓度 integer
 'PM'           PM2.5浓度 integer
 
 'Moving'       驾驶状态 0/1                0 停止/ 1行驶
 'Locked'       卡扣是否锁住 0/1              0 未锁/ 1锁住
 'MultiPerson'  是否有除孩子外的其他人 0/1     0 没有/1 存在
 'Using'        座椅使用状态 0/1              0 未使用/ 1 使用中
 
 'InsertTime'   app将数据插入表格的时间  app端的时间 TEXT
 
 'Sended'       此记录发送服务器的状态 0 未上传服务器/1 上传服务器成功
 'SendTime'     上传服务器成功的时间 TEXT
 'SendCounts'   上传服务器的次数 integer
 */

- (void) initDB {
    _recordDB = [FMDatabase databaseWithPath:[self getDBFilePath]];
    
    //打开数据库
    if([_recordDB open])
    {
        //创建表
        NSString *str = @"CREATE TABLE  IF NOT EXISTS T_Real_Record('RecordID' integer primary key autoincrement not NULL, 'Temperature' integer, 'CO' integer, 'COO' integer, 'HCHO' integer, 'PM' integer, 'Moving'  integer, 'Locked' integer, 'MultiPerson' integer, 'Using' integer, 'Sended'  integer, 'InsertTime' TEXT, 'SendTime' TEXT, 'SendCounts' integer)";
//        NSString *str = @"CREATE TABLE  IF NOT EXISTS T_Real_Record('recordID' integer)";
        if([_recordDB executeUpdate:str])
        {
            NSLog(@"创建表成功");
        }
        else
        {
            NSLog(@"创建表失败");
        }
        [self closeDB];
    }
    else
    {
        NSLog(@"数据库打开失败");
    }

    
}

- (NSString *)getDBFilePath {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    filePath = [NSString stringWithFormat:@"%@/recordSqlite.db",filePath];

    return filePath;
}

- (NSMutableArray *) searchDB {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([_recordDB open]) {
        
        NSString *sqlStr = @"select * from T_Real_Record";
        
        FMResultSet *resultSet = [_recordDB executeQuery:sqlStr];
        
//        if (!resultSet) {
//            NSLog(@"查询失败");
//            return nil;
//        }
        
        while ([resultSet next]) {
            
            RecordItem *aRecord = [[RecordItem alloc] init];
            
            aRecord.recordID    = [NSNumber numberWithInteger:[resultSet intForColumn:@"RecordID"]];
            aRecord.temperature = [NSNumber numberWithInteger:[resultSet intForColumn:@"Temperature"]];
            aRecord.COValue     = [NSNumber numberWithInteger:[resultSet intForColumn:@"CO"]];
            aRecord.COOValue    = [NSNumber numberWithInteger:[resultSet intForColumn:@"COO"]];
            aRecord.HCHOValue   = [NSNumber numberWithInteger:[resultSet intForColumn:@"HCHO"]];
            aRecord.PMValue     = [NSNumber numberWithInteger:[resultSet intForColumn:@"PM"]];
            
            aRecord.moving      = [NSNumber numberWithInteger:[resultSet intForColumn:@"Moving"]];
            aRecord.locked      = [NSNumber numberWithInteger:[resultSet intForColumn:@"Locked"]];
            aRecord.multiPerson = [NSNumber numberWithInteger:[resultSet intForColumn:@"MultiPerson"]];
            aRecord.isUsing     = [NSNumber numberWithInteger:[resultSet intForColumn:@"Using"]];
            
            aRecord.sended      = [NSNumber numberWithInteger:[resultSet intForColumn:@"Sended"]];
            aRecord.insertTime  = [resultSet stringForColumn:@"InsertTime"];
            aRecord.sendTime    = [resultSet stringForColumn:@"SendTime"];
            aRecord.sendCounts  = [NSNumber numberWithInteger:[resultSet intForColumn:@"SendCounts"]];
            
            [array addObject:aRecord];
            
        }
        
        [self closeDB];
        
    } else {
        
        NSLog(@"%s数据库打开失败", __func__);
    }
    
    return array;
}


- (BOOL) insertIntoDB:(RecordItem *) aRecord  {
    BOOL result = NO;
//    NSNumber *num = [NSNumber numberWithInteger:2];
//    
    if ([_recordDB open]) {
        
//        NSString *sqlStr = [NSString stringWithFormat:@"insert into T_Real_Record('recordID') VALUES (?)"];
//        if ([_recordDB executeUpdate:sqlStr,num]) {
//            NSLog(@"插入成功");
//        } else {
//            NSLog(@"插入失败");
//        }
//    }
    
        NSString *sqlStr = [NSString stringWithFormat:@"insert into T_Real_Record('Temperature', 'CO', 'COO' , 'HCHO' , 'PM' , 'Moving' , 'Locked' , 'MultiPerson' , 'Using' , 'Sended', 'InsertTime', 'SendTime', 'SendCounts') VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
        
        if ([_recordDB executeUpdate:sqlStr, aRecord.temperature,
             aRecord.COValue,
             aRecord.COOValue,
             aRecord.HCHOValue,
             aRecord.PMValue,
             aRecord.moving,
             aRecord.locked,
             aRecord.multiPerson,
             aRecord.isUsing,
             aRecord.sended,
             aRecord.insertTime,
             aRecord.sendTime,
             aRecord.sendCounts
             ]) {
            
            result = YES;
            
            NSLog(@"插入成功");
            
        } else {
            
            NSLog(@"%s 执行插入语句失败", __func__);
            
        }
        
    } else {
        NSLog(@"%s 插入时 打开数据库失败", __func__);
    }
    

    return result;
}

- (BOOL) deleteFromDB:(RecordItem *) aRecord {
    return YES;
}

- (BOOL) updateDB:(RecordItem *)oldRecord withNew:(RecordItem *)newRecord {
    return YES;
}

- (BOOL) closeDB {
    
    [_recordDB close];
    
    return YES;
}




@end
