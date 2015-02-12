//
//  QSHouseInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/2/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseInfoDataModel.h"

@implementation QSHouseInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"name",
                                                    @"tel",
                                                    @"title",
                                                    @"title_second",
                                                    @"address",
                                                    @"village_id",
                                                    @"village_name",
                                                    @"content",
                                                    @"introduce",
                                                    @"floor_num",
                                                    @"building_year",
                                                    @"house_price",
                                                    @"house_nature",
                                                    @"house_face",
                                                    @"decoration_type",
                                                    @"building_structure",
                                                    @"used_year",
                                                    @"installation",
                                                    @"features",
                                                    @"house_area",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"elevator",
                                                    @"cycle",
                                                    @"time_interval_start",
                                                    @"time_interval_end",
                                                    @"entrust",
                                                    @"entrust_company",
                                                    @"view_count",
                                                    @"provinceid",
                                                    @"cityid",
                                                    @"areaid",
                                                    @"street",
                                                    @"commend",
                                                    @"attach_file",
                                                    @"attach_thumb",
                                                    @"status"]];
        
    return shared_mapping;
    
}

@end
