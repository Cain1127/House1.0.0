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
    
    ///非继承
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
                                                    @"introduce",
                                                    @"content",
                                                    
                                                    @"floor_num",
                                                    @"floor_which",
                                                    @"house_face",
                                                    @"decoration_type",
                                                    @"used_year",
                                                    @"installation",
                                                    @"features",
                                                    
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"house_area",
                                                    @"elevator",
                                                    
                                                    @"rent_price",
                                                    @"payment",
                                                    @"rent_property",
                                                    @"lead_time",
                                                    @"cycle",
                                                    @"time_interval_start",
                                                    @"time_interval_end",
                                                    
                                                    @"name",
                                                    @"tel",
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
                                                    
                                                    @"status",
                                                    @"create_time",
                                                    @"house_status",
                                                    @"fee",
                                                    @"negotiated",
                                                    @"video_url",
                                                    @"reservation_num",
                                                    @"property_type",
                                                    @"attention_count",
                                                    @"favorite_count",
                                                    @"tj_condition",
                                                    @"tj_environment",
                                                    
                                                    @"coordinate_x",
                                                    @"coordinate_y",
                                                    @"book_num",
                                                    @"tj_look_house_num",
                                                    @"tj_wait_look_house_people",
                                                    @"price_avg",
                                                    @"building_structure",
                                                    @"is_store"]];
    
    return shared_mapping;
    
}


@end
