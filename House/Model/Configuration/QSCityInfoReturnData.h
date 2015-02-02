//
//  QSCityInfoReturnData.h
//  House
//
//  Created by ysmeng on 15/2/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"
#import "QSBaseConfigurationDataModel.h"

/**
 *  @author yangshengmeng, 15-02-02 12:02:29
 *
 *  @brief  城市信息请求，服务端返回的最外层数据
 *
 *  @since  1.0.0
 */
@class QSCityInfoHeaderData;
@interface QSCityInfoReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSCityInfoHeaderData *cityInfoHeaderData;//!<msg头信息

@end

/**
 *  @author yangshengmeng, 15-02-02 12:02:57
 *
 *  @brief  城市信息msg头信息
 *
 *  @since  1.0.0
 */
@interface QSCityInfoHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSArray *provinceList;//!<省列表信息

@end

/**
 *  @author yangshengmeng, 15-02-02 12:02:12
 *
 *  @brief  每一个省的数据模型
 *
 *  @since  1.0.0
 */
@interface QSProvinceDataModel : QSBaseConfigurationDataModel

@property (nonatomic,retain) NSArray *cityList;//!<城市列表信息

@end