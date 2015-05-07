//
//  QSHouseInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/2/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseInfoDataModel.h"
#import "QSSecondHouseDetailDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSWSecondHouseInfoDataModel.h"

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

/**
 *  @author yangshengmeng, 15-05-07 14:05:18
 *
 *  @brief  当前列表的二手房数据模型，转换为详情数据模型
 *
 *  @return 返回转换的结果
 *
 *  @since  1.0.0
 */
- (QSSecondHouseDetailDataModel *)changeToSecondHandHouseDetailModel
{

    QSSecondHouseDetailDataModel *tempModel = [[QSSecondHouseDetailDataModel alloc] init];
    
    tempModel.house = [[QSWSecondHouseInfoDataModel alloc] init];
    tempModel.user = [[QSUserSimpleDataModel alloc] init];
    
    tempModel.is_syserver = self.is_syserver;
    
    ///房源信息
    tempModel.house.id_ = self.id_;
    tempModel.house.user_id = self.user_id;
    tempModel.house.introduce = self.introduce;
    tempModel.house.title = self.title;
    tempModel.house.title_second = self.title_second;
    tempModel.house.address = self.address;
    
    tempModel.house.floor_num = self.floor_num;
    tempModel.house.property_type = self.property_type;
    tempModel.house.used_year = self.used_year;
    tempModel.house.installation = self.installation;
    tempModel.house.features = self.features;
    
    tempModel.house.view_count = self.view_count;
    tempModel.house.provinceid = self.provinceid;
    tempModel.house.cityid = self.cityid;
    tempModel.house.areaid = self.areaid;
    tempModel.house.street = self.street;
    
    tempModel.house.attach_file = self.attach_file;
    tempModel.house.attach_thumb = self.attach_thumb;
    tempModel.house.favorite_count = self.favorite_count;
    tempModel.house.attention_count = self.attention_count;
    tempModel.house.update_time = self.update_time;
    tempModel.house.status = self.status;
    
    tempModel.house.name = self.name;
    tempModel.house.tel = self.tel;
    tempModel.house.content = self.content;
    tempModel.house.village_id = self.village_id;
    
    tempModel.house.village_name = self.village_name;
    tempModel.house.building_structure = self.building_structure;
    tempModel.house.floor_which = self.floor_which;
    tempModel.house.house_face = self.house_face;
    tempModel.house.decoration_type = self.decoration_type;
    
    tempModel.house.house_area = self.house_area;
    tempModel.house.house_shi = self.house_shi;
    tempModel.house.house_ting = self.house_ting;
    tempModel.house.house_wei = self.house_wei;
    tempModel.house.house_chufang = self.house_chufang;
    tempModel.house.house_yangtai = self.house_yangtai;
    tempModel.house.cycle = self.cycle;
    
    tempModel.house.time_interval_start = self.time_interval_start;
    tempModel.house.time_interval_end = self.time_interval_end;
    tempModel.house.entrust = self.entrust;
    tempModel.house.entrust_company = self.entrust_company;
    tempModel.house.video_url = self.video_url;
    tempModel.house.negotiated = self.negotiated;
    tempModel.house.reservation_num = self.reservation_num;
    tempModel.house.house_no = self.house_no;
    
    tempModel.house.building_year = self.building_year;
    tempModel.house.house_price = self.house_price;
    tempModel.house.house_nature = self.house_nature;
    tempModel.house.elevator = self.elevator;
    
    ///业主信息
    tempModel.user.id_ = self.user_id;
    tempModel.user.username = self.name;
    tempModel.user.mobile = self.tel;
    
    return tempModel;

}

@end
