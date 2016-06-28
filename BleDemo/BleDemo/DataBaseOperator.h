//
//  DataBaseOperator.h
//  BleDemo
//
//  Created by MacPro on 16/6/23.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "RecordItem.h"

@interface DataBaseOperator : NSObject

@property (strong, nonatomic) FMDatabase *recordDB; 

- (NSMutableArray *)searchDB;

- (BOOL) insertIntoDB:(RecordItem *) aRecord;

- (BOOL) deleteFromDB:(RecordItem *) aRecord;

- (BOOL) updateDB:(RecordItem *)oldRecord withNew:(RecordItem *)newRecord;

- (BOOL) closeDB;

@end
