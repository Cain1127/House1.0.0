//
//  QSTabBarViewController.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-01-17 13:01:39
 *
 *  @brief  应用的tabbar控制器
 *
 *  @since  1.0.0
 */
@interface QSTabBarViewController : UITabBarController

/**
 *  @author         yangshengmeng, 15-02-04 18:02:39
 *
 *  @brief          根据给定的下标初始化主页面，并且首先显示指定的下标VC
 *
 *  @param index    当前显示的下标
 *
 *  @return         返回当前创建的tabbar控制器
 *
 *  @since          1.0.0
 */
- (instancetype)initWithCurrentIndex:(int)index;

/**
 *  @author     yangshengmeng, 15-01-17 23:01:01
 *
 *  @brief      隐藏/显示tabbar：flag：YES-隐藏 NO-显示
 *
 *  @param flag YES-隐藏，NO-显示
 *
 *  @since      1.0.0
 */
- (void)hiddenBottomTabbar:(BOOL)flag;

@end
