//
//  QSAdvertReturnData.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAdvertReturnData.h"

/**
 *  @author yangshengmeng, 15-01-21 09:01:42
 *
 *  @brief  广告页返回的外层信息
 *
 *  @since  1.0.0
 */
@implementation QSAdvertReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"advertHeaderData" withMapping:[QSAdvertHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

/**
 *  @author yangshengmeng, 15-01-21 09:01:00
 *
 *  @brief  广告页中msg层信息
 *
 *  @since  1.0.0
 */
@implementation QSAdvertHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"time"]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"advertsArray" withMapping:[QSAdvertInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end