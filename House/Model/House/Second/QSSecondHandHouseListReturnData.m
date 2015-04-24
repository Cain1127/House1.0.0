//
//  QSSecondHandHouseListReturnData.m
//  House
//
//  Created by ysmeng on 15/1/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSecondHandHouseListReturnData.h"

@implementation QSSecondHandHouseListReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"secondHandHouseHeaderData" withMapping:[QSSecondHandHouseHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSSecondHandHouseHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"houseList" withMapping:[QSHouseInfoDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"referrals_list" toKeyPath:@"referrals_list" withMapping:[QSHouseInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end