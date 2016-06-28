//
//  dataModel.h
//  BleDemo
//
//  Created by MacPro on 16/6/27.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordItem.h"
#import "DataBaseOperator.h"

@interface dataModel : NSObject


@property (strong, nonatomic) DataBaseOperator *dataBaseOP;
@property (strong, nonatomic) NSMutableArray *allRecords;

- (NSMutableArray *)readAllFromDB;
- (void) showAllRecord;
- (BOOL) insertIntoDB:(RecordItem *) aRecord;
- (RecordItem *) getRecordByIndex:(NSUInteger) index;

@end
