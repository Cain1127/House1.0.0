//
//  QSSecondHousesDetailReturnData.h
//  House
//
//  Created by 王树朋 on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSSecondHouseDetailDataModel.h"

/*!
 *  @author wangshupeng, 15-03-12 09:03:24
 *
 *  @brief  二手房详情返回数据
 *
 *  @since 1.0.0
 */
@interface QSSecondHousesDetailReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSSecondHouseDetailDataModel *detailInfo;  //!<详情数据模型

@end
