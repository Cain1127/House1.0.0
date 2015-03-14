//
//  QSOrderListReturnData.h
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"
#import "QSOrderListHouseInfoDataModel.h"
#import "QSOrderListOrderInfoDataModel.h"

@class QSOrderListHeaderData;
@interface QSOrderListReturnData : QSHeaderDataModel

@property (nonatomic,strong) QSOrderListHeaderData *orderListHeaderData;    //!<配置的msg头信息

@end

@interface QSOrderListHeaderData : QSMSGBaseDataModel

@property (nonatomic,strong) NSArray *orderList;        //!<订单列表数组

@end

@interface QSOrderListItemData : QSMSGBaseDataModel

@property (nonatomic,strong) QSOrderListHouseInfoDataModel *houseData;
@property (nonatomic,strong) NSArray *orderInfoList;    //!<订单列表数组

@end
