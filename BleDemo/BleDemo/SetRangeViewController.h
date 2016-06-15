//
//  SetRangeViewController.h
//  BleDemo
//
//  Created by MacPro on 16/6/14.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetRangeViewController : UIViewController <UITextFieldDelegate>




@property (weak, nonatomic) IBOutlet UITextField *minTempTF;

@property (weak, nonatomic) IBOutlet UITextField *maxTF;


@property (weak, nonatomic) IBOutlet UITextField *coTF;


@property (weak, nonatomic) IBOutlet UITextField *cooTF;

@property (weak, nonatomic) IBOutlet UITextField *hchoTF;

@property (weak, nonatomic) IBOutlet UITextField *pmTF;

@property (weak, nonatomic) IBOutlet UITextField *leaveTimeTF;


@property (nonatomic)NSMutableArray *rangeArray;

@property id delegate;

@end
