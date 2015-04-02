//
//  QSYPostMessageSimpleModel.m
//  House
//
//  Created by ysmeng on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYPostMessageSimpleModel.h"
#import "QSUserSimpleDataModel.h"

@implementation QSYPostMessageSimpleModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"from_id",
                                                    @"to_id",
                                                    @"not_view",
                                                    @"content",
                                                    @"time"]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"fromUserInfo" withMapping:[QSUserSimpleDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
