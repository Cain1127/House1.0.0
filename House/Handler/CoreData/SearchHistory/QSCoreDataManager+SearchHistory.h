//
//  QSCoreDataManager+SearchHistory.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-01-21 20:01:43
 *
 *  @brief  本地搜索历史数据操作类型
 *
 *  @since  1.0.0
 */
@class QSLocalSearchHistoryDataModel;
@interface QSCoreDataManager (SearchHistory)

/**
 *  @author             yangshengmeng, 15-01-21 18:01:15
 *
 *  @brief              获取本地搜索历史
 *
 *  @param  houseType   房源类型
 *
 *  @return             返回搜索历史数组：数组中的模型为-QSFDangJiaSearchHistoryDataModel
 *
 *  @since              1.0.0
 */
+ (NSArray *)getLocalSearchHistoryWithHouseType:(FILTER_MAIN_TYPE)houseType;

///插入一个新的搜索历史
+ (void)addLocalSearchHistory:(QSLocalSearchHistoryDataModel *)model andCallBack:(void(^)(BOOL flag))callBack;

///清空本地搜索历史
+ (void)clearLocalSearchHistoryWithHouseType:(FILTER_MAIN_TYPE)houseType andCallBack:(void(^)(BOOL flag))callBack;

@end
