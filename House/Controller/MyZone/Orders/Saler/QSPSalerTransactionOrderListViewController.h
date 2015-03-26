//
//  QSPSalerTransactionOrderListViewController.h
//  House
//
//  Created by CoolTea on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{
    
    mSalerTransactionOrderListTypePending = 90001,       //!<待成交房列表
    mSalerTransactionOrderListTypeCompleted,            //!<已成交房
    mSalerTransactionOrderListTypeCancel                //!<已取消
    
}MYZONE_SALER_TRANSACTION_ORDER_LIST_TYPE;         //!<成交订单列表

@interface QSPSalerTransactionOrderListViewController : QSTurnBackViewController

- (void)setSelectedType:(MYZONE_SALER_TRANSACTION_ORDER_LIST_TYPE)type;

@end
