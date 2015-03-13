//
//  QSYHomeReturnData.m
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHomeReturnData.h"

@implementation QSYHomeReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerData" withMapping:[QSYHomeHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSYHomeHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    @"house_shi_0",
                                                    @"house_shi_1",
                                                    @"house_shi_2",
                                                    @"house_shi_3",
                                                    @"house_shi_4",
                                                    @"house_shi_5",
                                                    @"house_shi_other"
                                                    ]];
    
    return shared_mapping;
    
}

@end