//
//  dataModel.m
//  BleDemo
//
//  Created by MacPro on 16/6/27.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import "dataModel.h"
#import "DataBaseOperator.h"


@implementation dataModel

-(id)init{
    if (self) {
        self = [super init];
    }
    _dataBaseOP = [[DataBaseOperator alloc]init];
    
    _allRecords = [_dataBaseOP searchDB];
    
    return self;
}




- (NSMutableArray *)readAllFromDB {
    
     _allRecords = [_dataBaseOP searchDB];
    
    
    return _allRecords;
}

- (void) showAllRecord {
    for (RecordItem *record in _allRecords) {
        NSLog(@"%@ || %@ %@ %@ %@ %@ ||%@ %@ %@ %@ ||%@ %@ %@ %@", record.recordID,
              record.temperature,
              record.COValue,
              record.COOValue,
              record.HCHOValue,
              record.PMValue,
              record.moving,
              record.multiPerson,
              record.locked,
              record.isUsing,
              record.sended,
              record.insertTime,
              record.sendTime,
              record.sendCounts
              );
    }
}




- (BOOL) insertIntoDB:(RecordItem *) aRecord {
    
    //手动 设置 新纪录的 序号
    aRecord.recordID = [NSNumber numberWithInteger:_allRecords.count+1];
    [_allRecords addObject:aRecord];
    
    if([_dataBaseOP insertIntoDB:aRecord]){
        
        return YES;
        
    } else {
        
        return NO;
    }
}
- (RecordItem *) getRecordByIndex:(NSUInteger) index {
    
    
    
    return nil;
}



@end
