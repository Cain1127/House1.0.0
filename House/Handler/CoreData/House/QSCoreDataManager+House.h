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
 *  @author yangshengmeng, 15-01-29 15:01:06
 *
 *  @brief  返回房子列表中主要过滤类型
 *
 *  @return 返回类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseListMainType;

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

@end
