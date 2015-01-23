//
//  QSCoreDataManager+User.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-01-22 15:01:52
 *
 *  @brief  用户信息CoreData读取类型
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager (User)

/**
 *  @author yangshengmeng, 15-01-22 15:01:25
 *
 *  @brief  获取当前用户ID
 *
 *  @return 返回当前用户ID
 *
 *  @since  1.0.0
 */
+ (NSString *)getUserID;

/**
 *  @author yangshengmeng, 15-01-23 10:01:47
 *
 *  @brief  返回当前用户所在的城市
 *
 *  @return 返回城市
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserCity;

@end
