//
//  QSActivityDetailDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSActivityDetailDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSLoupanPhaseDataModel.h"
#import "QSUserBaseInfoDataModel.h"
#import "QSActivityDataModel.h"
#import "QSHouseTypeDataModel.h"

@implementation QSActivityDetailDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    
    ///活动信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupan_activity" toKeyPath:@"loupan_activity" withMapping:[QSActivityDataModel objectMapping]]];
    
    ///楼盘
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupan" toKeyPath:@"loupan" withMapping:[QSLoupanInfoDataModel objectMapping]]];
    
    ///业主
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[QSUserBaseInfoDataModel objectMapping]]];
    
    ///楼盘具体期的信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupan_building" toKeyPath:@"loupan_building" withMapping:[QSLoupanPhaseDataModel objectMapping]]];

    ///推荐户型信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupanHouse_commend" toKeyPath:@"loupanHouse_commend" withMapping:[QSHouseTypeDataModel objectMapping]]];


    return shared_mapping;
    
}


@end
