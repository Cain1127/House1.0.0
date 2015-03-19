//
//  QSCommunityHouseDetailDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommunityHouseDetailDataModel.h"
#import "QSWCommunityDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSHouseInfoDataModel.h"
#import "QSUserBaseInfoDataModel.h"

@implementation QSCommunityHouseDetailDataModel

#pragma mark - 初始化时同步初始化对象
///初始化时同步初始化对象
- (instancetype)init
{

    if (self = [super init]) {
        
        self.village = [[QSWCommunityDataModel alloc] init];
        self.user = [[QSUserBaseInfoDataModel alloc] init];
        self.is_syserver = @"0";
        
    }
    
    return self;

}

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///房子信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"village" toKeyPath:@"village" withMapping:[QSWCommunityDataModel objectMapping]]];
    
    ///业主
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[QSUserBaseInfoDataModel objectMapping]]];
    
    ///图片
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"village_photo" toKeyPath:@"village_photo" withMapping:[QSPhotoDataModel objectMapping]]];
    
    /// 推荐
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house_commend" toKeyPath:@"house_commend" withMapping:[QSHouseInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}


@end
