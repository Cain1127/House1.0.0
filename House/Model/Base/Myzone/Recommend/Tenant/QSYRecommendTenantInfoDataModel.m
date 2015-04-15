//
//  QSYRecommendTenantInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRecommendTenantInfoDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSYAskRentAndBuyDataModel.h"

@implementation QSYRecommendTenantInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"buyer",
                                                    @"saler",
                                                    @"souce_id",
                                                    @"source_ask_for_id",
                                                    @"status",
                                                    @"connection_type"]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"buyer_msg" toKeyPath:@"buyer_msg" withMapping:[QSUserSimpleDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"need_msg" toKeyPath:@"need_msg" withMapping:[QSYAskRentAndBuyDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
