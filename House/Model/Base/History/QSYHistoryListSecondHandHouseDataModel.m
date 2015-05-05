//
//  QSYHistoryListSecondHandHouseDataModel.m
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryListSecondHandHouseDataModel.h"
#import "QSHouseInfoDataModel.h"

@implementation QSYHistoryListSecondHandHouseDataModel

+(RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"apartment" toKeyPath:@"houseInfo" withMapping:[QSHouseInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
