//
//  QSConfigurationDataModel.m
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSConfigurationDataModel.h"

@implementation QSConfigurationDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    @"conf",
                                                    @"c_v"
                                                    ]];
    
    return shared_mapping;
    
}

@end
