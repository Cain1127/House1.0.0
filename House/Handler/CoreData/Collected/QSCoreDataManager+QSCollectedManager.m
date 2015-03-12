//
//  QSCoreDataManager+QSCollectedManager.m
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+QSCollectedManager.h"

#import "QSCollectedCommunityDataModel.h"
#import "QSCDCollectedCommunityDataModel.h"

///收藏CoreData实体名
#define COREDATA_ENTITYNAME_COLLECTED @"QSCDCollectedCommunityDataModel"

@implementation QSCoreDataManager (QSCollectedManager)

/**
 *  @author yangshengmeng, 15-03-12 14:03:09
 *
 *  @brief  返回本地保存的数据列表
 *
 *  @return 返回本地保存的数据列表
 *
 *  @since  1.0.0
 */
- (NSArray *)getLocalCollectedDataSource
{

    return nil;

}

/**
 *  @author yangshengmeng, 15-03-12 14:03:30
 *
 *  @brief  查询未上传服务端的收藏记录
 *
 *  @return 返回本地保存中，未上传服务端的收藏记录
 *
 *  @since  1.0.0
 */
- (NSArray *)getUncommitedCollectedDataSource
{

    return nil;

}

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
- (BOOL)saveCollectedDataSource:(NSArray *)dataSource
{

    return YES;

}

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
- (BOOL)saveCollectedDataWithModel:(QSCollectedCommunityDataModel *)collectedModel
{

    return YES;

}

@end
