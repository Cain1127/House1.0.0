//
//  QSRentHouseListReturnData.h
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

/**
 *  @author yangshengmeng, 15-03-01 15:03:49
 *
 *  @brief  出租房列表返回数据
 *
 *  @since  1.0.0
 */
@class QSRentHouseListHeaderData;
@interface QSRentHouseListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSRentHouseListHeaderData *headerData;//!<出租房列表的msg信息

@end

/**
 *  @author yangshengmeng, 15-03-01 15:03:22
 *
 *  @brief  出租房列表的msg数据
 *
 *  @since  1.0.0
 */
@interface QSRentHouseListHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSArray *rentHouseList;//!<出租房数组

@end