//
//  QSNewHouseInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNewHouseInfoDataModel.h"

@implementation QSNewHouseInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"loupan_id",
                                                    @"title",
                                                    @"provinceid",
                                                    @"cityid",
                                                    @"areaid",
                                                    @"street",
                                                    @"address",
                                                    @"property_type",
                                                    @"building_structure",
                                                    @"features",
                                                    @"used_year",
                                                    @"decoration_type",
                                                    @"loupan_building_id",
                                                    @"loupan_periods",
                                                    @"price_avg",
                                                    @"min_house_area",
                                                    @"max_house_area",
                                                    @"attach_file",
                                                    @"attach_thumb",
                                                    @"activity_name"]];
    
    return shared_mapping;
    
}

@end
