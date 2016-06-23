//
//  RecordItem.h
//  BleDemo
//
//  Created by MacPro on 16/6/22.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordItem : NSObject

/*记录时间  保存成串*/
@property (strong, nonatomic) NSString *recordTime;

/*温度 精确到1 封装在NSNumber中的为 integer*/
@property (strong, nonatomic) NSNumber *temperature;

/*CO浓度值  精确到0.1ppm  乘以10 后 封装在NSNumber中 为 integer*/
@property (strong, nonatomic) NSNumber *COValue;

/*CO2浓度值 精确到1ppm  封装在NSNumber中 为integer*/
@property (strong, nonatomic) NSNumber *COOValue;

/*HCHO浓度控制 精确到0.01ppm 乘以100 后 封装在NSNumber 中为 integer*/
@property (strong, nonatomic) NSNumber *HCHOValue;

/*PM2.5浓度值 精确到1ppm  封装在NSNmuber中为 integer*/
@property (strong, nonatomic) NSNumber *PMValue;


@end
