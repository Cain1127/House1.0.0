//
//  QSYHistoryListRentHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryLisBaseHouseDataModel.h"

@class QSRentHouseInfoDataModel;
@interface QSYHistoryListRentHouseDataModel : QSYHistoryLisBaseHouseDataModel

@property (nonatomic,retain) QSRentHouseInfoDataModel *houseInfo;//!<房源信息

@end
