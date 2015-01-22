//
//  QSCoreDataManager+SearchHistory.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+SearchHistory.h"

@implementation QSCoreDataManager (SearchHistory)

#pragma mark - 本地搜索历史记录相关操作
/**
 *  @author yangshengmeng, 15-01-21 18:01:15
 *
 *  @brief  获取本地搜索历史
 *
 *  @return 返回搜索历史数组：数组中的模型为-QSFDangJiaSearchHistoryDataModel
 *
 *  @since  1.0.0
 */
+ (NSArray *)getLocalSearchHistory
{
    
    return [self getDataListWithKey:@"QSCDLocalSearchHistoryDataModel" andSortKeyWord:@"search_time" andAscend:YES];
    
}

///插入一个新的搜索历史
+ (BOOL)addLocalSearchHistory:(QSCDLocalSearchHistoryDataModel *)model
{
    
    return [self insertEntityWithEntityName:@"QSCDLocalSearchHistoryDataModel" andCoreDataModel:model];
    
}

///清空本地搜索历史
+ (BOOL)clearLocalSearchHistory
{
    
    return [self clearDataListWithEntityName:@"QSCDLocalSearchHistoryDataModel"];
    
}

@end
