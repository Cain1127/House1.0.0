//
//  QSMasterViewController.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMasterViewController : UIViewController

/**
 *  @author yangshengmeng, 15-01-17 18:01:34
 *
 *  @brief  创建导航栏信息
 *
 *  @since  1.0.0
 */
- (void)createNavigationBarUI;

/**
 *  @author yangshengmeng, 15-01-17 18:01:50
 *
 *  @brief  创建底部tabbar信息
 *
 *  @since  1.0.0
 */
- (void)createBottomTabbar;

/**
 *  @author yangshengmeng, 15-01-17 18:01:06
 *
 *  @brief  创建主展示信息的UI
 *
 *  @since  1.0.0
 */
- (void)createMainShowUI;

@end
