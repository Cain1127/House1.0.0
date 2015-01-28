//
//  QSGuideHeaderViewController.h
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderViewController.h"

@interface QSGuideHeaderViewController : QSHeaderViewController

/**
 *  @author             yangshengmeng, 15-01-20 14:01:28
 *
 *  @brief              在指定的视图中添加顶部相关的子view
 *
 *  @param headerView   顶部视图的底view
 *
 *  @since              1.0.0
 */
- (void)createCustomGuideHeaderSubviewsUI:(UIView *)headerView;

/**
 *  @author     yangshengmeng, 15-01-20 14:01:51
 *
 *  @brief      在给定的视图上添加底部相关控件
 *
 *  @param view 底部控制
 *
 *  @since      1.0.0
 */
- (void)createCustomGuideFooterUI:(UIView *)view;

@end
