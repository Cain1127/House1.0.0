//
//  QSNewHouseInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNewHouseInfoDataModel.h"
#import "QSNewHouseDetailDataModel.h"
#import "QSUserBaseInfoDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSLoupanPhaseDataModel.h"
#import "QSRateDataModel.h"

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

/**
 *  @author yangshengmeng, 15-05-07 14:05:55
 *
 *  @brief  将当前列且中新房数据模型，转换为新房详情数据模型
 *
 *  @return 返回当前转换后的详情数据模型
 *
 *  @since  1.0.0
 */
- (QSNewHouseDetailDataModel *)changeToNewHouseDetailModel
{

    QSNewHouseDetailDataModel *tempModel = [[QSNewHouseDetailDataModel alloc] init];
    tempModel.loupan = [[QSLoupanInfoDataModel alloc] init];
    tempModel.loupan_building = [[QSLoupanPhaseDataModel alloc] init];
    tempModel.user = [[QSUserBaseInfoDataModel alloc] init];
    tempModel.loupanBuilding_photo = [NSMutableArray array];
    tempModel.loupanHouse_commend = [NSMutableArray array];
    tempModel.loupanHouse = [NSMutableArray array];
    tempModel.loupan_activity = [NSMutableArray array];
    tempModel.loan = [[QSRateDataModel alloc] init];
    
    tempModel.is_syserver = self.is_syserver;
    
    ///楼盘
    tempModel.loupan.id_ = self.loupan_id;
    tempModel.loupan.title = self.title;
    tempModel.loupan.title_second = self.title;
    tempModel.loupan.address = self.address;
    
    tempModel.loupan.property_type = self.property_type;
    tempModel.loupan.used_year = self.used_year;
    tempModel.loupan.features = self.features;
    
    tempModel.loupan.provinceid = self.provinceid;
    tempModel.loupan.cityid = self.cityid;
    tempModel.loupan.areaid = self.areaid;
    tempModel.loupan.street = self.street;
    
    tempModel.loupan.attach_file = self.attach_file;
    tempModel.loupan.attach_thumb = self.attach_thumb;
    
    tempModel.loupan.building_structure = self.building_structure;
    tempModel.loupan.decoration_type = self.decoration_type;
    
    ///楼栋
    tempModel.loupan_building.id_ = self.loupan_id;
    tempModel.loupan_building.title = self.title;
    tempModel.loupan_building.title_second = self.title;
    tempModel.loupan_building.address = self.address;
    
    tempModel.loupan_building.property_type = self.property_type;
    tempModel.loupan_building.used_year = self.used_year;
    tempModel.loupan_building.features = self.features;
    
    tempModel.loupan_building.provinceid = self.provinceid;
    tempModel.loupan_building.cityid = self.cityid;
    tempModel.loupan_building.areaid = self.areaid;
    tempModel.loupan_building.street = self.street;
    tempModel.loupan_building.attach_file = self.attach_file;
    tempModel.loupan_building.attach_thumb = self.attach_thumb;
    
    tempModel.loupan_building.loupan_id = self.loupan_id;
    tempModel.loupan_building.loupan_periods = self.loupan_periods;
    
    tempModel.loupan_building.price_avg = self.price_avg;
    tempModel.loupan_building.min_house_area = self.min_house_area;
    tempModel.loupan_building.max_house_area = self.max_house_area;
    
    return tempModel;

}

@end
