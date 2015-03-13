//
//  QSCoreDataManager+House.h
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-01-27 17:01:29
 *
 *  @brief  房子相关CoreData数据操作
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager (House)

/**
 *  @author yangshengmeng, 15-01-27 17:01:17
 *
 *  @brief  获取本地配置的户型数据
 *
 *  @return 返回户型数据
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseType;

/**
 *  @author yangshengmeng, 15-02-02 09:02:41
 *
 *  @brief  获取房子售价的类型
 *
 *  @return 返回售价类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseSalePriceType;

/**
 *  @author yangshengmeng, 15-03-06 15:03:43
 *
 *  @brief  返回房子的均价类型数据
 *
 *  @return 返回均价数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseAverageSalePriceType;

/**
 *  @author yangshengmeng, 15-02-02 09:02:16
 *
 *  @brief  获取房子面积类型列表数据
 *
 *  @return 返回房子面积类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseAreaType;

/**
 *  @author yangshengmeng, 15-02-02 09:02:48
 *
 *  @brief  获取房子出租的方式类型
 *
 *  @return 返回出租方式类型列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentType;

/**
 *  @author yangshengmeng, 15-02-02 09:02:29
 *
 *  @brief  返回出租房的租金类型列表
 *
 *  @return 返回类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentPriceType;

/**
 *  @author yangshengmeng, 15-02-02 09:02:44
 *
 *  @brief  获取出租房的租金支付方式选择项
 *
 *  @return 返回租金支付方式选择项数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentPayType;

/**
 *  @author yangshengmeng, 15-02-02 10:02:46
 *
 *  @brief  获取房子的装修类型
 *
 *  @return 返回房子装修类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseDecorationType;
+ (NSString *)getHouseDecorationTypeWithKey:(NSString *)decorationKey;

/**
 *  @author yangshengmeng, 15-02-02 10:02:15
 *
 *  @brief  获取房子朝向类型数据
 *
 *  @return 返回房子朝向类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseFaceType;
+ (NSString *)getHouseFaceTypeWithKey:(NSString *)decorationKey;

/**
 *  @author yangshengmeng, 15-02-02 10:02:25
 *
 *  @brief  获取房子的楼层类型数据
 *
 *  @return 返回房子楼层类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseFloorType;

/**
 *  @author yangshengmeng, 15-02-02 10:02:22
 *
 *  @brief  获取房子的产权年限数据
 *
 *  @return 返回产权选择项数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHousePropertyRightType;

/**
 *  @author yangshengmeng, 15-02-05 14:02:40
 *
 *  @brief  获取房子的房龄类型数组
 *
 *  @return 返回房龄数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseUsedYearType;

/**
 *  @author yangshengmeng, 15-01-29 15:01:06
 *
 *  @brief  返回房子列表中主要过滤类型
 *
 *  @return 返回类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseListMainType;
+ (id)getHouseListMainTypeModelWithID:(NSString *)typeID;

/**
 *  @author yangshengmeng, 15-02-02 09:02:31
 *
 *  @brief  获取房子的物业类型
 *
 *  @return 返回可以选择的物业类型
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseTradeType;
+ (NSString *)getHouseTradeTypeWithKey:(NSString *)tradeKey;

/**
 *  @author yangshengmeng, 15-01-27 17:01:23
 *
 *  @brief  返回购房目的数组
 *
 *  @return 返回数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getPurpostPerchaseType;
+ (NSString *)getPerpostPerchaseTypeWithKey:(NSString *)perpostKey;

/**
 *  @author     yangshengmeng, 15-02-12 13:02:13
 *
 *  @brief      查询对应特色标签的值
 *
 *  @param key  标签的key
 *
 *  @return     返回对应标签的值
 *
 *  @since      1.0.0
 */
+ (NSString *)getHouseFeatureWithKey:(NSString *)key andFilterType:(FILTER_MAIN_TYPE)listType;

@end
