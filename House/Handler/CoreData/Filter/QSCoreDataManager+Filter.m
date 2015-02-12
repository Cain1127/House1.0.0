//
//  QSCoreDataManager+Filter.m
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+Filter.h"
#import "QSYAppDelegate.h"

#import "QSCDFilterDataModel.h"
#import "QSFilterDataModel.h"
#import "QSCDBaseConfigurationDataModel.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"

///过滤器信息的CoreData模型
#define COREDATA_ENTITYNAME_FILTER @"QSCDFilterDataModel"

@implementation QSCoreDataManager (Filter)

#pragma mark - 过滤器创建

/**
 *  @author             yangshengmeng, 15-02-05 12:02:17
 *
 *  @brief              创建一个过滤器，必须要传类型，并且创建后将创建结果标识回调，可以创建给定城市的过滤器
 *
 *  @param filterType   过滤器类型
 *  @param callBack     创建后的回调
 *
 *  @since              1.0.0
 */
+ (void)createFilter
{

    ///获取当前用户城市信息
    NSString *userCityKey = [QSCoreDataManager getCurrentUserCityKey];
    [self createFilterWithCityKey:userCityKey];

}

///创建给定城市的过滤器
+ (void)createFilterWithCityKey:(NSString *)cityKey
{

    ///楼盘过滤器
    [self createFilterWithFilterType:fFilterMainTypeBuilding andCityKey:cityKey andCallBack:^(FILTER_CREATE_RESULT_STATUS resultStauts) {}];
    
    ///新房过滤器
    [self createFilterWithFilterType:fFilterMainTypeNewHouse andCityKey:cityKey andCallBack:^(FILTER_CREATE_RESULT_STATUS resultStauts) {}];
    
    ///小区过滤器
    [self createFilterWithFilterType:fFilterMainTypeCommunity andCityKey:cityKey andCallBack:^(FILTER_CREATE_RESULT_STATUS resultStauts) {}];
    
    ///二手房过滤器
    [self createFilterWithFilterType:fFilterMainTypeSecondHouse andCityKey:cityKey andCallBack:^(FILTER_CREATE_RESULT_STATUS resultStauts) {}];
    
    ///出租房过滤器
    [self createFilterWithFilterType:fFilterMainTypeRentalHouse andCityKey:cityKey andCallBack:^(FILTER_CREATE_RESULT_STATUS resultStauts) {}];

}

///创建一个特定类型的过滤器，同时创建完成后回调
+ (void)createFilterWithFilterType:(FILTER_MAIN_TYPE)filterType andCallBack:(void(^)(FILTER_CREATE_RESULT_STATUS resultStauts))callBack
{
    
    ///获取当前用户城市信息
    NSString *userCityKey = [QSCoreDataManager getCurrentUserCityKey];
    
    ///进入按城市创建过滤器方法
    [self createFilterWithFilterType:filterType andCityKey:userCityKey andCallBack:callBack];
    
}

///创建一个特定类型和城市的过滤器，创建完成后回调
+ (void)createFilterWithFilterType:(FILTER_MAIN_TYPE)filterType andCityKey:(NSString *)cityKey andCallBack:(void(^)(FILTER_CREATE_RESULT_STATUS resultStauts))callBack
{
    
    ///判断城市key
    if (!cityKey) {
        
        if (callBack) {
            
            callBack(fFilterCreateResultStatusFail);
            
        }
        
        return;
        
    }
    
    ///转换参数
    NSString *filterID = [NSString stringWithFormat:@"%d",filterType];
    
    ///先查询原来是否已存在重复的过滤器
    QSCDBaseConfigurationDataModel *tempFilterModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_FILTER andFieldName:@"filter_id" andFieldSearchKey:filterID andSecondFieldName:@"city_key" andSecndFieldValue:cityKey];
    
    if (tempFilterModel) {
        
        ///回调告知，原来已有相同过滤器
        if (callBack) {
            
            callBack(fFilterCreateResultStatusExist);
            
        }
        
        return;
        
    }

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSError *error = nil;
    
    ///插入数据
    QSCDFilterDataModel *model = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_FILTER inManagedObjectContext:tempContext];
    model.filter_id = filterID;
    model.filter_status = @"0";
    
    ///保存初始化的过滤器信息
    QSCDBaseConfigurationDataModel *provinceModel = [QSCoreDataManager getProvinceModelWithCityKey:cityKey];
    
    model.city_key = cityKey;
    model.city_val = [QSCoreDataManager getCityValWithCityKey:cityKey];
    model.province_key = provinceModel.key;
    model.province_val = provinceModel.val;
    
    [tempContext save:&error];
    
    if (error) {
        
        if (callBack) {
            
            callBack(fFilterCreateResultStatusFail);
            
        }
        
    } else {
        
        ///保存数据到本地
        if ([NSThread isMainThread]) {
            
            [appDelegate saveContextWithWait:YES];
            
        } else {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [appDelegate saveContextWithWait:NO];
                
            });
            
        }
    
        if (callBack) {
            
            callBack(fFilterCreateResultStatusSuccess);
            
        }
    
    }

}

