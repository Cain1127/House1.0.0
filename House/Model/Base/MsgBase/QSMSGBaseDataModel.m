//
//  QSMSGBaseDataModel.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMSGBaseDataModel.h"

@implementation QSMSGBaseDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    @"total_page",
                                                    @"total_num",
                                                    @"page_num",
                                                    @"before_page",
                                                    @"per_page",
                                                    @"next_page"
                                                    ]];
    
    return shared_mapping;
    
}

@end
