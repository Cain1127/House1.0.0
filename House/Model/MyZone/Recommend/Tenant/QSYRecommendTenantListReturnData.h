//
//  QSYRecommendTenantListReturnData.h
//  House
//
//  Created by ysmeng on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

@class QSYRecommendTenantListHeaderData;
@interface QSYRecommendTenantListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSYRecommendTenantListHeaderData *headerData;  //!<头信息

@end

@interface QSYRecommendTenantListHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSMutableArray *dataList;                      //!<数据集

@end