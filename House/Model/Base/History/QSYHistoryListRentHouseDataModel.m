//
//  QSYHistoryListRentHouseDataModel.m
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryListRentHouseDataModel.h"
#import "QSRentHouseInfoDataModel.h"

@implementation QSYHistoryListRentHouseDataModel

+(RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rent" toKeyPath:@"houseInfo" withMapping:[QSRentHouseInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
