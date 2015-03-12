//
//  QSPBookingOrdersViewController.h
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{
    
    mOrderListTypeBooked = 90001,       //!<待看房列表
    mOrderListTypeCompleted,            //!<已看房
    mOrderListTypeCancel                //!<以取消
    
}MYZONE_BOOKED_ORDER_LIST_TYPE;         //!<预约订单列表

@interface QSPBookingOrdersListsViewController : QSTurnBackViewController

- (void)setSelectedType:(MYZONE_BOOKED_ORDER_LIST_TYPE)type;

@end
