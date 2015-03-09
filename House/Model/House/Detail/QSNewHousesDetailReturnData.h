//
//  QSNewHousesDetailReturnData.h
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSNewHouseDetailDataModel.h"

/**
 *  @author yangshengmeng, 15-03-09 11:03:38
 *
 *  @brief  新房详情信息返回的数据
 *
 *  @since  1.0.0
 */
@interface QSNewHousesDetailReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSNewHouseDetailDataModel *detailInfo;//!<详情数据模型

@end
