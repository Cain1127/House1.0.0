//
//  QSYHistoryLisBaseHouseDataModel.m
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryLisBaseHouseDataModel.h"

@implementation QSYHistoryLisBaseHouseDataModel

+(RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"view_id",
                                                    @"view_time",
                                                    @"view_type",
                                                    @"view_client"]];
    
    return shared_mapping;
    
}

@end
