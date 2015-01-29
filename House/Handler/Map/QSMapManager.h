//
//  QSMapManager.h
//  House
//
//  Created by 王树朋 on 15/1/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
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
+ (instancetype)shareMapManager;

/*!
 *  @author wangshupeng, 15-01-29 18:01:14
 *
 *  @brief  获取当前用户的当前位置信息
 *
 *  @since  1.0.0
 */
+ (void)getUserLocation;

@end
