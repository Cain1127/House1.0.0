//
//  QSRentHouseDetailDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRentHouseDetailDataModel.h"
#import "QSHouseCommentDataModel.h"
#import "QSHousePriceChangesDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSWRentHouseInfoDataModel.h"
#import "QSPhotoDataModel.h"

@implementation QSRentHouseDetailDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///房子信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house" toKeyPath:@"house" withMapping:[QSWRentHouseInfoDataModel objectMapping]]];
   
    ///业主
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[QSUserSimpleDataModel objectMapping]]];
    
   ///价格变动
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"price_changes" toKeyPath:@"price_changes" withMapping:[QSHousePriceChangesDataModel objectMapping]]];
    
    ///评论
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comment" toKeyPath:@"comment" withMapping:[QSHouseCommentDataModel objectMapping]]];
    
    ///图片
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rentHouse_photo" toKeyPath:@"rentHouse_photo" withMapping:[QSPhotoDataModel objectMapping]]];
    
    ///扩展信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"expand_msg" toKeyPath:@"expandInfo" withMapping:[QSRentHouseDetailExpandInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}


@end

@implementation QSRentHouseDetailExpandInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    [shared_mapping addAttributeMappingsFromArray:@[@"total_common_num",
                                                    @"is_book",
                                                    @"is_store"]];
    
    return shared_mapping;
    
}

@end