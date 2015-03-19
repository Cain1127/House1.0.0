//
//  QSPCalendarView.h
//  House
//
//  Created by CoolTea on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSPCalendarView : UIView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint;

@property ( strong, nonatomic ) NSDate *selectedDate;

@end
