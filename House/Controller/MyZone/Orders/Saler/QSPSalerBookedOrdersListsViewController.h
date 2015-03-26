//
//  QSPSalerBookedOrdersListsViewController.h
//  House
//
//  Created by CoolTea on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{
    
    mSalerBookedOrderListTypeBooked = 90001,       //!<待看房列表
    mSalerBookedOrderListTypeCompleted,            //!<已看房
    mSalerBookedOrderListTypeCancel                //!<已取消
    
}MYZONE_SALER_BOOKED_ORDER_LIST_TYPE;         //!<预约订单列表

@interface QSPSalerBookedOrdersListsViewController : QSTurnBackViewController

- (void)setSelectedType:(MYZONE_SALER_BOOKED_ORDER_LIST_TYPE)type;

@end
