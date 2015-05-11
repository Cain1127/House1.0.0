//
//  QSYGuideFindHouseDataModel.m
//  House
//
//  Created by ysmeng on 15/5/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYGuideFindHouseDataModel.h"

@implementation QSYGuideFindHouseDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    @"house_num",
                                                    @"house_shi_0",
                                                    @"house_shi_1",
                                                    @"house_shi_2",
                                                    @"house_shi_3",
                                                    @"house_shi_4",
                                                    @"house_shi_5"
                                                    ]];
    
    return shared_mapping;
    
}

@end
