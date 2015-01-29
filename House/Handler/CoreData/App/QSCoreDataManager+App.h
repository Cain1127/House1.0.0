//
//  QSCoreDataManager+App.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-01-21 20:01:56
 *
 *  @brief  应用相关的配置信息CoreData操作
 *
 *  @since  1.0.0
 */
@class QSConfigurationDataModel;
@interface QSCoreDataManager (App)

/**
 *  @author yangshengmeng, 15-01-26 12:01:37
 *
 *  @brief  获取当前应用是否第一次进入的状态：YES-第一次进入
 *
 *  @return 返回状态
 *
 *  @since  1.0.0
 */
+ (BOOL)getApplicationIsFirstLaunchStatus;
///更新是否第一次运行的状态
+ (BOOL)updateApplicationIsFirstLaunchStatus:(NSString *)netStatus;

/**
 *  @author yangshengmeng, 15-01-22 15:01:26
 *
 *  @brief  获取当前可用token
 *
 *  @return 返回当前可用token
 *
 *  @since  1.0.0
 */
+ (NSString *)getApplicationCurrentToken;

/**
 *  @author yangshengmeng, 15-01-22 15:01:26
 *
 *  @brief  获取当前可用token
 *
 *  @return 返回当前可用token
 *
 *  @since  1.0.0
 */
+ (BOOL)updateApplicationCurrentToken:(NSString *)token;

/**
 *  @author yangshengmeng, 15-01-22 15:01:45
 *
 *  @brief  获取当前网络请求的tokenID
 *
 *  @return 返回当前可用的tokenID
 *
 *  @since  1.0.0
 */
+ (NSString *)getApplicationCurrentTokenID;

/**
 *  @author yangshengmeng, 15-01-22 15:01:45
 *
 *  @brief  获取当前网络请求的tokenID
 *
 *  @return 返回当前可用的tokenID
 *
 *  @since  1.0.0
 */
+ (BOOL)updateApplicationCurrentTokenID:(NSString *)tokenID;

/**
 *  @author         yangshengmeng, 15-01-22 16:01:43
 *
 *  @brief          更新应用配置信息版本
 *
 *  @param version  新版本
 *
 *  @return         返回是否更新成功
 *
 *  @since          1.0.0
 */
+ (BOOL)updateApplicationCurrentVersion:(NSString *)version;

/**
 *  @author             yangshengmeng, 15-01-28 16:01:46
 *
 *  @brief              获取给定区中的街道列表
 *
 *  @param districtKey  区的关键字
 *
 *  @return             返回街道选择列表
 *
 *  @since              1.0.0
 */
+ (NSArray *)getStreetListWithDistrictKey:(NSString *)districtKey;

/**
 *  @author yangshengmeng, 15-01-20 10:01:58
 *
 *  @brief  返回指定城市的可选区域列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getDistrictListWithCityKey:(NSString *)cityKey;

/**
 *  @author yangshengmeng, 15-01-20 10:01:47
 *
 *  @brief  返回城市列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getCityList;

/**
 *  @author yangshengmeng, 15-01-22 16:01:34
 *
 *  @brief  获取本地应用的配置信息版本数组
 *
 *  @return 返回配置信息数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getConfigurationList;

/**
 *  @author         yangshengmeng, 15-01-22 16:01:58
 *
 *  @brief          更新本地的配置信息版本
 *
 *  @param conList  新的配置信息版本
 *
 *  @return         返回是否更新成功
 *
 *  @since          1.0.0
 */
+ (BOOL)updateConfigurationList:(NSArray *)conList;

/**
 *  @author                 yangshengmeng, 15-01-26 15:01:28
 *
 *  @brief                  根据配置说明模型更新一个配置信息项，如若没有，则插入
 *
 *  @param confDataModel    配置说明信息的数据模型
 *
 *  @return                 返回更新标识：YES-更新成功
 *
 *  @since                  1.0.0
 */
+ (BOOL)updateConfigurationWithModel:(QSConfigurationDataModel *)confDataModel;

/**
 *  @author             yangshengmeng, 15-01-26 16:01:06
 *
 *  @brief              更新基础配置信息
 *
 *  @param BaseConList  配置数组
 *
 *  @return             返回是否配置成功
 *
 *  @since              1.0.0
 */
+ (BOOL)updateBaseConfigurationList:(NSArray *)baseConList andKey:(NSString *)key;

/**
 *  @author yangshengmeng, 15-01-23 14:01:22
 *
 *  @brief  获取本地是否已配置有过滤器
 *
 *  @return 返回配置情况：YES-已配置
 *
 *  @since  1.0.0
 */
+ (BOOL)getLocalFilterSettingFlag;

@end
