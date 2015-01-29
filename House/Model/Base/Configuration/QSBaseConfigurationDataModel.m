//
//  QSBaseConfigurationDataModel.m
//  House
//
//  Created by ysmeng on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseConfigurationDataModel.h"

@implementation QSBaseConfigurationDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    @"key",
                                                    @"val"
                                                    ]];
    
    return shared_mapping;
    
}

@end
