//
//  QSCommunityListReturnData.m
//  House
//
//  Created by ysmeng on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommunityListReturnData.h"
#import "QSCommunityDataModel.h"

@implementation QSCommunityListReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"communityListHeaderData" withMapping:[QSCommunityListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSCommunityListHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"communityList" withMapping:[QSCommunityDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end