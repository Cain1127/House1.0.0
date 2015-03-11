//
//  QSWRentHouseInfoDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWRentHouseInfoDataModel.h"

@implementation QSWRentHouseInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"house_no",
                                                    @"title",
                                                    @"title_second",
                                                    @"address",
                                                    @"village_id",
                                                    @"village_name",
                                                    @"content",
                                                    
                                                    @"floor_num",
                                                    @"floor_which",
                                                    @"house_face",
                                                    @"decoration",
                                                    @"decoration_type",
                                                    @"used_year",
                                                    @"installation",
                                                    @"rent_property",
                                                    @"lead_time",
                                                    
                                                    @"features",
                                                    
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"house_area",
                                                    @"elevator",
                                                    
                                                    @"rent_price",
                                                    @"entrust",
                                                    @"update_time",
                                                    @"attach_file",
                                                    @"attach_thumb",
                                                    @"status",
                                                    
                                                    @"view_count",
                                                    @"reservation_num",
                                                    @"tj_look_house_num",
                                                    @"tj_wait_look_house_people",
                                                    @"price_avg"
                                                    
                                                    ]];
    
    return shared_mapping;
    
}


@end
