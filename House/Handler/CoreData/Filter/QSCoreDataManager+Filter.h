//
//  QSCoreDataManager+Filter.h
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

///初始化时，过滤器类型
typedef enum
{

    fFilterMainTypeRentalHouse = 99,//!<找出租房的过滤器
    fFilterMainTypeSecondHouse,     //!<二手房的过滤器

}FILTER_MAIN_TYPE;

/**
 *  @author yangshengmeng, 15-02-04 14:02:50
 *
 *  @brief  过滤器相关操作
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager (Filter)

/**
 *  @author yangshengmeng, 15-02-04 15:02:25
 *
 *  @brief  初始化一个出租房的过滤器
 *
 *  @return 返回初始化是否成功
 *
 *  @since  1.0.0
 */
+ (BOOL)initRentalHouseFilter;

/**
 *  @author yangshengmeng, 15-02-04 15:02:02
 *
 *  @brief  初始化一个二手房的过滤器
 *
 *  @return 返回是否初始化成功
 *
 *  @since  1.0.0
 */
+ (BOOL)initSecondHandHouseFilter;

@end
