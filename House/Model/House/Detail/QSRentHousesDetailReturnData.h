//
//  QSRentHousesDetailReturnData.h
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSRentHouseDetailDataModel.h"

@interface QSRentHousesDetailReturnData : QSHeaderDataModel

/*!
 *  @author wangshupeng, 15-03-11 11:03:22
 *
 *  @brief  出租房详情信息返回数据
 *
 *  @since 1.0.0
 */
@property (nonatomic,retain) QSRentHouseDetailDataModel *detailInfo;//!<详情数据模型


@end
