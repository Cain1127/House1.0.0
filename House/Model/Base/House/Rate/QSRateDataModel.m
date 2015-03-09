//
//  QSRateDataModel.m
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRateDataModel.h"

@implementation QSRateDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"base_rate",
                                                    @"first_rate",
                                                    @"procedures_fee",
                                                    @"loan_year"]];
    
    return shared_mapping;
    
}

@end
