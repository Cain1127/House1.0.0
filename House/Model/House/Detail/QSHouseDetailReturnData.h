//
//  QSHouseDetailReturnData.h
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

/**
 *  @author yangshengmeng, 15-02-12 17:02:02
 *
 *  @brief  房子详情信息
 *
 *  @since  1.0.0
 */
@class QSHouseDetailHeaderData;
@interface QSHouseDetailReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSHouseDetailHeaderData *houseDetailHeaderData;//!<房子详情信息的msg头信息

@end