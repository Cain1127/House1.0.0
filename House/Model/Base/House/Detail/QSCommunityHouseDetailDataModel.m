//
//  QSCommunityHouseDetailDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommunityHouseDetailDataModel.h"
#import "QSCommunityDataModel.h"
#import "QSPhotoDataModel.h"

@implementation QSCommunityHouseDetailDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///房子信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"village" toKeyPath:@"village" withMapping:[QSCommunityDataModel objectMapping]]];
    
    ///业主
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[QSCommunityDataModel objectMapping]]];
    
    
    ///图片
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"village_photo" toKeyPath:@"village_photo" withMapping:[QSPhotoDataModel objectMapping]]];
    
    /// 推荐
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house_commend" toKeyPath:@"house_commend" withMapping:[QSCommunityDataModel objectMapping]]];
    
    return shared_mapping;
    
}


@end
