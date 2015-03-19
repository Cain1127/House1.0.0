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
@class QSCommunityHouseDetailDataModel;
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
+ (NSArray *)getLocalCollectedDataSourceWithType:(FILTER_MAIN_TYPE)type;

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
+ (NSArray *)getUncommitedCollectedDataSource:(FILTER_MAIN_TYPE)type;

/**
 *  @author                 yangshengmeng, 15-03-19 15:03:27
 *
 *  @brief                  查询给定类型和ID的收藏/分享是否存在，存在-YES
 *
 *  @param collectedID      收藏/分享的ID
 *  @param collectedType    收藏/分享类型
 *
 *  @return                 存在-YES
 *
 *  @since                  1.0.0
 */
+ (BOOL)checkCollectedDataWithID:(NSString *)collectedID andCollectedType:(FILTER_MAIN_TYPE)collectedType;
+ (QSCommunityHouseDetailDataModel *)searchCollectedDataWithID:(NSString *)collectedID andCollectedType:(FILTER_MAIN_TYPE)collectedType;

/**
 *  @author             yangshengmeng, 15-03-19 11:03:29
 *
 *  @brief              保存给定的关注或收藏数据信息
 *
 *  @param dataSource   数据的集合
 *  @param dataType     类型
 *  @param callBack     保存后的回调
 *
 *
 *  @since              1.0.0
 */
+ (void)saveCollectedDataSource:(NSArray *)dataSource  andCollectedType:(FILTER_MAIN_TYPE)dataType andCallBack:(void(^)(BOOL flag))callBack;

/**
 *  @author                 yangshengmeng, 15-03-19 11:03:24
 *
 *  @brief                  保存收藏/关注信息
 *
 *  @param collectedModel   数据模型
 *  @param dataType         数据分类：小区、新房、二手房等
 *  @param callBack         保存后的回调
 *
 *
 *  @since                  1.0.0
 */
+ (void)saveCollectedDataWithModel:(id)collectedModel andCollectedType:(FILTER_MAIN_TYPE)dataType andCallBack:(void(^)(BOOL flag))callBack;

/**
 *  @author                 yangshengmeng, 15-03-19 19:03:11
 *
 *  @brief                  删除给定的收藏/分享数据
 *
 *  @param collectedModel   收藏的数据模型
 *  @param isSyserver       是否已同步服务端
 *  @param dataType         类型
 *  @param callBack         删除后的回调
 *
 *  @since                  1.0.0
 */
+ (void)deleteCollectedDataWithID:(NSString *)collectedID isSyServer:(BOOL)isSyserver andCollectedType:(FILTER_MAIN_TYPE)dataType andCallBack:(void(^)(BOOL flag))callBack;

@end
