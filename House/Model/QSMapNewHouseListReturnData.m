//
//  QSMapNewHouseListReturnData.m
//  House
//
//  Created by 王树朋 on 15/5/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMapNewHouseListReturnData.h"
#import "QSMapNewHouseDataModel.h"

@implementation QSMapNewHouseListReturnData
///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"mapNewHouseListHeaderData" withMapping:[QSMapNewHouseListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSMapNewHouseListHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"records" withMapping:[QSMapNewHouseDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
