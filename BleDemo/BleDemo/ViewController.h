//
//  ViewController.h
//  BleDemo
//
//  Created by MacPro on 16/6/7.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) UITableView *deviceTable;

@property (strong, nonatomic) CBCentralManager *centerManager;

@property (strong, nonatomic) NSMutableArray *deviceList;

@end

