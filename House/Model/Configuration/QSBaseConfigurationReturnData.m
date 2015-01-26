//
//  QSBaseConfigurationReturnData.m
//  House
//
//  Created by ysmeng on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseConfigurationReturnData.h"

@implementation QSBaseConfigurationReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"baseConfigurationHeaderData" withMapping:[QSBaseConfigurationHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSBaseConfigurationHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"baseConfigurationList" withMapping:[QSBaseConfigurationDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end