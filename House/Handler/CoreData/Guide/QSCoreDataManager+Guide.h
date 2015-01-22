//
//  QSCoreDataManager+Guide.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

///指引页状态：0-需要指引,1-不需要指引,2-无记录
typedef enum
{

    gGuideStatusNeedDispay = 0,     //!<需要显示指引页
    gGuideStatusUnneedDisplay,      //!<不需要显示指引页
    gGuideStatusNoRecord            //!<并未有相关配置信息

}GUIDE_STATUS;

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
+ (GUIDE_STATUS)getAppGuideIndexStatus;

/**
 *  @author             yangshengmeng, 15-01-21 23:01:40
 *
 *  @brief              更新指引页的阅读状态
 *
 *  @param guideStatus  指引页新状态
 *
 *  @return             返回更新是否成功
 *
 *  @since              1.0.0
 */
+ (BOOL)updateAppGuideIndexStatus:(GUIDE_STATUS)guideStatus;

@end
