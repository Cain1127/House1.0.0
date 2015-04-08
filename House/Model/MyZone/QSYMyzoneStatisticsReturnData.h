//
//  QSYMyzoneStatisticsReturnData.h
//  House
//
//  Created by ysmeng on 15/4/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

@class QSYMyzoneStatisticsRenantModel;
@class QSYMyzoneStatisticsOwnerModel;
@class QSYMyzoneStatisticsHeaderData;
@interface QSYMyzoneStatisticsReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSYMyzoneStatisticsHeaderData *headerData;//!<头信息

@end

@interface QSYMyzoneStatisticsHeaderData : QSBaseModel

@property (nonatomic,retain) QSYMyzoneStatisticsRenantModel *renantData; //!<房客统计数据
@property (nonatomic,retain) QSYMyzoneStatisticsOwnerModel *ownerData;   //!<业主统计数据

@end