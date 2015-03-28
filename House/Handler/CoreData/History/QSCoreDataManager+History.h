//
//  QSCoreDataManager+History.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

@interface QSCoreDataManager (History)

/**
 *  @author yangshengmeng, 15-03-12 14:03:09
 *
 *  @brief  根据房源类型，返回本地保存的浏览数据列表
 *
 *  @return 返回本地保存的数据列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getLocalHistoryDataSourceWithType:(FILTER_MAIN_TYPE)type;

/**
 *  @author                 yangshengmeng, 15-03-19 11:03:24
 *
 *  @brief                  保存浏览记录
 *
 *  @param collectedModel   需要保存的数据模型：二手房详情，新房详情，出租房详情
 *  @param dataType         数据分类：小区、新房、二手房等
 *  @param callBack         保存后的回调
 *
 *
 *  @since                  1.0.0
 */
+ (void)saveHistoryDataWithModel:(id)collectedModel andCollectedType:(FILTER_MAIN_TYPE)dataType andCallBack:(void(^)(BOOL flag))callBack;

@end
