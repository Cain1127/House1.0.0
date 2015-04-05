//
//  QSYAskRentAndBuyDataModel.m
//  House
//
//  Created by ysmeng on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskRentAndBuyDataModel.h"
#import "QSFilterDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

#import "QSBaseConfigurationDataModel.h"

@implementation QSYAskRentAndBuyDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"type",
                                                    @"title",
                                                    @"title_second",
                                                    @"content",
                                                    @"intent",
                                                    @"rent_property",
                                                    @"price",
                                                    @"property_type",
                                                    @"decoration_type",
                                                    @"floor_which",
                                                    @"house_face",
                                                    @"installation",
                                                    @"features",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"house_area",
                                                    @"provinceid",
                                                    @"cityid",
                                                    @"areaid",
                                                    @"street",
                                                    @"view_count",
                                                    @"commend",
                                                    @"commend_num",
                                                    @"attach_file",
                                                    @"attach_thumb",
                                                    @"status",
                                                    @"payment",
                                                    @"used_year"]];
    
    return shared_mapping;
    
}

/**
 *  @author yangshengmeng, 15-04-04 22:04:24
 *
 *  @brief  将求租求购数据模型，转换为过滤器类型
 *
 *  @return 返回当前转换的过滤器模型
 *
 *  @since  1.0.0
 */
- (QSFilterDataModel *)change_AskDataModel_TO_FilterModel
{

    if (1 == [self.type intValue]) {
        
        return [self change_AskDataModel_TO_RentHouseFilterModel];
        
    }
    
    return [self change_AskDataModel_TO_SecondHandHouseFilterModel];

}

- (QSFilterDataModel *)change_AskDataModel_TO_SecondHandHouseFilterModel
{

    QSFilterDataModel *filterModel = [[QSFilterDataModel alloc] init];
    QSBaseConfigurationDataModel *cityModel = [QSCoreDataManager getCityModelWithDitrictKey:self.areaid];
    QSBaseConfigurationDataModel *districtModel = [QSCoreDataManager getDistrictModelWithStreetKey:self.street];
    QSBaseConfigurationDataModel *streetModel = [QSCoreDataManager getStreetModelWithStreetKey:self.street];
    filterModel.filter_id = self.id_;
    filterModel.city_key = APPLICATION_NSSTRING_SETTING(cityModel.key, @"");
    filterModel.city_val = APPLICATION_NSSTRING_SETTING(cityModel.val, @"");
    filterModel.district_key = APPLICATION_NSSTRING_SETTING(districtModel.key, @"");
    filterModel.district_val = APPLICATION_NSSTRING_SETTING(districtModel.val, @"");
    filterModel.street_key = APPLICATION_NSSTRING_SETTING(streetModel.key, @"");
    filterModel.street_val = APPLICATION_NSSTRING_SETTING(streetModel.val, @"");
    filterModel.buy_purpose_key = APPLICATION_NSSTRING_SETTING(self.intent, @"");
    filterModel.buy_purpose_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getPerpostPerchaseTypeWithKey:self.intent], @"");
    filterModel.sale_price_key = APPLICATION_NSSTRING_SETTING(self.price, @"");
    filterModel.sale_price_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseSalePriceValueWithKey:self.price], @"");
    filterModel.house_type_key = APPLICATION_NSSTRING_SETTING(self.house_shi, @"");
    filterModel.house_type_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseTypeValueWithKey:self.house_shi], @"");
    filterModel.house_area_key = APPLICATION_NSSTRING_SETTING(self.house_area, @"");
    filterModel.house_area_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseAreaTypeWithKey:self.house_area], @"");
    filterModel.trade_type_key = APPLICATION_NSSTRING_SETTING(self.property_type, @"");
    filterModel.trade_type_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseTradeTypeWithKey:self.property_type], @"");
    filterModel.floor_key = APPLICATION_NSSTRING_SETTING(self.floor_which, @"");
    filterModel.floor_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseFloorTypeWithKey:self.floor_which], @"");
    filterModel.house_face_key = APPLICATION_NSSTRING_SETTING(self.house_face, @"");
    filterModel.house_face_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseFloorTypeWithKey:self.house_face], @"");
    filterModel.decoration_key = APPLICATION_NSSTRING_SETTING(self.decoration_type, @"");
    filterModel.decoration_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseDecorationTypeWithKey:self.decoration_type], @"");
    filterModel.comment = APPLICATION_NSSTRING_SETTING(self.content, @"");
    filterModel.used_year_key = APPLICATION_NSSTRING_SETTING(self.used_year, @"");
    filterModel.used_year_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseUsedYearTypeWithKey:self.used_year], @"");
    
    ///特色标签
    if ([self.features length] > 0) {
        
        NSArray *featuresList = [self.features componentsSeparatedByString:@","];
        for (int i = 0; i < [featuresList count]; i++) {
            
            NSString *tempKey = featuresList[i];
            NSString *tempValue = [QSCoreDataManager getHouseFeatureWithKey:tempKey andFilterType:fFilterMainTypeRentalHouse];
            QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
            tempModel.key = tempKey;
            tempModel.val = tempValue;
            [filterModel.features_list addObject:tempModel];
            
        }
        
    }

    return filterModel;

}

