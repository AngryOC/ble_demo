//
//  PeripheralViewController.m
//  BleDemo
//
//  Created by MacPro on 16/6/8.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import "PeripheralViewController.h"
#import "pickViewController.h"





#define kServiceUUID @"180F"
#define kCharacWriteUUID @"33221102-5544-7766-9988-AABBCCDDEEFF"
#define kCharacReadUUID @"33221104-5544-7766-9988-AABBCCDDEEFF"

typedef NS_ENUM(NSInteger, Channel)
{
    //以下是枚举成员
    ReadChannel = 0,
    WriteChannel = 1,
    NotifyChannel = 2,
    NoneChannel = 4
};

typedef NS_ENUM(NSInteger, CMDType) {
    RealtimeReportCMD   = 1,    //上报实时数据
    ThresholdReportCMD  = 2,    //报警阈值 上报
    RecordReportCMD     = 3,    //历史记录 上报
    MCUSeriesReportCMD  = 4,    //MCU序列号 上报
    PMReportCMD         = 12,   //PM2.5 上报
    
    AlarmReportCMD      =  21,     //报警
    
    NoneCMD             = 0
    
    
};

//static NSString * const kServiceUUID = @"Battery";
static NSString * const kCharacteristicUUID = @"9D69C18C-186C-45EA-A7DA-6ED7500E9C97";

@interface PeripheralViewController () {
    enum Channel cmdChannel;
    enum CMDType cmdType;
    UIView *overView;
    
    NSMutableArray *dataArray1;
    
}

@end

@implementation PeripheralViewController


- (NSArray *) UUIDSArray {
    if (_UUIDSArray == nil) {
        _UUIDSArray = [[NSArray alloc] init];
    }
    return _UUIDSArray;
}

- (void)getTextStr:(NSString *)text{
    _cmdTextField.text = text;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    dataArray1 = [[NSMutableArray alloc] init];
    
    
    _reciveTextView.editable = NO;
    _analyticTextView.editable = NO;
    
    cmdChannel  = NoneChannel;
    cmdType     = NoneCMD;
    


}




#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}

#pragma mark - tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}


#pragma mark - peripheral delegate
- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
     NSLog(@"__%s__", __func__);
    
    if (error) {
        NSLog(@"Error discovering service: %@", [error localizedDescription]);
//        [self cleanup];
        return;
    }
    
    //通知时仅仅发现 180f 服务
    CBService *service = [aPeripheral.services firstObject];
    [self.selPeripheral discoverCharacteristics:nil forService:service];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    
     NSLog(@"__%s__", __func__);
    
    if (error) {
        NSLog(@"Error discovering characteristic: %@", [error localizedDescription]);

        return;
    } else {
        
        NSLog(@"%@", service.UUID);
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            
            switch (cmdChannel) {
                case ReadChannel: {
                    for (CBCharacteristic *characteristic in service.characteristics) {
                        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacReadUUID]]) {
                            [self.selPeripheral readValueForCharacteristic:characteristic];
                        }
                    }
                    
                }
                    break;
                    
                case WriteChannel: {
                    for (CBCharacteristic *characteristic in service.characteristics) {
                        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacWriteUUID]]) {
                            [self.selPeripheral writeValue:[self dataFormHexString:_cmdTextField.text] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                        }
                    }
                    
                }
                    break;
                case NotifyChannel :{
                    for (CBCharacteristic *characteristic in service.characteristics) {
                        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacReadUUID]]) {
                            [self.selPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                        }
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        } else {
            NSLog(@"服务匹配错误%@", service.UUID.UUIDString);
            return;
        }
    }
    
}




- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
     NSLog(@"__%s__", __func__);
    
    if (error) {
        NSLog(@"Error didWriteValueForCharacteristic: %@", [error localizedDescription]);
    } else {
        NSLog(@"发送数据成功");

    }
    
    
}


