//
//  QSYAskRecommendSecondHouseViewController.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYAskRecommendSecondHouseViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-03 09:04:56
 *
 *  @brief              根据求购记录的ID，创建求购记录对应的推荐房源列表
 *
 *  @param recommendID  求购记录ID
 *
 *  @return             返回当前求购推荐房源的列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRecommendID:(NSString *)recommendID;

@end
