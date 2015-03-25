//
//  QSPTransactionOrderListViewController.h
//  House
//
//  Created by CoolTea on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{
    
    mTransactionOrderListTypePending = 90001,       //!<待成交房列表
    mTransactionOrderListTypeCompleted,            //!<已成交房
    mTransactionOrderListTypeCancel                //!<已取消
    
}MYZONE_TRANSACTION_ORDER_LIST_TYPE;         //!<成交订单列表

@interface QSPTransactionOrderListViewController : QSTurnBackViewController

- (void)setSelectedType:(MYZONE_TRANSACTION_ORDER_LIST_TYPE)type;

@end
