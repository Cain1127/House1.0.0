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
+ (NSString *)getHouseTypeValueWithKey:(NSString *)houseTypeKey;

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
+ (NSString *)getHouseSalePriceValueWithKey:(NSString *)priceKey;

/**
 *  @author yangshengmeng, 15-03-25 17:03:16
 *
 *  @brief  是否可以议价选择项
 *
 *  @return 返回选项数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseIsNegotiatedPriceType;

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
+ (NSString *)getHouseAreaTypeWithKey:(NSString *)areaKey;

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
+ (NSString *)getHouseRentPriceValueWithKey:(NSString *)rentKey;

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
+ (NSString *)getHouseRentTypeWithKey:(NSString *)payKey;

/**
 *  @author yangshengmeng, 15-04-02 10:04:49
 *
 *  @brief  返回出租房的限制条件选择项
 *
 *  @return 返回出租房的限制条件选择项
 *
 *  @since  1.0.0
 */
+ (NSArray *)getRentHouseLimitedTypes;
+ (NSString *)getRentHouseLimitedTypeWithKey:(NSString *)limitedKey;

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
+ (NSString *)getHouseFloorTypeWithKey:(NSString *)floorKey;

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
+ (NSString *)getHouseUsedYearTypeWithKey:(NSString *)usedYearKey;

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
 *  @author yangshengmeng, 15-03-13 18:03:26
 *
 *  @brief  返回建筑结构信息
 *
 *  @return 所有建筑类型数据
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseBuildingStructureType;
+ (NSString *)getHouseBuildingStructureTypeWithKey:(NSString *)key;

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
+ (NSArray *)getHouseFeatureListWithType:(FILTER_MAIN_TYPE)filterType;
+ (NSString *)getHouseFeatureWithKey:(NSString *)key andFilterType:(FILTER_MAIN_TYPE)listType;

/**
 *  @author yangshengmeng, 15-03-26 11:03:05
 *
 *  @brief  返回二手房的房屋性质
 *
 *  @return 返回二手房的房屋性质
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseNatureTypes;

/**
 *  @author yangshengmeng, 15-03-26 11:03:21
 *
 *  @brief  返回建筑年代选择项
 *
 *  @return 返回建筑年代所有数据
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseBuildingYearTypes;

/**
 *  @author             yangshengmeng, 15-03-26 12:03:22
 *
 *  @brief              返回不同房源类型的配套信息
 *
 *  @param filterType   房源类型
 *
 *  @return             返回对应类型的配套信息
 *
 *  @since              1.0.0
 */
+ (NSArray *)getHouseInstallationTypes:(FILTER_MAIN_TYPE)filterType;

/**
 *  @author yangshengmeng, 15-03-27 12:03:37
 *
 *  @brief  返回星期选择项
 *
 *  @return 返回星期选择项
 *
 *  @since  1.0.0
 */
+ (NSArray *)getWeeksPickedType;

/**
 *  @author yangshengmeng, 15-03-27 12:03:37
 *
 *  @brief  出租房的状态
 *
 *  @return 返回出租房的状态
 *
 *  @since  1.0.0
 */
+ (NSArray *)getRentHouseStatusTypes;

/**
 *  @author yangshengmeng, 15-03-27 12:03:37
 *
 *  @brief  房子的物业管理费
 *
 *  @return 返回出房子的物业管理费
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHousePropertyManagementFees;

/**
 *  @author yangshengmeng, 15-03-27 12:03:37
 *
 *  @brief  出租房的入住时间
 *
 *  @return 返回出租房的可入住时间选择项
 *
 *  @since  1.0.0
 */
+ (NSArray *)getRentHouseLeadTimeTyps;
+ (NSString *)getRentHouseLeadTimeTypeWithKey:(NSString *)key;

@end
