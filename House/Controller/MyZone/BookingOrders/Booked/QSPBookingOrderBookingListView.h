//
//  QSPBookingOrderBookingListView.h
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeEnumHeader.h"

@interface QSPBookingOrderBookingListView : UIView

@property (nonatomic, strong) UIViewController *parentViewController;

- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType;

@end
