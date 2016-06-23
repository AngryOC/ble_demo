//
//  DataBaseOperator.m
//  BleDemo
//
//  Created by MacPro on 16/6/23.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import "DataBaseOperator.h"


@implementation DataBaseOperator

- (NSMutableArray *) searchDB {
    return nil;
}


- (BOOL) insertIntoDB:(RecordItem *) aRecord  {
    return YES;
}

- (BOOL) deleteFromDB:(RecordItem *) aRecord {
    return YES;
}

- (BOOL) updateDB:(RecordItem *)oldRecord withNew:(RecordItem *)newRecord {
    return YES;
}

- (BOOL) closeDB {
    
    return YES;
}




@end
