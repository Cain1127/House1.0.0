//
//  QSCommunityDataModel.m
//  House
//
//  Created by ysmeng on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommunityDataModel.h"

@implementation QSCommunityDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"catalog_id",
                                                    @"building_structure",
                                                    @"heating",
                                                    @"company_property",
                                                    @"company_developer",
                                                    @"fee",
                                                    @"water",
                                                    @"open_time",
                                                    @"area_covered",
                                                    @"areabuilt",
                                                    @"volume_rate",
                                                    @"green_rate",
                                                    @"licence",
                                                    @"parking_lot",
                                                    @"checkin_time",
                                                    @"households_num",
                                                    @"ladder",
                                                    @"ladder_family",
                                                    @"building_year",
                                                    @"traffic_bus",
                                                    @"traffic_subway",
                                                    @"reply_count",
                                                    @"reply_allow",
                                                    @"buildings_num",
                                                    @"price_avg",
                                                    @"tj_last_month_price_avg",
                                                    @"tj_one_shi_price_avg",
                                                    @"tj_two_shi_price_avg",
                                                    @"tj_three_shi_price_avg",
                                                    @"tj_four_shi_price_avg",
                                                    @"tj_five_shi_price_avg",
                                                    @"tj_secondHouse_num",
                                                    @"tj_rentHouse_num",
                                                    @"tj_condition",
                                                    @"tj_environment"]];
    
    return shared_mapping;
    
}

@end
