//
//  QSSecondHandHouseListReturnData.h
//  House
//
//  Created by ysmeng on 15/1/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"
#import "QSHouseInfoDataModel.h"

/**
 *  @author yangshengmeng, 15-02-05 18:02:38
 *
 *  @brief  二手房列表请求返回的数据
 *
 *  @since  1.0.0
 */
@class QSSecondHandHouseHeaderData;
@interface QSSecondHandHouseListReturnData : QSHeaderDataModel

///二手房返回数据的msg信息模型
@property (nonatomic,retain) QSSecondHandHouseHeaderData *secondHandHouseHeaderData;

@end

/**
 *  @author yangshengmeng, 15-02-05 18:02:49
 *
 *  @brief  二手房列表返回的msg信息
 *
 *  @since  1.0.0
 */
@interface QSSecondHandHouseHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSArray *houseList;        //!<房子信息数组
@property (nonatomic,retain) NSArray *referrals_list;   //!<推荐房源数组：搜索时使用

@end