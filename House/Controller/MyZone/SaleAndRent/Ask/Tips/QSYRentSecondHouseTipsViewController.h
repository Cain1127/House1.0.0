//
//  QSYRentSecondHouseTipsViewController.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYRentSecondHouseTipsViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-03 09:04:42
 *
 *  @brief              根据求购记录的ID，创建发布成功提示页面
 *
 *  @param recommendID  求购记录的ID
 *
 *  @return             返回当前创建的发布成功提示页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRecommendID:(NSString *)recommendID;

@end
