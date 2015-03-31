//
//  QSHouseTypeDetailDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseTypeDetailDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSLoupanPhaseDataModel.h"
#import "QSUserBaseInfoDataModel.h"
#import "QSHouseTypeDataModel.h"
#import "QSLoupanHouseListDataModel.h"
#import "QSLoupanHouseViewDataModel.h"

@implementation QSHouseTypeDetailDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    
    ///楼盘
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupan" toKeyPath:@"loupan" withMapping:[QSLoupanInfoDataModel objectMapping]]];
    
    ///业主
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[QSUserBaseInfoDataModel objectMapping]]];
    
    ///楼盘具体期的信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupan_building" toKeyPath:@"loupan_building" withMapping:[QSLoupanPhaseDataModel objectMapping]]];
    
    ///户型详情数组信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupanHouse_list" toKeyPath:@"loupanHouse_list" withMapping:[QSLoupanHouseListDataModel objectMapping]]];
    
    ///户型详情基本信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupanHouse_view" toKeyPath:@"loupanHouse_view" withMapping:[QSLoupanHouseViewDataModel objectMapping]]];
    
    return shared_mapping;
    
}


@end
