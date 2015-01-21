//
//  QSDataMappingManager.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;
/**
 *  @author yangshengmeng, 15-01-20 23:01:26
 *
 *  @brief  解析器使用的解析对应关系协议
 *
 *  @since  1.0.0
 */
@protocol QSDataMappingProtocol <NSObject>

@required
+ (RKObjectMapping *)objectMapping;//!<每个传给解析器的对象都必须实现mapping的方法

@end

/**
 *  @author yangshengmeng, 15-01-20 23:01:56
 *
 *  @brief  数据解析器，使用mapping的解析器进行解析
 *
 *  @since  1.0.0
 */
@class RKMappingResult; //!<mapping结果对象
@class RKMapping;       //!<mapping规则
@interface QSDataMappingManager : NSObject

/**
 *  @author             yangshengmeng, 15-01-20 23:01:48
 *
 *  @brief              根据给定的数据对象解析并返回，传进来的数据模型必须实现对应的协议方法
 *
 *  @param data         需要解析的数据
 *  @param mappingClass 解析完成后的数据存放的模型
 *
 *  @return             返回解析后的数据模型
 *
 *  @since              1.0.0
 */
+ (instancetype)analyzeDataWithData:(NSData *)data andMappingClass:(NSString *)mappingClass;

@end
