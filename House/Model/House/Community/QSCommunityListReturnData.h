//
//  QSCommunityListReturnData.h
//  House
//
//  Created by ysmeng on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

/**
 *  @author yangshengmeng, 15-02-27 17:02:23
 *
 *  @brief  小区或者新房返回的数据
 *
 *  @since  1.0.0
 */
@class QSCommunityListHeaderData;
@interface QSCommunityListReturnData : QSHeaderDataModel

///小区、新房返回数据的msg信息模型
@property (nonatomic,retain) QSCommunityListHeaderData *communityListHeaderData;

@end

/**
 *  @author yangshengmeng, 15-02-27 17:02:37
 *
 *  @brief  小区或者新房msg数据
 *
 *  @since  1.0.0
 */
@interface QSCommunityListHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSArray *communityList;    //!<列表数组
@property (nonatomic,retain) NSArray *referrals_list;   //!<推荐房源数组：搜索时使用

@end