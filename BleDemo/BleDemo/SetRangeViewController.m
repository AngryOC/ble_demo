//
//  SetRangeViewController.m
//  BleDemo
//
//  Created by MacPro on 16/6/14.
//  Copyright © 2016年 MacPro. All rights reserved.
//

#import "SetRangeViewController.h"
#import "PeripheralViewController.h"

@interface SetRangeViewController ()

@end

@implementation SetRangeViewController {
    NSArray *titleNames;
    NSArray *multipleCounts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"设置阈值";
    
    titleNames = [NSArray arrayWithObjects:@"温度",@"温度", @"CO浓度", @"COO浓度", @"HCHO浓度", @"PM指数", @"遗留时间",  nil];
    multipleCounts = [NSArray arrayWithObjects:@"1", @"1", @"10", @"1", @"100", @"1", @"1",  nil];
}

- (NSMutableArray *) rangeArray {
    if (_rangeArray == nil) {
        _rangeArray = [[NSMutableArray alloc] init];
    }
    return _rangeArray;
}

- (void) viewWillAppear:(BOOL)animated {
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
    
    NSString *subTitleStr;
    if (textField.tag == 0) {
        subTitleStr = @"最小值";
    } else {
        subTitleStr = @"最大值";
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:[titleNames objectAtIndex:textField.tag] message:[NSString stringWithFormat:@"%@：%@", subTitleStr, textField.text] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"输入新的界值";
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    __weak UIAlertController *weakAlert = alert;
    __weak UITextField *weakTF = textField;
    __weak NSMutableArray *weakRanges = _rangeArray;
//    __weak SetRangeViewController *weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
//        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        UITextField *tmpTF  = [weakAlert.textFields firstObject];
        
        
        weakTF.text  = tmpTF.text;
        
        unsigned long num = [tmpTF.text doubleValue] *[ multipleCounts[weakTF.tag] integerValue];
        
        [weakRanges replaceObjectAtIndex:weakTF.tag withObject:[NSNumber numberWithUnsignedLong:num]];
        
        NSLog(@"_rangeArray  %@", weakRanges[weakTF.tag]);
        
        weakTF.textColor = [UIColor redColor];
        
//        
//        [weakSelf.delegate setRangeCDMStr:
//        
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        
    }];
    
    [alert addAction:cancelAction];
    
    [alert addAction:okAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    return NO;
}



- (IBAction)confirmChangeBtnClick:(UIButton *)sender {
    
    NSMutableString *cmdStr = [NSMutableString stringWithString:@"FB0F10"];
    
    for (int i = 0; i < _rangeArray.count; i++) {
        [cmdStr appendString: [self textToHexstring:_rangeArray[i]]];
    }
    [cmdStr appendString: @"BF"];
    
//    NSLog(@"cmd string  %@", cmdStr);
    
    [self.delegate getRangCMDString:cmdStr];
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (NSString *) textToHexstring:(NSString *) text {
    

    NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%04lx", (long)[text integerValue]]];
    
//    NSLog(@" ---before %@", hexString);
    
    NSString *subPrefix = [hexString substringToIndex:2];
    NSString *subSuffix = [hexString substringFromIndex:2];
    
    hexString = [subSuffix stringByAppendingString:subPrefix];
//
//    NSLog(@" ---after %@", hexString);
    
    return hexString;
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
