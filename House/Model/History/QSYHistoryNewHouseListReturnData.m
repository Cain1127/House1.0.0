//
//  QSYHistoryNewHouseListReturnData.m
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryNewHouseListReturnData.h"
#import "QSYHistoryListNewHouseDataModel.h"

@implementation QSYHistoryNewHouseListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerData" withMapping:[QSYHistoryNewHouseListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSYHistoryNewHouseListHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"dataList" withMapping:[QSYHistoryListNewHouseDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end