#pragma mark - 查找过滤器的当前状态
/**
 *  @author             yangshengmeng, 15-02-04 16:02:24
 *
 *  @brief              返回当前类型的过滤器状态
 *
 *  @param filteType    过滤器的类型
 *
 *  @return             返回过滤器的状态
 *
 *  @since              1.0.0
 */
+ (FILTER_STATUS_TYPE)getFilterStatusWithType:(FILTER_MAIN_TYPE)filteType
{
    
    ///获取当前用户城市信息
    NSString *userCityKey = [QSCoreDataManager getCurrentUserCityKey];
    
    return [self getFilterStatusWithType:filteType andCityKey:userCityKey];

}

///查找给定类型和城市过滤器的状态
+ (FILTER_STATUS_TYPE)getFilterStatusWithType:(FILTER_MAIN_TYPE)filteType andCityKey:(NSString *)cityKey
{

    QSCDFilterDataModel *filterModel = [self getLocalFilterWithType:filteType andCityKey:cityKey];
    
    if (nil == filterModel) {
        
        return fFilterStatusTypeNoRecord;
        
    }
    
    return [filterModel.filter_status intValue];

}

#pragma mark - 更新过滤器状态
/**
 *  @author             yangshengmeng, 15-02-04 18:02:19
 *
 *  @brief              更新过滤器的状态
 *
 *  @param filterStatus 给定的状态
 *  @param callBack     更新后的回调
 *
 *  @since              1.0.0
 */
+ (void)updateFilterStatusWithFilterType:(FILTER_MAIN_TYPE)filterType andFilterNewStatus:(FILTER_STATUS_TYPE)filterStatus andUpdateCallBack:(void(^)(BOOL isSuccess))callBack
{
    
    ///获取当前用户城市信息
    NSString *userCityKey = [QSCoreDataManager getCurrentUserCityKey];
    
    [self updateFilterStatusWithFilterType:filterType andCityKey:userCityKey andFilterNewStatus:filterStatus andUpdateCallBack:callBack];
    
}

///更新指定类型和城市的过滤器
+ (void)updateFilterStatusWithFilterType:(FILTER_MAIN_TYPE)filterType andCityKey:(NSString *)cityKey andFilterNewStatus:(FILTER_STATUS_TYPE)filterStatus andUpdateCallBack:(void(^)(BOOL isSuccess))callBack
{

    ///过滤器ID
    NSString *filterID = [NSString stringWithFormat:@"%d",filterType];
    
    ///定制过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filter_id = %@ AND city_key = %@",filterID,cityKey];
    
    ///更新对应过滤器的状态
    BOOL isUpdateSuccess = [self updateFieldWithKey:COREDATA_ENTITYNAME_FILTER andPredicate:predicate andUpdateFieldName:@"filter_status" andNewValue:[NSString stringWithFormat:@"%d",filterStatus]];
    
    ///回调
    if (callBack) {
        
        callBack(isUpdateSuccess);
        
    }

}

#pragma mark - 获取过滤器
/**
 *  @author             yangshengmeng, 15-02-04 16:02:05
 *
 *  @brief              返回当前的过滤器信息
 *
 *  @param filterType   过滤器类型
 *
 *  @return             返回一个普通的过滤器数据模型
 *
 *  @since              1.0.0
 */
