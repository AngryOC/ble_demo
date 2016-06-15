//
//  pickViewController.m
//  pickviewDelegate
//
//  Created by 刘凯 on 15/7/24.
//  Copyright (c) 2015年 刘凯. All rights reserved.
//

#import "pickViewController.h"

@interface pickViewController ()

@end

@implementation pickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arry = [[NSMutableArray alloc] initWithObjects:@"查询实时数据",@"查询报警设置",@"允许报警",@"禁止报警",@"解除报警",@"查询历史",@"清除历史",@"发送汽车行驶状态",@"发送汽车停止状态",@"查询MCU地址", nil];
    _cmdArry = [[NSMutableArray alloc] initWithObjects:@"FB0201FFBF",@"FB0202FFBF",@"FB022201BF",@"FB022200BF",@"FB022011BF",@"FB030355AABF",@"FB0313AA55BF",@"FB023001BF",@"FB023000BF",@"FB0204FFBF", nil];
    //self.view.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
   // [_pickView selectRow:0 inComponent:0 animated:YES];
    _chooseText = _cmdArry[0];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_arry count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_arry objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _chooseText = [NSString stringWithFormat:@"%@",[_cmdArry objectAtIndex:row]];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    return 30.0f;
}


//取消按钮
- (IBAction)cancel:(id)sender{
    [_delegate removeOverView];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//确定按钮
- (IBAction)submit:(id)sender{
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(getTextStr:)]) {
        
        [_delegate getTextStr:_chooseText];
        [_delegate removeOverView];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
