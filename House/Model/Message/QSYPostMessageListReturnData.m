//
//  QSYPostMessageListReturnData.m
//  House
//
//  Created by ysmeng on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYPostMessageListReturnData.h"
#import "QSYPostMessageSimpleModel.h"

@implementation QSYPostMessageListReturnData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerData" withMapping:[QSYPostMessageListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSYPostMessageListHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"messageList" withMapping:[QSYPostMessageListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end