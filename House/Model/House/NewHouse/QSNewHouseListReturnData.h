//
//  QSNewHouseListReturnData.h
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

/**
 *  @author yangshengmeng, 15-03-01 15:03:27
 *
 *  @brief  新房信息列表返回的第一层数据
 *
 *  @since  1.0.0
 */
@class QSNewHouseListHeaderData;
@interface QSNewHouseListReturnData : QSHeaderDataModel

///小区、新房返回数据的msg信息模型
@property (nonatomic,retain) QSNewHouseListHeaderData *headerData;

@end

/**
 *  @author yangshengmeng, 15-03-01 15:03:55
 *
 *  @brief  新房列表msg数据
 *
 *  @since  1.0.0
 */
@interface QSNewHouseListHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSArray *houseList;        //!<新房数组
@property (nonatomic,retain) NSArray *referrals_list;   //!<推荐房源数组：搜索时使用

@end
