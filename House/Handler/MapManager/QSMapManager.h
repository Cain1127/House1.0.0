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
 *  @author wangshupeng, 15-01-29 18:01:37
 *
 *  @brief  返回地图管理器
 *
 *  @return 返回当前地图管理器
 *
 *  @since  1.0.0
 */
//+ (instancetype)shareMapManager;

/*!
 *  @author wangshupeng, 15-01-29 18:01:14
 *
 *  @brief  获取当前用户的当前位置信息
 *
 *  @since  1.0.0
 */
- (void)getUserLocation:(void (^)(BOOL isLocalSuccess,NSString *placename))CallBack;

///用户地理位置定位的回调
@property (nonatomic,copy) void(^userPlacenameCallBack)(BOOL isLocalSuccess,NSString *placename);



///用户经纬度位置定位的回调
-(void)startUserLocation:(void(^)(BOOL isLocalSuccess,double longitude,double latitude))callBack;

@property (nonatomic,copy) void(^userLoationCallBack)(BOOL isLocalSuccess,double longitude,double latitude);

@end
