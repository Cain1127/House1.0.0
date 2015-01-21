//
//  QSAdvertReturnData.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"
#import "QSAdvertInfoDataModel.h"

/**
 *  @author yangshengmeng, 15-01-21 09:01:42
 *
 *  @brief  广告页返回的外层信息
 *
 *  @since  1.0.0
 */
@class QSAdvertHeaderData;
@interface QSAdvertReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSAdvertHeaderData *advertHeaderData;//!<广告页头信息

@end

/**
 *  @author yangshengmeng, 15-01-21 09:01:00
 *
 *  @brief  广告页中msg层信息
 *
 *  @since  1.0.0
 */
@interface QSAdvertHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSNumber *time;        //!<总的广告时间:等于所有广告显示时间加和
@property (nonatomic,retain) NSArray *advertsArray; //!<所有广告页信息模型数组

@end