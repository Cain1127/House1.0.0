//
//  QSHouseTypeDetailReturnData.m
//  House
//
//  Created by 王树朋 on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseTypeDetailReturnData.h"
#import "QSHouseTypeDetailDataModel.h"

@implementation QSHouseTypeDetailReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"houseTypeDetailModel" withMapping:[QSHouseTypeDetailDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
