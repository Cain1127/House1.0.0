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

///过滤器信息的CoreData模型
#define COREDATA_ENTITYNAME_FILTER @"QSCDFilterDataModel"

@implementation QSCoreDataManager (Filter)

/**
 *  @author yangshengmeng, 15-02-04 15:02:25
 *
 *  @brief  初始化一个出租房的过滤器
 *
 *  @return 返回初始化是否成功
 *
 *  @since  1.0.0
 */
+ (BOOL)initRentalHouseFilter
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    
    NSError *error = nil;
    
    ///插入数据
    QSCDFilterDataModel *model = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_FILTER inManagedObjectContext:mOContext];
    model.filter_id = [NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse];
    model.filter_status = @"0";
    [mOContext save:&error];
    
    if (error) {
        
        return NO;
        
    }
    
    return YES;

}

/**
 *  @author yangshengmeng, 15-02-04 15:02:02
 *
 *  @brief  初始化一个二手房的过滤器
 *
 *  @return 返回是否初始化成功
 *
 *  @since  1.0.0
 */
+ (BOOL)initSecondHandHouseFilter
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    
    NSError *error = nil;
    
    ///插入数据
    QSCDFilterDataModel *model = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_FILTER inManagedObjectContext:mOContext];
    model.filter_id = [NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse];
    model.filter_status = @"0";
    [mOContext save:&error];
    
    if (error) {
        
        return NO;
        
    }
    
    return YES;

}

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

    NSString *filterStatus = [self searchEntityWithKey:COREDATA_ENTITYNAME_FILTER andFieldName:@"filter_status" andFieldSearchKey:[NSString stringWithFormat:@"%d",filteType]];
    
    if (nil == filterStatus) {
        
        return fFilterStatusTypeNoRecord;
        
    }
    
    return [filterStatus intValue];

}

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

    QSCDFilterDataModel *cdFilterModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_FILTER andFieldName:@"filter_id" andFieldSearchKey:[NSString stringWithFormat:@"%d",filterType]];
    
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
    
    ///更新对应过滤器的状态
    BOOL isUpdateSuccess = [self updateFieldWithKey:COREDATA_ENTITYNAME_FILTER andFilterFieldName:@"filter_id" andFilterFieldValue:[NSString stringWithFormat:@"%d",filterType] andUpdateFieldName:@"filter_status" andUpdateFieldNewValue:[NSString stringWithFormat:@"%d",filterStatus]];
    
    ///回调
    if (callBack) {
        
        callBack(isUpdateSuccess);
        
    }

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

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_FILTER inManagedObjectContext:mOContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filter_id == %@",[NSString stringWithFormat:@"%d",filterType]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = [mOContext executeFetchRequest:fetchRequest error:&error];
    
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
        cdfilterModel.street_key = filterModel.street_key;
        cdfilterModel.street_val = filterModel.street_val;
        cdfilterModel.trade_type_key = filterModel.trade_type_key;
        cdfilterModel.trade_type_val = filterModel.trade_type_val;
        cdfilterModel.used_year_val = filterModel.used_year_val;
        cdfilterModel.rent_price_val = filterModel.rent_price_val;
        cdfilterModel.used_year_key = filterModel.used_year_key;
        cdfilterModel.filter_status = filterModel.filter_status;
        
        cdfilterModel.features_list = [NSSet setWithArray:filterModel.features_list];
        
        [mOContext save:&error];
        
    }
    
    if (error) {
        
        NSLog(@"=====================更新过滤器出错========================");
        NSLog(@"error:%@",error);
        NSLog(@"=====================更新过滤器出错========================");
        
    } else {
    
        isUpdateSuccess = YES;
    
    }
    
    if (callBack) {
        
        callBack(isUpdateSuccess);
        
    }
    
}

@end
