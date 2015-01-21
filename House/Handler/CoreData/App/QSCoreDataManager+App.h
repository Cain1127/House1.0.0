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
@interface QSCoreDataManager (App)

/**
 *  @author yangshengmeng, 15-01-20 10:01:58
 *
 *  @brief  返回指定城市的可选区域列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getDistrictWithCity:(NSString *)city;

/**
 *  @author yangshengmeng, 15-01-20 10:01:47
 *
 *  @brief  返回城市列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getCityList;

@end
