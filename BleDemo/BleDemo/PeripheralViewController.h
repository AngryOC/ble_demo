//
//  PeripheralViewController.h
//  BleDemo
//
//  Created by MacPro on 16/6/8.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "pickViewController.h"
#import "SetRangeViewController.h"

#import "RecordItem.h"
#import "DataBaseOperator.h"
#import "dataModel.h"

typedef NS_ENUM(NSInteger, Channel)
{
    //以下是枚举成员
    ReadChannel = 0,
    WriteChannel = 1,
    NotifyChannel = 2,
    NoneChannel = 4
};

typedef NS_ENUM(NSInteger, CMDType) {
    
    MCUStateCMD         = 0,    //接收 MCU 睡眠时 的状态
    RealtimeReportCMD   = 1,    //上报实时数据
    ThresholdReportCMD  = 2,    //报警阈值 上报
    RecordReportCMD     = 3,    //历史记录 上报
    MCUSeriesReportCMD  = 4,    //MCU序列号 上报
    VersionInfoCMD      = 5,    //硬件 系统 信息
    
    PMSetGetCMD         = 12,   //PM2.5 系数查询
    
    PMSetCMD            = 28,   //PM2.5 系数设定
    
    AlarmReportCMD      =  21,  //报警
    
    NoneCMD             = 48    //默认状态
    
    
};

@interface PeripheralViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,CBPeripheralDelegate, pickViewDelegate>

@property (nonatomic, strong) UITableView *characterTable;

@property (nonatomic, strong) CBPeripheral *selPeripheral;  //选中的外设

@property (nonatomic, strong) NSArray *UUIDSArray;

@property (nonatomic, strong) dataModel *dataBaseModel;


@property (weak, nonatomic) IBOutlet UITextView *reciveTextView;

@property (weak, nonatomic) IBOutlet UITextView *analyticTextView;

@property (weak, nonatomic) IBOutlet UITextField *cmdTextField;

@property (weak, nonatomic) UIPickerView *cmdPickView;

@property (weak, nonatomic) IBOutlet UISwitch *notifySwitch;



@property enum Channel cmdChannel;
@property enum CMDType cmdType;
@property UIView *overView;

@property NSMutableArray *dataArray1;



- (void)getTextStr:(NSString *)text;
- (void) getRangCMDString:(NSString *) cmdStr;

- (void) removeOverView;

@end
