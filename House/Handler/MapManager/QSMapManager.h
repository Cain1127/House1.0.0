//
//  QSMapManager.h
//  SunTry
//
//  Created by 王树朋 on 15/1/30.
//  Copyright (c) 2015年 7tonline. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @author wangshupeng, 15-01-29 18:01:11
 *
 *  @brief  地图使用管理器
 *
 *  @since  1.0.0
 */
@interface QSMapManager : NSObject

/*!
 *  @author wangshupeng, 15-04-28 09:04:55
 *
 *  @brief  单例创建
 *
 *  @return 地图管理者
 *
 *  @since 1.0.0
 */
+ (QSMapManager *)shareMapManager;

/*!
 *  @author wangshupeng, 15-04-29 15:04:35
 *
 *  @brief  获取当前用户经纬度
 *
 *  @param callBack 经纬度
 *
 *  @since 1.0.0
 */
+(void)getUserLocation:(void (^)(BOOL isLocationSuccess,double longitude,double latitude))callBack;

/*!
 *  @author wangshupeng, 15-04-29 15:04:26
 *
 *  @brief  获取当前用户位置的地理名称,目前返回市、区、街道(可选返回详细地址)
 *
 *  @param callBack 用户地理名称
 *
 *  @since 1.0.0
 */
+(void)getUserLocationPlaceName:(void (^)(BOOL isLocationSuccess, NSString *placeName))callBack;

/*!
 *  @author wangshupeng, 15-04-01 18:04:36
 *
 *  @brief  初始化周边地址与经纬度信息
 *
 *  @param address      搜索信息
 *  @param coordinate_x 经度
 *  @param coordinate_y 纬度
 *
 *  @return 周边服务信息
 *
 *  @since 1.0.0
 */
+(void)updateNearSearchModel:(NSString *)searchInfo  andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y andCallBack:(void(^)(NSString* resultInfo,NSString *num))callBack;

@end
