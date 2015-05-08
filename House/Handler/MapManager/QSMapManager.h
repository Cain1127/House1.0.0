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
+ (void)getUserLocation:(void (^)(BOOL isLocationSuccess,double longitude,double latitude))callBack;

/*!
 *  @author wangshupeng, 15-04-29 15:04:26
 *
 *  @brief  获取当前用户位置的地理名称,目前返回市、区、街道(可选返回详细地址)
 *
 *  @param callBack 用户地理名称
 *
 *  @since 1.0.0
 */
+ (void)getUserLocationPlaceName:(void (^)(BOOL isLocationSuccess, NSString *placeName))callBack;

/*!
 *  @author             wangshupeng, 15-05-08 15:05:47
 *
 *  @brief              搜索给定中心点周边关键字的配套信息
 *
 *  @param searchKey    搜索关键字：为空或无效，不进行搜索
 *  @param longitude    经度
 *  @param latitude     纬度
 *  @param callBack     搜索完成后的回调
 *
 *  @since              1.0.0
 */
+ (void)searchTheSurroundingFacilities:(NSString *)searchKey andCenterLongitude:(NSString *)longitude andCenterLatitude:(NSString *)latitude andCallBack:(void(^)(BOOL isSuccess,NSString* resultInfo,NSString *num))callBack;

@end
