//
//  QSBaseModel.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSDataMappingManager.h"
#import "RestKit.h"

/**
 *  @author yangshengmeng, 15-01-21 14:01:24
 *
 *  @brief  所有数据模型的父模型，只是导入协议头
 *
 *  @since  1.0.0
 */
@interface QSBaseModel : NSObject<QSDataMappingProtocol>

@end
