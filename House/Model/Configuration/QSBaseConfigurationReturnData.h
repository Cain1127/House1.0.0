//
//  QSBaseConfigurationReturnData.h
//  House
//
//  Created by ysmeng on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"
#import "QSBaseConfigurationDataModel.h"

/**
 *  @author yangshengmeng, 15-01-26 10:01:56
 *
 *  @brief  具体配置信息请求时返回的
 *
 *  @since  1.0.0
 */
@class QSBaseConfigurationHeaderData;
@interface QSBaseConfigurationReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSBaseConfigurationHeaderData *baseConfigurationHeaderData;//!<配置的msg头信息

@end

/**
 *  @author yangshengmeng, 15-01-26 10:01:58
 *
 *  @brief  每一个配置信息请求
 *
 *  @since  1.0.0
 */
@interface QSBaseConfigurationHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSArray *baseConfigurationList;//!<配置信息数组

@end