- (QSFilterDataModel *)change_AskDataModel_TO_RentHouseFilterModel
{

    QSFilterDataModel *filterModel = [[QSFilterDataModel alloc] init];
    
    filterModel.filter_id = self.id_;
    filterModel.rent_type_key = APPLICATION_NSSTRING_SETTING(self.rent_property, @"");
    filterModel.rent_type_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseRentTypeWithKey:self.rent_property], @"");
    
    QSBaseConfigurationDataModel *cityModel = [QSCoreDataManager getCityModelWithDitrictKey:self.areaid];
    QSBaseConfigurationDataModel *districtModel = [QSCoreDataManager getDistrictModelWithStreetKey:self.street];
    QSBaseConfigurationDataModel *streetModel = [QSCoreDataManager getStreetModelWithStreetKey:self.street];
    filterModel.city_key = APPLICATION_NSSTRING_SETTING(cityModel.key, @"");
    filterModel.city_val = APPLICATION_NSSTRING_SETTING(cityModel.val, @"");
    filterModel.district_key = APPLICATION_NSSTRING_SETTING(districtModel.key, @"");
    filterModel.district_val = APPLICATION_NSSTRING_SETTING(districtModel.val, @"");
    filterModel.street_key = APPLICATION_NSSTRING_SETTING(streetModel.key, @"");
    filterModel.street_val = APPLICATION_NSSTRING_SETTING(streetModel.val, @"");
    filterModel.rent_price_key = APPLICATION_NSSTRING_SETTING(self.price, @"");
    filterModel.rent_price_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseRentPriceValueWithKey:self.price], @"");
    filterModel.rent_pay_type_key = APPLICATION_NSSTRING_SETTING(self.payment,@"");
    filterModel.rent_pay_type_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseRentTypeWithKey:self.payment],@"");
    filterModel.house_type_key = APPLICATION_NSSTRING_SETTING(self.house_shi, @"");
    filterModel.house_type_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseTypeValueWithKey:self.house_shi], @"");
    filterModel.trade_type_key = APPLICATION_NSSTRING_SETTING(self.property_type, @"");
    filterModel.trade_type_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseTradeTypeWithKey:self.property_type], @"");
    filterModel.floor_key = APPLICATION_NSSTRING_SETTING(self.floor_which, @"");
    filterModel.floor_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseFloorTypeWithKey:self.floor_which], @"");
    filterModel.house_face_key = APPLICATION_NSSTRING_SETTING(self.house_face, @"");
    filterModel.house_face_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseFloorTypeWithKey:self.house_face], @"");
    filterModel.decoration_key = APPLICATION_NSSTRING_SETTING(self.decoration_type, @"");
    filterModel.decoration_val = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getHouseDecorationTypeWithKey:self.decoration_type], @"");
    filterModel.comment = APPLICATION_NSSTRING_SETTING(self.content, @"");
    
    ///特色标签
    if ([self.features length] > 0) {
        
        NSArray *featuresList = [self.features componentsSeparatedByString:@","];
        for (int i = 0; i < [featuresList count]; i++) {
            
            NSString *tempKey = featuresList[i];
            NSString *tempValue = [QSCoreDataManager getHouseFeatureWithKey:tempKey andFilterType:fFilterMainTypeRentalHouse];
            QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
            tempModel.key = tempKey;
            tempModel.val = tempValue;
            [filterModel.features_list addObject:tempModel];
            
        }
        
    }
    
    return filterModel;

}

@end
