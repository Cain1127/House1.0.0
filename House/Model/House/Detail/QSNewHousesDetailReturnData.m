//
//  QSNewHousesDetailReturnData.m
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNewHousesDetailReturnData.h"

@implementation QSNewHousesDetailReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"detailInfo" withMapping:[QSNewHouseDetailDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
