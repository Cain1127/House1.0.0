//
//  QSCityInfoReturnData.m
//  House
//
//  Created by ysmeng on 15/2/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCityInfoReturnData.h"

@implementation QSCityInfoReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    dispatch_once(&pred, ^{
        
        ///在超类的mapping规则之上添加子类mapping
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"cityInfoHeaderData" withMapping:[QSCityInfoHeaderData objectMapping]]];
        
    });
    
    return shared_mapping;
    
}

@end

@implementation QSCityInfoHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    dispatch_once(&pred, ^{
        
        ///在超类的mapping规则之上添加子类mapping
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"provinceList" withMapping:[QSProvinceDataModel objectMapping]]];
        
    });
    
    return shared_mapping;
    
}

@end

@implementation QSProvinceDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    static dispatch_once_t pred = 0;
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    dispatch_once(&pred, ^{
        
        ///在超类的mapping规则之上添加子类mapping
        [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"children" toKeyPath:@"cityList" withMapping:[QSBaseConfigurationDataModel objectMapping]]];
        
    });
    
    return shared_mapping;
    
}

@end