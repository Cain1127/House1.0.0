//
//  QSCommunityDetailViewController.h
//  House
//
//  Created by ysmeng on 15/3/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSCommunityDetailViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-03-12 16:03:11
 *
 *  @brief              创建小区详情页面
 *
 *  @param title        标题
 *  @param communityID  小区ID
 *  @param commendNum   小区详情中，推荐房源的个数
 *  @param houseType    是推荐二手房/出租房
 *
 *  @return             返回小区详情页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andCommunityID:(NSString *)communityID andCommendNum:(NSString *)commendNum andHouseType:(NSString *)houseType;

@end
