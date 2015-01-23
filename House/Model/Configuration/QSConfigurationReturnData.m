//
//  QSConfigurationReturnData.m
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSConfigurationReturnData.h"

@implementation QSConfigurationReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    dispatch_once(&pred, ^{
        
        ///在超类的mapping规则之上添加子类mapping
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"configurationHeaderData" withMapping:[QSConfigurationHeaderData objectMapping]]];
        
    });
    
    return shared_mapping;
    
}

@end

@implementation QSConfigurationHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    dispatch_once(&pred, ^{
        
        ///在超类的mapping规则之上添加子类mapping
        [shared_mapping addAttributeMappingsFromArray:@[@"version",@"t",@"t_id"]];
        
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"configurationList" withMapping:[QSConfigurationDataModel objectMapping]]];
        
    });
    
    return shared_mapping;
    
}

@end