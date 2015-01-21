//
//  QSCoreDataManager+Advert.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-01-21 20:01:13
 *
 *  @brief  广告相关的相关本地操作
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager (Advert)

/**
 *  @author yangshengmeng, 15-01-20 00:01:14
 *
 *  @brief  返回最后显示广告的时间
 *
 *  @return 返回上一次显示广告的时间日期整数字符串
 *
 *  @since  1.0.0
 */
+ (NSString *)getAdvertLastShowTime;

@end
