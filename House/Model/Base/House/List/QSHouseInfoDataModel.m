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
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"name",
                                                    @"tel",
                                                    @"content",
                                                    @"village_id",
                                                    @"village_name",
                                                    @"building_structure",
                                                    @"floor_which",
                                                    @"house_face",
                                                    @"decoration_type",
                                                    @"house_area",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"cycle",
                                                    @"time_interval_start",
                                                    @"time_interval_end",
                                                    @"entrust",
                                                    @"entrust_company",
                                                    @"video_url",
                                                    @"negotiated",
                                                    @"reservation_num",
                                                    @"house_no",
                                                    @"building_year",
                                                    @"house_price",
                                                    @"house_nature",
                                                    @"elevator"]];
        
    return shared_mapping;
    
}

@end
