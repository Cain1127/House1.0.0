//
//  QSCoreDataManager+Collected.h
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-03-12 13:03:24
 *
 *  @brief  收藏小区的处理器
 *
 *  @since  1.0.0
 */
@class QSCollectedCommunityDataModel;
@interface QSCoreDataManager (Collected)

/**
 *  @author yangshengmeng, 15-03-12 14:03:09
 *
 *  @brief  返回本地保存的数据列表
 *
 *  @return 返回本地保存的数据列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getLocalCollectedDataSource;

/**
 *  @author yangshengmeng, 15-03-12 14:03:30
 *
 *  @brief  查询未上传服务端的收藏记录
 *
 *  @return 返回本地保存中，未上传服务端的收藏记录
 *
 *  @since  1.0.0
 */
+ (NSArray *)getUncommitedCollectedDataSource;

/**
 *  @author             yangshengmeng, 15-03-12 14:03:24
 *
 *  @brief              保存收藏的数据
 *
 *  @param dataSource   内存中的收藏数据
 *
 *  @return             返回保存是否成功
 *
 *  @since              1.0.0
 */
+ (BOOL)saveCollectedDataSource:(NSArray *)dataSource;

/**
 *  @author                 yangshengmeng, 15-03-12 14:03:28
 *
 *  @brief                  保存给定的一个收藏记录
 *
 *  @param collectedModel   收藏记录的数据模型
 *
 *  @return                 返回是否保存成功
 *
 *  @since                  1.0.0
 */
+ (BOOL)saveCollectedDataWithModel:(QSCollectedCommunityDataModel *)collectedModel;

@end
