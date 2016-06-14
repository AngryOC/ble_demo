//
//  pickViewController.h
//  pickviewDelegate
//
//  Created by 刘凯 on 15/7/24.
//  Copyright (c) 2015年 刘凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pickViewDelegate <NSObject>

- (void) getTextStr:(NSString *)text;
- (void) removeOverView;

@end

@interface pickViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, unsafe_unretained) id<pickViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIPickerView *pickView;
@property (nonatomic, strong) NSMutableArray *arry;
@property (nonatomic, strong) NSMutableArray *cmdArry;
@property (nonatomic, strong) NSString *chooseText;
@property (nonatomic, weak) IBOutlet UIView *TEST;

@end
