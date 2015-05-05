//
//  QSYHistoryListNewHouseDataModel.m
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryListNewHouseDataModel.h"
#import "QSNewHouseInfoDataModel.h"

@implementation QSYHistoryListNewHouseDataModel

+(RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"new_house" toKeyPath:@"houseInfo" withMapping:[QSNewHouseInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