+ (id)getLocalFilterWithType:(FILTER_MAIN_TYPE)filterType
{
    
    ///获取用户当前城市
    NSString *cityKey = [QSCoreDataManager getCurrentUserCityKey];
    return [self getLocalFilterWithType:filterType andCityKey:cityKey];

}

///获取指定类型和城市的过滤器
+ (id)getLocalFilterWithType:(FILTER_MAIN_TYPE)filterType andCityKey:(NSString *)cityKey
{

    return [self getLocalFilterWithFilterID:[NSString stringWithFormat:@"%d",filterType] andCityKey:cityKey];

}

///根据过滤器ID获取过滤器
+ (id)getLocalFilterWithFilterID:(NSString *)filterID
{
    
    ///获取用户当前城市
    NSString *cityKey = [QSCoreDataManager getCurrentUserCityKey];
    
    return [self getLocalFilterWithFilterID:filterID andCityKey:cityKey];

}

///根据给定的类型和城市，返回过滤器
+ (id)getLocalFilterWithFilterID:(NSString *)filterID andCityKey:(NSString *)cityKey
{

    if (nil == filterID) {
        
        return nil;
        
    }
    
    QSCDFilterDataModel *cdFilterModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_FILTER andFieldName:@"filter_id" andFieldSearchKey:filterID andSecondFieldName:@"city_key" andSecndFieldValue:cityKey];
    
    if (nil == cdFilterModel) {
        
        return nil;
        
    }
    
    ///转换模型
    QSFilterDataModel *filterModel = [[QSFilterDataModel alloc] init];
    
    filterModel.buy_purpose_key = cdFilterModel.buy_purpose_key;
    filterModel.buy_purpose_val = cdFilterModel.buy_purpose_val;
    filterModel.city_key = cdFilterModel.city_key;
    filterModel.city_val = cdFilterModel.city_val;
    filterModel.decoration_key = cdFilterModel.decoration_key;
    filterModel.decoration_val = cdFilterModel.decoration_val;
    filterModel.des = cdFilterModel.des;
    filterModel.district_key = cdFilterModel.district_key;
    filterModel.district_val = cdFilterModel.district_val;
    filterModel.filter_id = cdFilterModel.filter_id;
    filterModel.floor_key = cdFilterModel.floor_key;
    filterModel.floor_val = cdFilterModel.floor_val;
    filterModel.house_area_key = cdFilterModel.house_area_key;
    filterModel.house_area_val = cdFilterModel.house_area_val;
    filterModel.house_face_key = cdFilterModel.house_face_key;
    filterModel.house_face_val = cdFilterModel.house_face_val;
    filterModel.house_type_key = cdFilterModel.house_type_key;
    filterModel.house_type_val = cdFilterModel.house_type_val;
    filterModel.province_key = cdFilterModel.province_key;
    filterModel.province_val = cdFilterModel.province_val;
    filterModel.rent_pay_type_key = cdFilterModel.rent_pay_type_key;
    filterModel.rent_pay_type_val = cdFilterModel.rent_pay_type_val;
    filterModel.rent_price_key = cdFilterModel.rent_price_key;
    filterModel.rent_type_key = cdFilterModel.rent_type_key;
    filterModel.rent_type_val = cdFilterModel.rent_type_val;
    filterModel.sale_price_key = cdFilterModel.sale_price_key;
    filterModel.sale_price_val = cdFilterModel.sale_price_val;
    filterModel.avg_price_key = cdFilterModel.avg_price_key;
    filterModel.avg_price_val = cdFilterModel.avg_price_val;
    filterModel.street_key = cdFilterModel.street_key;
    filterModel.street_val = cdFilterModel.street_val;
    filterModel.trade_type_key = cdFilterModel.trade_type_key;
    filterModel.trade_type_val = cdFilterModel.trade_type_val;
    filterModel.used_year_val = cdFilterModel.used_year_val;
    filterModel.rent_price_val = cdFilterModel.rent_price_val;
    filterModel.used_year_key = cdFilterModel.used_year_key;
    filterModel.filter_status = cdFilterModel.filter_status;
    
    filterModel.features_list = [cdFilterModel.features_list allObjects];
    
    return filterModel;

}

