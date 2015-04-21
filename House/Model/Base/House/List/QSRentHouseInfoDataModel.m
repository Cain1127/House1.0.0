//
//  QSRentHouseInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRentHouseInfoDataModel.h"
#import "QSReleaseRentHouseDataModel.h"

@implementation QSRentHouseInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"name",
                                                    @"tel",
                                                    @"village_id",
                                                    @"village_name",
                                                    @"floor_which",
                                                    
                                                    @"house_face",
                                                    @"decoration_type",
                                                    @"house_area",
                                                    @"elevator",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"fee",
                                                    @"cycle",
                                                    @"time_interval_start",
                                                    @"time_interval_end",
                                                    
                                                    @"entrust",
                                                    @"entrust_company",
                                                    @"video_url",
                                                    @"negotiated",
                                                    @"reservation_num",
                                                    @"house_no",
                                                    @"house_status",
                                                    
                                                    @"rent_price",
                                                    @"payment",
                                                    @"rent_property",
                                                    @"lead_time"
                                                    ]];
    
    return shared_mapping;
    
}

@end
