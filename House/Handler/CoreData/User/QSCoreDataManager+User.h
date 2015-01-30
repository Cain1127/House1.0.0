//
//  QSCoreDataManager+User.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-01-22 15:01:52
 *
 *  @brief  用户信息CoreData读取类型
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager (User)

/**
 *  @author yangshengmeng, 15-01-22 15:01:25
 *
 *  @brief  获取当前用户ID
 *
 *  @return 返回当前用户ID
 *
 *  @since  1.0.0
 */
+ (NSString *)getUserID;

/**
 *  @author yangshengmeng, 15-01-23 10:01:47
 *
 *  @brief  返回当前用户所在的城市
 *
 *  @return 返回城市
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserCity;
+ (NSString *)getCurrentUserCityKey;
+ (BOOL)updateCurrentUserCity:(NSString *)city;

/**
 *  @author yangshengmeng, 15-01-23 10:01:47
 *
 *  @brief  返回当前用户当前所在的区
 *
 *  @return 返回区
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserDistrict;
+ (BOOL)updateCurrentUserDistrict:(NSString *)district;

/**
 *  @author yangshengmeng, 15-01-28 17:01:56
 *
 *  @brief  获取当前用户当前所在的街道
 *
 *  @return 返回街道
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserStreet;
+ (BOOL)updateCurrentUserStreet:(NSString *)street;

/**
 *  @author yangshengmeng, 15-01-27 12:01:42
 *
 *  @brief  返回当前用户的权限类型
 *
 *  @return 返回用户权限类型
 *
 *  @since  1.0.0
 */
+ (USER_COUNT_TYPE)getCurrentUserCountType;

/**
 *  @author         yangshengmeng, 15-01-27 12:01:41
 *
 *  @brief          更新当前用户的类型
 *
 *  @param userType 用户类型
 *
 *  @return         返回更新是否成功
 *
 *  @since          1.0.0
 */
+ (BOOL)updateCurrentUserCountType:(USER_COUNT_TYPE)userType;

@end
