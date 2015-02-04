//
//  QSCoreDataManager+Filter.m
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+Filter.h"

///过滤器信息的CoreData模型
#define COREDATA_ENTITYNAME_FILTER @"QSCDFilterDataModel"

@implementation QSCoreDataManager (Filter)

/**
 *  @author yangshengmeng, 15-02-04 15:02:25
 *
 *  @brief  初始化一个出租房的过滤器
 *
 *  @return 返回初始化是否成功
 *
 *  @since  1.0.0
 */
+ (BOOL)initRentalHouseFilter
{

    return YES;

}

/**
 *  @author yangshengmeng, 15-02-04 15:02:02
 *
 *  @brief  初始化一个二手房的过滤器
 *
 *  @return 返回是否初始化成功
 *
 *  @since  1.0.0
 */
+ (BOOL)initSecondHandHouseFilter
{

    return YES;

}

@end
