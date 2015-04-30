//
//  QSFilterDataModel.m
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSFilterDataModel.h"
#import "QSBaseConfigurationDataModel.h"

@implementation QSFilterDataModel

/**
 *  @author yangshengmeng, 15-03-27 00:03:32
 *
 *  @brief  重写初始化，添加自定义属性的初始化
 *
 *  @return 返回当前创建的过滤器模型
 *
 *  @since  1.0.0
 */
- (instancetype)init
{

    if (self = [super init]) {
        
        ///标签数组
        self.features_list = [[NSMutableArray alloc] init];
        self.installations = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

///清空过滤条件
- (void)clearFilterInfo
{
    
    self.buy_purpose_key = nil;
    self.buy_purpose_val = nil;
    self.decoration_key = nil;
    self.decoration_val = nil;
    self.des = nil;
    self.district_key = nil;
    self.district_val = nil;
    self.floor_key = nil;
    self.floor_val = nil;
    self.house_area_key = nil;
    self.house_area_val = nil;
    self.house_face_key = nil;
    self.house_face_val = nil;
    self.house_type_key = nil;
    self.house_type_val = nil;
    self.rent_pay_type_key = nil;
    self.rent_pay_type_val = nil;
    self.rent_price_key = nil;
    self.rent_price_val = nil;
    self.rent_type_key = nil;
    self.rent_type_val = nil;
    self.sale_price_key = nil;
    self.sale_price_val = nil;
    self.avg_price_key = nil;
    self.avg_price_val = nil;
    self.street_key = nil;
    self.street_val = nil;
    self.trade_type_key = nil;
    self.trade_type_val = nil;
    self.used_year_val = nil;
    self.used_year_key = nil;
    self.comment = nil;
    [self.installations removeAllObjects];
    [self.features_list removeAllObjects];

}

- (NSString *)getFeaturesPostParams
{

    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (QSBaseConfigurationDataModel *obj in self.features_list) {
        
        [tempString appendString:obj.key];
        [tempString appendString:@","];
        
    }
    
    ///删除最后的分号
    if ([tempString length] > 0) {
        
        [tempString deleteCharactersInRange:NSMakeRange([tempString length] - 1, 1)];
        
    }
    
    return [NSString stringWithString:tempString];

}

- (NSString *)getInstallationPostParams
{

    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (QSBaseConfigurationDataModel *obj in self.installations) {
        
        [tempString appendString:obj.key];
        
    }
    
    return [NSString stringWithString:tempString];

}

#pragma mark - 小区二手房/出租房列表请求参数
- (NSDictionary *)getCommunitySecondHandHouseListParams
{
    
    ///封装参数
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    
    ///城市信息
    [tempDictionary setObject:(self.city_key ? self.city_key : @"") forKey:@"cityid"];
    [tempDictionary setObject:(self.district_key ? self.district_key : @"") forKey:@"areaid"];
    [tempDictionary setObject:(self.street_key ? self.street_key : @"") forKey:@"street"];
    
    ///户型
    [tempDictionary setObject:(self.house_type_key ? self.house_type_key : @"") forKey:@"house_shi"];
    
    ///厅
    [tempDictionary setObject:@"" forKey:@"house_ting"];
    
    ///卫
    [tempDictionary setObject:@"" forKey:@"house_wei"];
    
    ///厨房
    [tempDictionary setObject:@"" forKey:@"house_chufang"];
    
    ///阳台
    [tempDictionary setObject:@"" forKey:@"house_yangtai"];
    
    ///添加均价
    [tempDictionary setObject:(self.avg_price_key ? self.avg_price_key : @"") forKey:@"price_avg"];
    
    ///配套:二手房和出租房的配套不同
    [tempDictionary setObject:@"" forKey:@"installation"];
    
    ///朝向
    [tempDictionary setObject:(self.house_face_key ? self.house_face_key : @"") forKey:@"house_face"];
    
    ///意向的楼层
    [tempDictionary setObject:(self.floor_key ? self.floor_key : @"") forKey:@"floor_which"];
    
    ///装修类型
    [tempDictionary setObject:(self.decoration_key ? self.decoration_key : @"") forKey:@"decoration_type"];
    
    ///特色标签
    if ([self.features_list count] > 0) {
        
        NSMutableString *featuresString = [[NSMutableString alloc] init];
        for (QSBaseConfigurationDataModel *obj in self.features_list) {
            
            [featuresString appendString:obj.key];
            [featuresString appendString:@","];
            
        }
        
        ///将最后一个<,>去掉
        [tempDictionary setObject:[NSString stringWithString:[featuresString substringToIndex:(featuresString.length - 1)]] forKey:@"features"];
        
    } else {
        
        [tempDictionary setObject:@"" forKey:@"features"];
        
    }
    
    ///售价
    [tempDictionary setObject:(self.sale_price_key ? self.sale_price_key : @"") forKey:@"house_price"];
    
    ///房龄
    [tempDictionary setObject:(self.used_year_key ? self.used_year_key : @"") forKey:@"house_age"];
    
    ///房子性质
    [tempDictionary setObject:@"" forKey:@"house_nature"];
    
    ///面积
    [tempDictionary setObject:(self.house_area_key ? self.house_area_key : @"") forKey:@"house_area"];
    
    ///电梯
    [tempDictionary setObject:@"" forKey:@"elevator"];
    
    ///是否推荐
    [tempDictionary setObject:@"N" forKey:@"commend"];
    
    ///楼盘的总楼层数量
    [tempDictionary setObject:@"" forKey:@"floor_num"];
    
    return [NSDictionary dictionaryWithDictionary:tempDictionary];

}

- (NSDictionary *)getCommunityRentHouseListParams
{
    
    ///封装参数
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    
    ///城市信息
    [tempDictionary setObject:(self.city_key ? self.city_key : @"") forKey:@"cityid"];
    [tempDictionary setObject:(self.district_key ? self.district_key : @"") forKey:@"areaid"];
    [tempDictionary setObject:(self.street_key ? self.street_key : @"") forKey:@"street"];
    
    ///户型
    [tempDictionary setObject:(self.house_type_key ? self.house_type_key : @"") forKey:@"house_shi"];
    
    ///厅
    [tempDictionary setObject:@"" forKey:@"house_ting"];
    
    ///卫
    [tempDictionary setObject:@"" forKey:@"house_wei"];
    
    ///厨房
    [tempDictionary setObject:@"" forKey:@"house_chufang"];
    
    ///阳台
    [tempDictionary setObject:@"" forKey:@"house_yangtai"];
    
    ///添加均价
    [tempDictionary setObject:(self.avg_price_key ? self.avg_price_key : @"") forKey:@"price_avg"];
    
    ///配套:二手房和出租房的配套不同
    [tempDictionary setObject:@"" forKey:@"installation"];
    
    ///朝向
    [tempDictionary setObject:(self.house_face_key ? self.house_face_key : @"") forKey:@"house_face"];
    
    ///意向的楼层
    [tempDictionary setObject:(self.floor_key ? self.floor_key : @"") forKey:@"floor_which"];
    
    ///装修类型
    [tempDictionary setObject:(self.decoration_key ? self.decoration_key : @"") forKey:@"decoration_type"];
    
    ///特色标签
    if ([self.features_list count] > 0) {
        
        NSMutableString *featuresString = [[NSMutableString alloc] init];
        for (QSBaseConfigurationDataModel *obj in self.features_list) {
            
            [featuresString appendString:obj.key];
            [featuresString appendString:@","];
            
        }
        
        ///将最后一个<,>去掉
        [tempDictionary setObject:[NSString stringWithString:[featuresString substringToIndex:(featuresString.length - 1)]] forKey:@"features"];
        
    } else {
        
        [tempDictionary setObject:@"" forKey:@"features"];
        
    }
    
    ///删除均价
    [tempDictionary removeObjectForKey:@"price_avg"];
    
    ///租金
    [tempDictionary setObject:(self.rent_price_key ? self.rent_price_key : @"") forKey:@"rent_price"];
    
    ///租金支付方式
    [tempDictionary setObject:(self.rent_pay_type_key ? self.rent_pay_type_key : @"") forKey:@"payment"];
    
    return [NSDictionary dictionaryWithDictionary:tempDictionary];

}

@end
