//
//  SetRangeViewController.m
//  BleDemo
//
//  Created by MacPro on 16/6/14.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import "SetRangeViewController.h"

@interface SetRangeViewController ()

@end

@implementation SetRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"设置阈值";
}

- (NSMutableArray *) rangeArray {
    if (_rangeArray == nil) {
        _rangeArray = [[NSMutableArray alloc] init];
    }
    return _rangeArray;
}

- (void) viewDidAppear:(BOOL)animated {
        self.minTempTF.text = [NSString stringWithFormat:@"%lu",[_rangeArray[0] unsignedLongValue]];
        self.maxTF.text = [NSString stringWithFormat:@"%lu",[_rangeArray[1] unsignedLongValue]];
    
        self.coTF.text = [NSString stringWithFormat:@"%0.1f",[_rangeArray[2] unsignedLongValue]/10.0];
        self.cooTF.text = [NSString stringWithFormat:@"%lu",[_rangeArray[3] unsignedLongValue]];
        self.hchoTF.text = [NSString stringWithFormat:@"%0.2f",[_rangeArray[4] unsignedLongValue]/100.0];
        self.pmTF.text = [NSString stringWithFormat:@"%lu",[_rangeArray[5] unsignedLongValue]];
    
        self.leaveTimeTF.text = [NSString stringWithFormat:@"%lu",[_rangeArray[6] unsignedLongValue]];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
     NSLog(@"xxx");
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温度" message:@"原来的温度" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"输入新的界值";
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    
    [alert addAction:okAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    return NO;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
