//
//  QSPTimeHourPickerView.h
//  House
//
//  Created by CoolTea on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSPTimeHourPickerView;

@protocol QSPTimeHourPickerViewDelegate<NSObject>

- (void)changedWithData:(id)Data inView:(QSPTimeHourPickerView*)pickerView;

@end

@interface QSPTimeHourPickerView : UIView

+ (instancetype)getTimeHourPickerView;

@property (nonatomic,strong) id<QSPTimeHourPickerViewDelegate> delegate;

- (void)showTimeHourPickerView;

- (void)hideTimeHourPickerView;

- (void)updateData:(id)data;

@end
