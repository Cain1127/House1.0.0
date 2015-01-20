//
//  QSHeaderViewController.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCoreDataManager.h"

/**
 *  @author yangshengmeng, 15-01-20 10:01:07
 *
 *  @brief  本VC只用来导入全局使用的头文件
 *
 *  @since  1.0.0
 */
@interface QSHeaderViewController : UIViewController

#pragma mark - UI搭建
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

#pragma mark - 检测网络
/**
 *  @author yangshengmeng, 15-01-20 12:01:16
 *
 *  @brief  判断当前网络状态是否可用，是wifi还是3G/4G
 *
 *  @return 返回网络状态
 *
 *  @since  1.0.0
 */
- (NETWORK_STATUS)currentReachabilityStatus;

#pragma mark - window加载临时VC
/**
 *  @author         yangshengmeng, 15-01-20 16:01:54
 *
 *  @brief          修改当前window的根视图
 *
 *  @param newVC    新的视图
 *
 *  @since          1.0.0
 */
- (void)changeWindowRootViewController:(UIViewController *)newVC;

@end
