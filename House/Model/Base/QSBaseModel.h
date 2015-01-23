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
 *  @author yangshengmeng, 15-01-21 21:01:03
 *
 *  @brief  数据存入CoreData必须实现的方法协议
 *
 *  @since  1.0.0
 */
@class QSBaseModel;
@protocol QSBaseModelProtocol <NSObject>

@required
///将数据存入CoreData
- (BOOL)saveModelDataIntoCoreData;
///将数据从CoreData中取出来
+ (QSBaseModel *)getModelDataFromCoreData;

@end

/**
 *  @author yangshengmeng, 15-01-21 14:01:24
 *
 *  @brief  所有数据模型的父模型，只是导入协议头
 *
 *  @since  1.0.0
 */
@interface QSBaseModel : NSObject<QSDataMappingProtocol,QSBaseModelProtocol>

@end
