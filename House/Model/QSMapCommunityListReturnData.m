//
//  QSMapCommunityListReturnData.m
//  House
//
//  Created by ysmeng on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMapCommunityListReturnData.h"
#import "QSMapCommunityDataModel.h"

@implementation QSMapCommunityListReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"mapCommunityListHeaderData" withMapping:[QSMapCommunityListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSMapCommunityListHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"communityList" withMapping:[QSMapCommunityDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end