//
//  QSYMyzoneStatisticsReturnData.m
//  House
//
//  Created by ysmeng on 15/4/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMyzoneStatisticsReturnData.h"
#import "QSYMyzoneStatisticsRenantModel.h"
#import "QSYMyzoneStatisticsOwnerModel.h"

@implementation QSYMyzoneStatisticsReturnData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerData" withMapping:[QSYMyzoneStatisticsHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSYMyzoneStatisticsHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"buyer" toKeyPath:@"renantData" withMapping:[QSYMyzoneStatisticsRenantModel objectMapping]]];
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"saler" toKeyPath:@"ownerData" withMapping:[QSYMyzoneStatisticsOwnerModel objectMapping]]];
    
    return shared_mapping;
    
}

@end