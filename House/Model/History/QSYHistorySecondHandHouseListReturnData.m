//
//  QSYHistorySecondHandHouseListReturnData.m
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistorySecondHandHouseListReturnData.h"
#import "QSYHistoryListSecondHandHouseDataModel.h"

@implementation QSYHistorySecondHandHouseListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerData" withMapping:[QSYHistorySecondHandHouseListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSYHistorySecondHandHouseListHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"dataList" withMapping:[QSYHistoryListSecondHandHouseDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end