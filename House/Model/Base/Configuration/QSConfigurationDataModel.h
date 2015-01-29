//
//  QSConfigurationDataModel.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-01-26 14:01:02
 *
 *  @brief  每个配置信息的简明版本信息数据模型
 *
 *  @since  1.0.0
 */
@interface QSConfigurationDataModel : QSBaseModel

@property (nonatomic,copy) NSString *conf;  //!<配置根目录
@property (nonatomic,copy) NSString *c_v;   //!<配置版本

/**
 *  @author yangshengmeng, 15-01-26 14:01:39
 *
 *  @brief  基础配置信息请求时返回的参数
 *
 *  @since  1.0.0
 */
- (NSDictionary *)getBaseConfigurationRequestParams;

@end
