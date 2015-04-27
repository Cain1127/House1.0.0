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

+ (QSMapManager *)shareMapManager;

/*!
 *  @author wangshupeng, 15-04-01 18:04:36
 *
 *  @brief  初始化周边地址与经纬度信息
 *
 *  @param address      地址
 *  @param coordinate_x 经度
 *  @param coordinate_y 纬度
 *
 *  @return 周边信息地址与经纬度
 *
 *  @since 1.0.0
 */
//-(instancetype)initWithAddress:(NSString *)address andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y;

+(void)updateNearSearchModel:(NSString *)searchInfo  andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y andCallBack:(void(^)(NSString* resultInfo))callBack;

@end
