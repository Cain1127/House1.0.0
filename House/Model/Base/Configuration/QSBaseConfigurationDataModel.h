//
//  QSBaseConfigurationDataModel.h
//  House
//
//  Created by ysmeng on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-01-26 10:01:47
 *
 *  @brief  具体的配置信息数据模型
 *
 *  @since  1.0.0
 */
@interface QSBaseConfigurationDataModel : QSBaseModel

@property (nonatomic,retain) NSString *key; //!<类型编码
@property (nonatomic,copy) NSString *val;   //!<每个类型的显示说明

@end
