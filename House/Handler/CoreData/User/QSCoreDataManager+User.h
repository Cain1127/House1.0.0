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
@class QSCDBaseConfigurationDataModel;
@class QSBaseConfigurationDataModel;
@class QSUserDataModel;
@interface QSCoreDataManager (User)

/**
 *  @author yangshengmeng, 15-02-09 16:02:21
 *
 *  @brief  判断是否已登录
 *
 *  @return 返回当前登录状态
 *
 *  @since  1.0.0
 */
+ (BOOL)isLogin;

/**
 *  @author yangshengmeng, 15-04-02 22:04:48
 *
 *  @brief  重新请求个人信息
 *
 *  @since  1.0.0
 */
+ (void)reloadUserInfoFromServer;
+ (void)logoutCurrentUserCount:(void(^)(BOOL isLogout))callBack;

/**
 *  @author     yangshengmeng, 15-03-14 12:03:47
 *
 *  @brief      更新用户登录状态
 *
 *  @param flag YES-已登录
 *
 *  @return     返回更新是否成功
 *
 *  @since      1.0.0
 */
+ (void)updateLoginStatus:(BOOL)flag andCallBack:(void(^)(BOOL flag))callBack;

/**
 *  @author             yangshengmeng, 15-03-14 12:03:48
 *
 *  @brief              保存当前用户登录的基本信息
 *
 *  @param userModel    用户数据模型
 *
 *  @since              1.0.0
 */
+ (void)saveLoginUserData:(QSUserDataModel *)userModel andCallBack:(void(^)(BOOL flag))callBack;
+ (QSUserDataModel *)getCurrentUserDataModel;

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
 *  @author yangshengmeng, 15-04-04 23:04:36
 *
 *  @brief  获取当前用户的类型
 *
 *  @return 返回当前用户的类型
 *
 *  @since  1.0.0
 */
+ (USER_COUNT_TYPE)getUserType;

/**
 *  @author yangshengmeng, 15-04-16 11:04:50
 *
 *  @brief  获取当前用户发布的物业总数
 *
 *  @return 返回当前用户发布物业的总数
 *
 *  @since  1.0.0
 */
+ (int)getUserPropertySumCount;
+ (int)getUserRentPropertySumCount;
+ (int)getUserSalePropertySumCount;

/**
 *  @author yangshengmeng, 15-03-16 10:03:37
 *
 *  @brief  返回登录账号
 *
 *  @return 返回当前保存的登录账号
 *
 *  @since  1.0.0
 */
+ (NSString *)getLoginCount;
+ (void)saveLoginCount:(NSString *)count andCallBack:(void(^)(BOOL flag))callBack;

/**
 *  @author yangshengmeng, 15-03-16 10:03:56
 *
 *  @brief  返回当前保存的登录密码
 *
 *  @return 返回登录密码
 *
 *  @since  1.0.0
 */
+ (NSString *)getLoginPassword;
+ (void)saveLoginPassword:(NSString *)psw andCallBack:(void(^)(BOOL flag))callBack;

/**
 *  @author yangshengmeng, 15-03-16 11:03:21
 *
 *  @brief  查询当前用户的手机号码
 *
 *  @return 返回当前查询的手机号码结果
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserPhone;

/**
 *  @author yangshengmeng, 15-01-23 10:01:47
 *
 *  @brief  返回当前用户所在的城市
 *
 *  @return 返回城市
 *
 *  @since  1.0.0
 */
+ (QSBaseConfigurationDataModel *)getCurrentUserCityModel;
+ (NSString *)getCurrentUserCity;
+ (NSString *)getCurrentUserCityKey;
+ (BOOL)updateCurrentUserCity:(QSCDBaseConfigurationDataModel *)cityModel;

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
 *  @author yangshengmeng, 15-02-05 10:02:10
 *
 *  @brief  获取当前用户默认过滤器:user_default_filter_id
 *
 *  @return 返回默认过滤器的ID
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserDefaultFilterID;
+ (void)updateCurrentUserDefaultFilter:(NSString *)filterID andCallBack:(void(^)(BOOL isSuccess))callBack;

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