#pragma mar - 更新过滤器
/**
 *  @author             yangshengmeng, 15-02-04 18:02:24
 *
 *  @brief              根据给定的过滤模型和过滤器类型，更新过滤器
 *
 *  @param filterType   过滤器类型
 *  @param filterModel  过滤器数据模型
 *
 *  @since              1.0.0
 */
+ (void)updateFilterWithType:(FILTER_MAIN_TYPE)filterType andFilterDataModel:(QSFilterDataModel *)filterModel andUpdateCallBack:(void(^)(BOOL isSuccess))callBack
{

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_FILTER inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filter_id == %@ AND city_key == %@",[NSString stringWithFormat:@"%d",filterType],filterModel.city_key];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    ///更新结果
    BOOL isUpdateSuccess = NO;
    
    ///判断读取出来的原数据
    if (nil == fetchResultArray) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return;
        
    }
    
    ///遍历更新
    if ([fetchResultArray count] > 0) {
        
        ///获取模型后更新保存
        QSCDFilterDataModel *cdfilterModel = fetchResultArray[0];
        
        cdfilterModel.buy_purpose_key = filterModel.buy_purpose_key;
        cdfilterModel.buy_purpose_val = filterModel.buy_purpose_val;
        cdfilterModel.city_key = filterModel.city_key;
        cdfilterModel.city_val = filterModel.city_val;
        cdfilterModel.decoration_key = filterModel.decoration_key;
        cdfilterModel.decoration_val = filterModel.decoration_val;
        cdfilterModel.des = filterModel.des;
        cdfilterModel.district_key = filterModel.district_key;
        cdfilterModel.district_val = filterModel.district_val;
        cdfilterModel.filter_id = filterModel.filter_id;
        cdfilterModel.floor_key = filterModel.floor_key;
        cdfilterModel.floor_val = filterModel.floor_val;
        cdfilterModel.house_area_key = filterModel.house_area_key;
        cdfilterModel.house_area_val = filterModel.house_area_val;
        cdfilterModel.house_face_key = filterModel.house_face_key;
        cdfilterModel.house_face_val = filterModel.house_face_val;
        cdfilterModel.house_type_key = filterModel.house_type_key;
        cdfilterModel.house_type_val = filterModel.house_type_val;
        cdfilterModel.province_key = filterModel.province_key;
        cdfilterModel.province_val = filterModel.province_val;
        cdfilterModel.rent_pay_type_key = filterModel.rent_pay_type_key;
        cdfilterModel.rent_pay_type_val = filterModel.rent_pay_type_val;
        cdfilterModel.rent_price_key = filterModel.rent_price_key;
        cdfilterModel.rent_type_key = filterModel.rent_type_key;
        cdfilterModel.rent_type_val = filterModel.rent_type_val;
        cdfilterModel.sale_price_key = filterModel.sale_price_key;
        cdfilterModel.sale_price_val = filterModel.sale_price_val;
        cdfilterModel.avg_price_key = filterModel.avg_price_key;
        cdfilterModel.avg_price_val = filterModel.avg_price_val;
        cdfilterModel.street_key = filterModel.street_key;
        cdfilterModel.street_val = filterModel.street_val;
        cdfilterModel.trade_type_key = filterModel.trade_type_key;
        cdfilterModel.trade_type_val = filterModel.trade_type_val;
        cdfilterModel.used_year_val = filterModel.used_year_val;
        cdfilterModel.rent_price_val = filterModel.rent_price_val;
        cdfilterModel.used_year_key = filterModel.used_year_key;
        cdfilterModel.filter_status = filterModel.filter_status;
        
        cdfilterModel.features_list = [NSSet setWithArray:filterModel.features_list];
        
        [tempContext save:&error];
        
    }
    
    if (error) {
        
        NSLog(@"=====================更新过滤器出错========================");
        NSLog(@"error:%@",error);
        NSLog(@"=====================更新过滤器出错========================");
        
    } else {
    
        isUpdateSuccess = YES;
    
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    if (callBack) {
        
        callBack(isUpdateSuccess);
        
    }
    
}

#pragma mark - 获取指定过滤器的请求参数
/**
 *  @author             yangshengmeng, 15-02-05 10:02:49
 *
 *  @brief              返回给定房子列表类型的请求参数
 *
 *  @param filterType   过滤器的类型
 *
 *  @return             返回指定类型的房子列表请求参数字典
 *
 *  @since              1.0.0
 */
