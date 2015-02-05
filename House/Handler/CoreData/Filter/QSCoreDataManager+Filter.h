//
//  QSCoreDataManager+Filter.h
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-02-04 14:02:50
 *
 *  @brief  过滤器相关操作
 *
 *  @since  1.0.0
 */
@class QSFilterDataModel;
@interface QSCoreDataManager (Filter)

/**
 *  @author yangshengmeng, 15-02-04 15:02:25
 *
 *  @brief  初始化一个出租房的过滤器
 *
 *  @return 返回初始化是否成功
 *
 *  @since  1.0.0
 */
+ (BOOL)initRentalHouseFilter;

/**
 *  @author yangshengmeng, 15-02-04 15:02:02
 *
 *  @brief  初始化一个二手房的过滤器
 *
 *  @return 返回是否初始化成功
 *
 *  @since  1.0.0
 */
+ (BOOL)initSecondHandHouseFilter;

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

@end
