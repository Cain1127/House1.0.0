//
//  QSCoreDataManager+Filter.h
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

///过滤器创建结果标识状态
typedef enum
{

    fFilterCreateResultStatusFail = 99, //!<创建过滤器失败
    fFilterCreateResultStatusSuccess,   //!<过滤器新创建成功
    fFilterCreateResultStatusExist      //!<过滤器原来已有

}FILTER_CREATE_RESULT_STATUS;

/**
 *  @author yangshengmeng, 15-02-04 14:02:50
 *
 *  @brief  过滤器相关操作
 *
 *  @since  1.0.0
 */
@class QSFilterDataModel;
@interface QSCoreDataManager (Filter)

#pragma mark - 过滤器初始化/创建
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
+ (void)createFilter;

///创建给定城市的过滤器
+ (void)createFilterWithCityKey:(NSString *)cityKey;

///创建一个特定类型的过滤器，同时创建完成后回调
+ (void)createFilterWithFilterType:(FILTER_MAIN_TYPE)filterType andCallBack:(void(^)(FILTER_CREATE_RESULT_STATUS resultStauts))callBack;

///创建一个特定类型和城市的过滤器，创建完成后回调
+ (void)createFilterWithFilterType:(FILTER_MAIN_TYPE)filterType andCityKey:(NSString *)cityKey andCallBack:(void(^)(FILTER_CREATE_RESULT_STATUS resultStauts))callBack;

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
+ (FILTER_STATUS_TYPE)getFilterStatusWithType:(FILTER_MAIN_TYPE)filteType;

///查找给定类型和城市过滤器的状态
+ (FILTER_STATUS_TYPE)getFilterStatusWithType:(FILTER_MAIN_TYPE)filteType andCityKey:(NSString *)cityKey;

#pragma mark - 更新过滤器状态
/**
 *  @author             yangshengmeng, 15-02-04 18:02:19
 *
 *  @brief              更新所有过滤器的状态
 *
 *  @param filterStatus 给定的状态
 *  @param callBack     更新后的回调
 *
 *  @since              1.0.0
 */
+ (void)updateFilterStatusWithFilterType:(FILTER_MAIN_TYPE)filterType andFilterNewStatus:(FILTER_STATUS_TYPE)filterStatus andUpdateCallBack:(void(^)(BOOL isSuccess))callBack;

///更新指定类型和城市的过滤器
+ (void)updateFilterStatusWithFilterType:(FILTER_MAIN_TYPE)filterType andCityKey:(NSString *)cityKey andFilterNewStatus:(FILTER_STATUS_TYPE)filterStatus andUpdateCallBack:(void(^)(BOOL isSuccess))callBack;

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
+ (id)getLocalFilterWithType:(FILTER_MAIN_TYPE)filterType;

///获取指定类型和城市的过滤器
+ (id)getLocalFilterWithType:(FILTER_MAIN_TYPE)filterType andCityKey:(NSString *)cityKey;

///根据过滤器ID获取过滤器
+ (id)getLocalFilterWithFilterID:(NSString *)filterID;

///根据给定的类型和城市，返回过滤器
+ (id)getLocalFilterWithFilterID:(NSString *)filterID andCityKey:(NSString *)cityKey;

#pragma mark - 更新过滤器
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
+ (void)updateFilterWithType:(FILTER_MAIN_TYPE)filterType andFilterDataModel:(QSFilterDataModel *)filterModel andUpdateCallBack:(void(^)(BOOL isSuccess))callBack;

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
+ (NSDictionary *)getHouseListRequestParams:(FILTER_MAIN_TYPE)filterType;

///根据过滤器的类型和城市，创建过滤的请求参数
+ (NSDictionary *)getHouseListRequestParams:(FILTER_MAIN_TYPE)filterType andCityKey:(NSString *)cityKey;

@end