//特征值 改变了 调用此方法  在 写入||获得新数据 时 调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
     NSLog(@"__%s__", __func__);
    
    if (error) {
        
         NSLog(@"Error didUpdateValueForCharacteristic: %@", error.localizedDescription);
        NSLog(@"%@", characteristic);
        //- (void)setOn:(BOOL)on animated:(BOOL)animated;
//        [_notifySwitch setOn:NO animated:YES];
        
    } else {
        
        //接收到通知 打印数据
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacReadUUID]]) {
            
            if (characteristic.isNotifying) {
                NSLog(@"Notification began on %@", characteristic);
                
               // [peripheral readValueForCharacteristic:characteristic];
                NSLog(@"通知 characteristic.value___%@ ", characteristic.value);
                
                //打印通知 log
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSString *timeStr = [formatter stringFromDate:[NSDate date]];
                
                _reciveTextView.text = [_reciveTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ 接收 \n%@\n\n",timeStr, characteristic.value]];
 // -----------解析
                _analyticTextView.text = [_analyticTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ 接收 \n%@\n\n",timeStr, [self analyResultStr:[self hexToString: characteristic.value]]]];
                
                //自动滚动到最后一行
                if (_reciveTextView.contentSize.height > _reciveTextView.bounds.size.height){
                    [_reciveTextView setContentOffset:CGPointMake(0.f, _reciveTextView.contentSize.height - _reciveTextView.bounds.size.height - 20) animated:YES];
                }
                
                if (_analyticTextView.contentSize.height > _analyticTextView.bounds.size.height) {
                    [_analyticTextView setContentOffset:CGPointMake(0.f, _analyticTextView.contentSize.height - _analyticTextView.bounds.size.height - 25 ) animated:YES];
                }
                
                
            } else {
                
                NSLog(@"++ characteristic.value___%@ ", characteristic.value);
                
            }
            
        }
        
        
    }
    
}

//通知 状态更新
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"__%s",__func__);
    
    if (error) {
        
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        
        NSLog(@"%@", characteristic);
        //- (void)setOn:(BOOL)on animated:(BOOL)animated;
        [_notifySwitch setOn:NO animated:YES];
        
        return;
    }
//    
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacReadUUID]]) {
//        NSLog(@"获得最新数据");
//        //打印结果 log
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//        NSString *timeStr = [formatter stringFromDate:[NSDate date]];
//        
//        _reciveTextView.text = [_reciveTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ 通知 \n%@\n\n",timeStr, characteristic.value]];
//        
// //___________解析的数据
//        _analyticTextView.text = [_analyticTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ 通知 \n%@\n\n",timeStr, [self analyResultStr:[self hexToString: characteristic.value]]]];
//        
//        //自动滚动到最后一行
//        if (_reciveTextView.contentSize.height > _reciveTextView.bounds.size.height){
//            [_reciveTextView setContentOffset:CGPointMake(0.f, _reciveTextView.contentSize.height - _reciveTextView.bounds.size.height - 20) animated:YES];
//        }
//        
//        if (_analyticTextView.contentSize.height > _analyticTextView.bounds.size.height) {
//            [_analyticTextView setContentOffset:CGPointMake(0.f, _analyticTextView.contentSize.height - _analyticTextView.bounds.size.height  - 25 ) animated:YES];
//        }
//        
//        
//        
//    } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacWriteUUID]]) {
//        NSLog(@"数据写入成功");
//        
//    }

    NSLog(@"%@",characteristic);
    
}




- (IBAction)NoticeSwitch:(UISwitch *)sender {
    
    NSLog(@"----%s", __func__);
    
    if (sender.on) {
        
        NSLog(@"接收实时数据");
        
        cmdChannel = NotifyChannel;
        
        //外设找到 服务（180F）--找到特征（1104） -- 设置 通知（True）
        [self.selPeripheral discoverServices:@[[CBUUID UUIDWithData:[self dataFormHexString:@"180F"]]]];
        
        
    } else {
        
        NSLog(@"不接收实时数据");
    }
    
}