+ (NSDictionary *)getHouseListRequestParams:(FILTER_MAIN_TYPE)filterType
{

    ///首先获取对应的过滤器模型
    QSFilterDataModel *filterModel = [self getLocalFilterWithType:filterType];
    
    ///推荐房源列表:commend
    if (fFilterStatusTypeWorking != [filterModel.filter_status intValue]) {
        
        return @{@"commend" : @"Y"};
        
    }
    
    return @{@"commend" : @"Y"};
    
    ///封装参数
    return [self getHouseListRequestParams:filterType andCityKey:[QSCoreDataManager getCurrentUserCityKey]];

}

///根据过滤器的类型和城市，创建过滤的请求参数
+ (NSDictionary *)getHouseListRequestParams:(FILTER_MAIN_TYPE)filterType andCityKey:(NSString *)cityKey
{
    
    if (!cityKey) {
        
        return nil;
        
    }

    ///首先获取对应的过滤器模型
    QSFilterDataModel *filterModel = [self getLocalFilterWithType:filterType andCityKey:cityKey];
    
    ///推荐房源列表:commend
    if (fFilterStatusTypeWorking != [filterModel.filter_status intValue]) {
        
        return @{@"commend" : @"Y"};
        
    }
    
    ///封装参数
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    
    ///城市信息
    [tempDictionary setObject:(filterModel.province_key ? filterModel.province_key : @"") forKey:@"provinceid"];
    [tempDictionary setObject:(filterModel.city_key ? filterModel.city_key : @"") forKey:@"cityid"];
    [tempDictionary setObject:(filterModel.district_key ? filterModel.district_key : @"") forKey:@"areaid"];
    [tempDictionary setObject:(filterModel.street_key ? filterModel.street_key : @"") forKey:@"street"];
    
    ///配套
    [tempDictionary setObject:@"" forKey:@"installation"];
    
    ///期望售价
    [tempDictionary setObject:(filterModel.sale_price_key ? filterModel.sale_price_key : @"") forKey:@"house_price"];
    
    ///房子性质
    [tempDictionary setObject:@"" forKey:@"house_nature"];
    
    ///朝向
    [tempDictionary setObject:(filterModel.house_face_key ? filterModel.house_face_key : @"") forKey:@"house_face"];
    
    ///户型
    [tempDictionary setObject:(filterModel.house_type_key ? filterModel.house_type_key : @"") forKey:@"house_shi"];
    
    ///厅
    [tempDictionary setObject:@"" forKey:@"house_ting"];
    
    ///卫
    [tempDictionary setObject:@"" forKey:@"house_wei"];
    
    ///厨房
    [tempDictionary setObject:@"" forKey:@"house_chufang"];
    
    ///阳台
    [tempDictionary setObject:@"" forKey:@"house_yangtai"];
    
    ///面积
    [tempDictionary setObject:(filterModel.house_area_key ? filterModel.house_area_key : @"") forKey:@"house_area"];
    
    ///电梯
    [tempDictionary setObject:@"" forKey:@"elevator"];
    
    ///是否推荐
    [tempDictionary setObject:@"N" forKey:@"commend"];
    
    ///楼盘的总楼层数量
    [tempDictionary setObject:@"" forKey:@"floor_num"];
    
    ///意向的楼层
    [tempDictionary setObject:(filterModel.floor_key ? filterModel.floor_key : @"") forKey:@"floor_which"];
    
    ///特色标签
    if ([filterModel.features_list count] > 0) {
        
        NSMutableString *featuresString = [[NSMutableString alloc] init];
        for (QSCDBaseConfigurationDataModel *obj in filterModel.features_list) {
            
            [featuresString appendString:obj.key];
            [featuresString appendString:@","];
            
        }
        
        ///将最后一个<,>去掉
        [tempDictionary setObject:[NSString stringWithString:[featuresString substringToIndex:(featuresString.length - 1)]] forKey:@"features"];
        
    } else {
    
        [tempDictionary setObject:@"" forKey:@"features"];
    
    }
    
    return [NSDictionary dictionaryWithDictionary:tempDictionary];

}

@end
