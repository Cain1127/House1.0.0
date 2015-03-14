//
//  QSOrderListOrderInfoDataModel.m
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListOrderInfoDataModel.h"

@implementation QSOrderListOrderInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
    // RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"order_type",
                                                    @"add_time",
                                                    @"order_status",
                                                    @"status",
                                                    @"buyer_name",
                                                    @"buyer_phone"
                                                    ]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"buyer_msg" toKeyPath:@"buyer_msg" withMapping:[QSOrderListOrderInfoPersonInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSOrderListOrderInfoPersonInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
    // RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"username",
                                                    @"mobile"
                                                    ]];
    
    return shared_mapping;
    
}

@end
