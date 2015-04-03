//
//  QSYContactInfoSimpleModel.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactInfoSimpleModel.h"
#import "QSUserSimpleDataModel.h"

@implementation QSYContactInfoSimpleModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"linkman_id",
                                                    @"is_import",
                                                    @"remark",
                                                    @"more_remark"]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"contactUserInfo" withMapping:[QSUserSimpleDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
