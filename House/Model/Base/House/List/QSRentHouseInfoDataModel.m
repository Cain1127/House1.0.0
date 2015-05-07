//
//  QSRentHouseInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRentHouseInfoDataModel.h"
#import "QSReleaseRentHouseDataModel.h"
#import "QSRentHouseDetailDataModel.h"
#import "QSWRentHouseInfoDataModel.h"
#import "QSUserSimpleDataModel.h"

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

/**
 *  @author yangshengmeng, 15-05-07 14:05:40
 *
 *  @brief  将列表的出租房数据模型，转换为出租房详情数据模型
 *
 *  @return 返回当前转换的详情数据模型
 *
 *  @since  1.0.0
 */
- (QSRentHouseDetailDataModel *)changeToRentHouseDetailModel
{

    QSRentHouseDetailDataModel *tempModel = [[QSRentHouseDetailDataModel alloc] init];
    tempModel.house = [[QSWRentHouseInfoDataModel alloc] init];
    tempModel.user = [[QSUserSimpleDataModel alloc] init];
    
    tempModel.house.is_syserver = self.is_syserver;
    
    ///房源信息
    tempModel.house.id_ = self.id_;
    tempModel.house.user_id = self.user_id;
    tempModel.house.house_no = self.house_no;
    tempModel.house.title = self.title;
    tempModel.house.title_second = self.title_second;
    
    tempModel.house.address = self.address;
    tempModel.house.village_id = self.village_id;
    tempModel.house.village_name = self.village_name;
    tempModel.house.introduce = self.introduce;
    
    tempModel.house.floor_num = self.floor_num;
    tempModel.house.floor_which = self.floor_which;
    tempModel.house.house_face = self.house_face;
    tempModel.house.decoration_type = self.decoration_type;
    tempModel.house.used_year = self.used_year;
    tempModel.house.installation = self.installation;
    tempModel.house.features = self.features;
    
    tempModel.house.house_shi = self.house_shi;
    tempModel.house.house_ting = self.house_ting;
    tempModel.house.house_wei = self.house_wei;
    tempModel.house.house_chufang = self.house_chufang;
    tempModel.house.house_yangtai = self.house_yangtai;
    tempModel.house.house_area = self.house_area;
    tempModel.house.elevator = self.elevator;
    
    tempModel.house.rent_price = self.rent_price;
    tempModel.house.payment = self.payment;
    tempModel.house.rent_property = self.rent_property;
    tempModel.house.lead_time = self.lead_time;
    tempModel.house.cycle = self.cycle;
    tempModel.house.time_interval_start = self.time_interval_start;
    tempModel.house.time_interval_end = self.time_interval_end;
    
    tempModel.house.name = self.name;
    tempModel.house.tel = self.tel;
    tempModel.house.entrust = self.entrust;
    tempModel.house.entrust_company = self.entrust_company;
    tempModel.house.view_count = self.view_count;
    
    tempModel.house.provinceid = self.provinceid;
    tempModel.house.cityid = self.cityid;
    tempModel.house.areaid = self.areaid;
    tempModel.house.street = self.street;
    tempModel.house.commend = self.commend;
    tempModel.house.attach_file = self.attach_file;
    tempModel.house.attach_thumb = self.attach_thumb;
    
    tempModel.house.status = self.status;
    tempModel.house.house_status = self.house_status;
    tempModel.house.fee = self.fee;
    tempModel.house.negotiated = self.negotiated;
    tempModel.house.video_url = self.video_url;
    tempModel.house.reservation_num = self.reservation_num;
    tempModel.house.property_type = self.property_type;
    tempModel.house.attention_count = self.attention_count;
    tempModel.house.favorite_count = self.favorite_count;
    
    ///业主信息
    tempModel.user.id_ = self.user_id;
    tempModel.user.username = self.name;
    tempModel.user.mobile = self.tel;
    
    return tempModel;

}

@end
