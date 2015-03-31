//
//  QSPOrderDetailBookedViewController.h
//  House
//
//  Created by CoolTea on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"
#import "QSOrderListReturnData.h"

@interface QSPOrderDetailBookedViewController : QSTurnBackViewController

@property ( nonatomic , strong ) QSOrderListItemData *orderListItemData;

@property ( nonatomic , assign ) NSInteger  selectedIndex;

@end
