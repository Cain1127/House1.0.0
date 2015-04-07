//
//  QSBaseHouseInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseHouseInfoDataModel.h"

@implementation QSBaseHouseInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"introduce",
                                                    @"title",
                                                    @"title_second",
                                                    @"address",
                                                    @"floor_num",
                                                    @"property_type",
                                                    @"used_year",
                                                    @"installation",
                                                    @"features",
                                                    @"view_count",
                                                    @"provinceid",
                                                    @"cityid",
                                                    @"areaid",
                                                    @"street",
                                                    @"commend",
                                                    @"attach_file",
                                                    @"attach_thumb",
                                                    @"favorite_count",
                                                    @"attention_count",
                                                    @"status",
                                                    @"update_time"
                                                    ]];
    
    return shared_mapping;
    
}

@end
