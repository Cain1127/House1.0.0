//
//  QSNewHouseDetailDataModel.m
//  House
//
//  Created by ysmeng on 15/3/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNewHouseDetailDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSLoupanPhaseDataModel.h"
#import "QSUserBaseInfoDataModel.h"
#import "QSRateDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSActivityDataModel.h"
#import "QSHouseTypeDataModel.h"

@implementation QSNewHouseDetailDataModel

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
    
    ///楼盘图集信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupanBuilding_photo" toKeyPath:@"loupanBuilding_photo" withMapping:[QSPhotoDataModel objectMapping]]];
    
    ///推荐户型信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupanHouse_commend" toKeyPath:@"loupanHouse_commend" withMapping:[QSHouseTypeDataModel objectMapping]]];
    
    ///所有户型信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupanHouse" toKeyPath:@"loupanHouse" withMapping:[QSHouseTypeDataModel objectMapping]]];
    
    ///活动信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupan_activity" toKeyPath:@"loupan_activity" withMapping:[QSActivityDataModel objectMapping]]];
    
    ///贷款时，利率相关信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loan" toKeyPath:@"loan" withMapping:[QSRateDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
