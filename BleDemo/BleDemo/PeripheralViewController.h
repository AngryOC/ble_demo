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

@interface PeripheralViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,CBPeripheralDelegate, pickViewDelegate, NSCopying>

@property (nonatomic, strong) UITableView *characterTable;

@property (nonatomic, strong) CBPeripheral *selPeripheral;  //选中的外设

@property (nonatomic, strong) NSArray *UUIDSArray;


@property (weak, nonatomic) IBOutlet UITextView *reciveTextView;

@property (weak, nonatomic) IBOutlet UITextView *analyticTextView;

@property (weak, nonatomic) IBOutlet UITextField *cmdTextField;

@property (weak, nonatomic) UIPickerView *cmdPickView;

@property (weak, nonatomic) IBOutlet UISwitch *notifySwitch;



- (void)getTextStr:(NSString *)text;

- (void) removeOverView;

@end
