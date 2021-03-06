//
//  QSYGuideHomeDataModel.m
//  House
//
//  Created by ysmeng on 15/5/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYGuideHomeDataModel.h"

@implementation QSYGuideHomeDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    @"house_num",
                                                    @"house_user_num"
                                                    ]];
    
    return shared_mapping;
    
}

@end
