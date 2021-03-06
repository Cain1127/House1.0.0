//
//  QSLoginViewController.h
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

/**
 *  @author yangshengmeng, 15-01-24 12:01:32
 *
 *  @brief  登录主页面
 *
 *  @since  1.0.0
 */
@interface QSLoginViewController : QSTurnBackViewController

/**
 *  @author                 yangshengmeng, 15-03-13 14:03:11
 *
 *  @brief                  根据登录的回调，创建一个登录窗口
 *
 *  @param loginCallBack    登录成功后的回调
 *
 *  @return                 返回当前创建的登录窗口
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithCallBack:(void(^)(LOGIN_CHECK_ACTION_TYPE flag))loginCallBack;

/**
 *  @author yangshengmeng, 15-05-03 20:05:17
 *
 *  @brief  将本地浏览记录和服务端记录合并
 *
 *  @since  1.0.0
 */
+ (void)loadHistoryDataToServer;

/**
 *  @author yangshengmeng, 15-05-07 12:05:09
 *
 *  @brief  同步收藏二手房
 *
 *  @since  1.0.0
 */
+ (void)loadCollectedSecondHandHouseDataToServer;

/**
 *  @author yangshengmeng, 15-05-07 12:05:09
 *
 *  @brief  同步收藏出租房
 *
 *  @since  1.0.0
 */
+ (void)loadCollectedRentHouseDataToServer;

/**
 *  @author yangshengmeng, 15-05-07 12:05:09
 *
 *  @brief  同步收藏新房
 *
 *  @since  1.0.0
 */
+ (void)loadCollectedNewHouseDataToServer;

/**
 *  @author yangshengmeng, 15-05-07 12:05:09
 *
 *  @brief  同步关注小区
 *
 *  @since  1.0.0
 */
+ (void)loadIntentionCommunityDataToServer;

@end
