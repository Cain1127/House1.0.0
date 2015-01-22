//
//  QSCoreDataManager+SearchHistory.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"
#import "QSCDLocalSearchHistoryDataModel.h"

/**
 *  @author yangshengmeng, 15-01-21 20:01:43
 *
 *  @brief  本地搜索历史数据操作类型
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager (SearchHistory)

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
+ (BOOL)addLocalSearchHistory:(QSCDLocalSearchHistoryDataModel *)model;

///清空本地搜索历史
+ (BOOL)clearLocalSearchHistory;

@end
