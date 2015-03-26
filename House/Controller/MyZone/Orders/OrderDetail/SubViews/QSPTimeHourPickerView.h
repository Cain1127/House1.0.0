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

- (void)changedWithStartHour:(NSString*)startHourStr WithEndHour:(NSString*)endHourStr inView:(QSPTimeHourPickerView*)pickerView;

@end

@interface QSPTimeHourPickerView : UIView

+ (instancetype)getTimeHourPickerView;

@property (nonatomic,strong) id<QSPTimeHourPickerViewDelegate> delegate;

- (void)showTimeHourPickerView;

- (void)hideTimeHourPickerView;

//时间格式为： 11:00
- (void)updateDataFormHour:(NSString*)startHourStr toHour:(NSString*)endHourStr;

@end