//发送指令 事件
- (IBAction)sendCMDBtnClick:(UIButton *)sender {
    
    if(_cmdTextField.text.length == 0) {
        NSLog(@"没有 命令");
        return;
    }
    
    //获取 命令行的文本 检查外设连接状态 -- 找到服务（180f）-- 找到特征（1102）-- 写入 命令
    [_cmdTextField endEditing:YES];
    
    cmdChannel = WriteChannel;
    
    //打印通知 log
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    
    _reciveTextView.text = [_reciveTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ 写入 \n---->%@\n\n",timeStr, _cmdTextField.text]];
    
    
    [self.selPeripheral discoverServices:@[[CBUUID UUIDWithData:[self dataFormHexString:@"180F"]]]];
    
    
}

- (IBAction)selectCMDBtnClick:(UIButton *)sender {
    
    pickViewController *pick = [[pickViewController alloc] initWithNibName:@"pickViewController" bundle:nil];
    
    pick.delegate = self;
    
    pick.modalPresentationStyle = UIModalPresentationCustom;
    
    //加层蒙版
    overView = [[UIView alloc] initWithFrame:self.view.bounds];
    overView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [self.view addSubview:overView];
    
    [self presentViewController:pick animated:YES completion:nil];
    
}

- (void) removeOverView {
    [overView removeFromSuperview];
}




- (void) viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData*)dataFormHexString:(NSString*)hexString{
    hexString=[[hexString uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!(hexString && [hexString length] > 0 && [hexString length]%2 == 0)) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}


- (NSString *) hexToString:(NSData *) hex {
    
    NSString *hexStr = [NSString stringWithFormat:@"%@",hex];
    
    hexStr = [[hexStr uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"hexStr  %@", hexStr);
    
    return hexStr;
}
/*
 RealtimeReportCMD   = 1,    //上报实时数据
 ThresholdReportCMD  = 2,    //报警阈值 上报
 RecordReportCMD     = 3,    //历史记录 上报
 MCUSeriesReportCMD  = 4,    //MCU序列号 上报
 PMReportCMD         = 12,   //PM2.5 上报
 
 AlarmReportCMD      =  21,     //报警
 */

- (NSString *) analyResultStr:(NSString *) result {
    if (result.length == 0) {
        return nil;
    }
    NSString *returnStr;
    
    //获取命令 类型  接收报文 第 5 6 表示 命令序号
    NSString *cmdIndex = [result substringWithRange:NSMakeRange(5, 2)];
    
    switch ([cmdIndex integerValue]) {
            //上报实时数据
        case RealtimeReportCMD: {
            
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < 6; i++) {
                
                NSString *str = [[result substringWithRange:NSMakeRange(9 + i*4, 2)] stringByAppendingString:[result substringWithRange:NSMakeRange(7 + i*4, 2)]];
                
                unsigned long number = strtoul([str UTF8String], 0, 16);
                
                [dataArray addObject:[NSNumber numberWithUnsignedLong:number]];
            }
            
            returnStr = [NSString stringWithFormat:@"实时数据 {电压:%0.3f | 温度：%lu | CO: %0.1f | CO2: %lu | HCHO: %0.2f | PM2.5 %lu }", [dataArray[0] unsignedLongValue]/1000.0, [dataArray[1] unsignedLongValue], [dataArray[2] unsignedLongValue]/10.0, [dataArray[3] unsignedLongValue], [dataArray[4] unsignedLongValue]/100.0, [dataArray[5] unsignedLongValue]];
            NSLog(@"   %@", returnStr);
            
        }
            break;
            
        case ThresholdReportCMD: {
            
            
            
            for (int i = 0; i < 7; i++) {
                
                NSString *str = [[result substringWithRange:NSMakeRange(9 + i*4, 2)] stringByAppendingString:[result substringWithRange:NSMakeRange(7 + i*4, 2)]];
                
                unsigned long number = strtoul([str UTF8String], 0, 16);
                
                [dataArray1 addObject:[NSNumber numberWithUnsignedLong:number]];
            }
            
            returnStr = [NSString stringWithFormat:@"阈值数据 {温度下限:%lu | 温度上限：%lu | CO上限: %0.1f | CO2上限: %lu | HCHO上限: %0.2f | PM2.5上限 %lu | 孩子遗留时间上限：%lu }", [dataArray1[0] unsignedLongValue], [dataArray1[1] unsignedLongValue], [dataArray1[2] unsignedLongValue]/10.0, [dataArray1[3] unsignedLongValue], [dataArray1[4] unsignedLongValue]/100.0, [dataArray1[5] unsignedLongValue], [dataArray1[6] unsignedLongValue]];

            
            NSLog(@"   %@", returnStr);
            
            
        }
            break;
        case RecordReportCMD: {
            
            
        }
            break;
        case MCUSeriesReportCMD: {
            
        }
            break;
        case AlarmReportCMD: {
            
        }
            break;
            
        default:
            break;
    }
    
    return returnStr;
}



- (IBAction)clrBtnClick:(UIButton *)sender {
    _reciveTextView.text = @"";
    _analyticTextView.text = @"";
}

- (IBAction)analyticBtnClick:(UIButton *)sender {
    [self analyResultStr:@"<FA0F01A21F1C000000A90103003F001000AF>"];
}

- (IBAction)setRangeBtnClick:(UIButton *)sender {
    
    if (dataArray1.count == 0) {
        
        NSLog(@"请先查询阈值");
        
        return;
    }
    
    SetRangeViewController *setVC  = [[SetRangeViewController alloc] initWithNibName:@"SetRangeViewController" bundle:nil];

    setVC.rangeArray = [dataArray1 copy];
    
    [self.navigationController pushViewController:setVC animated:YES];
    
}



- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_cmdTextField endEditing:YES];
    
    [_cmdTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
