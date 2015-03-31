//
//  QSYLoadImageReturnData.m
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYLoadImageReturnData.h"

@implementation QSYLoadImageReturnData

+ (RKObjectMapping *)objectMapping
{

    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"imageModel" withMapping:[QSYLoadImageHeaderData objectMapping]]];
    
    return shared_mapping;

}

@end

@implementation QSYLoadImageHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromDictionary:@{@"attach_file" : @"smallImageURl",
                                                         @"attach_thumb" : @"originalImageURl"}];
    
    return shared_mapping;
    
}

@end