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

/**
 *  @author yangshengmeng, 15-01-26 14:01:39
 *
 *  @brief  基础配置信息请求时返回的参数
 *
 *  @since  1.0.0
 */
- (NSDictionary *)getBaseConfigurationRequestParams
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.conf forKey:@"conf"];
    return [NSDictionary dictionaryWithDictionary:params];

}

@end
