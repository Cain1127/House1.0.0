//
//  QSPOrderDetailBookedViewController.h
//  House
//
//  Created by CoolTea on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"
#import "QSOrderListReturnData.h"

typedef enum
{
    
    mOrderWithUserTypeAppointment = 8001,       //!<预约订单类型
    mOrderWithUserTypeTransaction,              //!<成交订单类型
    
}MYZONE_ORDER_WITH_USER_TYPE;                   //!<订单详情类型

@interface QSPOrderDetailBookedViewController : QSTurnBackViewController

@property ( nonatomic , strong ) QSOrderListItemData *orderListItemData;

@property ( nonatomic , assign ) NSInteger  selectedIndex;

@property ( nonatomic , strong ) NSString *orderID;

@property ( nonatomic , assign ) MYZONE_ORDER_WITH_USER_TYPE orderType;

@end
