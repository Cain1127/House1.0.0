//
//  QSYHistoryRentHouseListReturnData.h
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

@class QSYHistoryRentHouseListHeaderData;
@interface QSYHistoryRentHouseListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSYHistoryRentHouseListHeaderData *headerData;

@end

@interface QSYHistoryRentHouseListHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSMutableArray *dataList;

@end