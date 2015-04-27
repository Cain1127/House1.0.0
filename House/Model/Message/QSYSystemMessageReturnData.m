//
//  QSYSystemMessageReturnData.m
//  House
//
//  Created by ysmeng on 15/4/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSystemMessageReturnData.h"

@implementation QSYSystemMessageReturnData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerData" withMapping:[QSYSystemMessageHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSYSystemMessageHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
//    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"dataList" withMapping:[ objectMapping]]];
    
    return shared_mapping;
    
}

@end