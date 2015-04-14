//
//  QSPOrderCancelReasonViewController.h
//  House
//
//  Created by CoolTea on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSPOrderCancelReasonViewController : QSTurnBackViewController

@property ( nonatomic , strong ) NSString *orderID;         //!<订单ID

@property ( nonatomic, assign ) FILTER_MAIN_TYPE houseType; //!<跳转推荐房源需传对应的房源类型

@end
