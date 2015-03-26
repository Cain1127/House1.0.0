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
    
    mBuyerBookedOrderListTypeBooked = 90001,       //!<待看房列表
    mBuyerBookedOrderListTypeCompleted,            //!<已看房
    mBuyerBookedOrderListTypeCancel                //!<已取消
    
}MYZONE_BUYER_BOOKED_ORDER_LIST_TYPE;         //!<预约订单列表

@interface QSPBuyerBookedOrdersListsViewController : QSTurnBackViewController

- (void)setSelectedType:(MYZONE_BUYER_BOOKED_ORDER_LIST_TYPE)type;

@end
