//
//  QSPBuyerTransactionOrderListViewController.h
//  House
//
//  Created by CoolTea on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{
    
    mBuyerTransactionOrderListTypePending = 90001,       //!<待成交房列表
    mBuyerTransactionOrderListTypeCompleted,            //!<已成交房
    mBuyerTransactionOrderListTypeCancel                //!<已取消
    
}MYZONE_BUYER_TRANSACTION_ORDER_LIST_TYPE;         //!<成交订单列表

@interface QSPBuyerTransactionOrderListViewController : QSTurnBackViewController

- (void)setSelectedType:(MYZONE_BUYER_TRANSACTION_ORDER_LIST_TYPE)type;

- (void)reloadCurrentShowList;

@end
