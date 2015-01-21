//
//  QSCoreDataManager+Guide.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-01-21 20:01:17
 *
 *  @brief  指引页相关信息CoreData操作
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager (Guide)

/**
 *  @author yangshengmeng, 15-01-20 10:01:15
 *
 *  @brief  获取应用指引状态：YES-已经指引过，NO-需要重新指引
 *
 *  @since  1.0.0
 */
+ (BOOL)getAppGuideIndexStatus;

@end
