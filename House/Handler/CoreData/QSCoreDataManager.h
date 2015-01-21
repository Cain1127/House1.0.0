//
//  QSCoreDataManager.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author yangshengmeng, 15-01-21 18:01:59
 *
 *  @brief  CoreData操作控制器
 *
 *  @since  1.0.0
 */
@class QSFDangJiaSearchHistoryDataModel;
@interface QSCoreDataManager : NSObject

/**
 *  @author yangshengmeng, 15-01-20 10:01:58
 *
 *  @brief  返回指定城市的可选区域列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getDistrictWithCity:(NSString *)city;

/**
 *  @author yangshengmeng, 15-01-20 10:01:47
 *
 *  @brief  返回城市列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getCityList;

/**
 *  @author yangshengmeng, 15-01-20 10:01:15
 *
 *  @brief  获取应用指引状态：YES-已经指引过，NO-需要重新指引
 *
 *  @since  1.0.0
 */
+ (BOOL)getAppGuideIndexStatus;

/**
 *  @author yangshengmeng, 15-01-20 00:01:14
 *
 *  @brief  返回最后显示广告的时间
 *
 *  @return 返回上一次显示广告的时间日期整数字符串
 *
 *  @since  1.0.0
 */
+ (NSString *)getAdvertLastShowTime;

/**
 *  @author yangshengmeng, 15-01-21 18:01:15
 *
 *  @brief  获取本地搜索历史
 *
 *  @return 返回搜索历史数组：数组中的模型为-QSFDangJiaSearchHistoryDataModel
 *
 *  @since  1.0.0
 */
+ (NSArray *)getLocalSearchHistory;

///插入一个新的搜索历史
+ (BOOL)addLocalSearchHistory:(QSFDangJiaSearchHistoryDataModel *)model;

///清空本地搜索历史
+ (BOOL)clearLocalSearchHistory;

@end
