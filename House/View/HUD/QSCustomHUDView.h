//
//  QSCustomHUDView.h
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-01-27 12:01:16
 *
 *  @brief  自定义HUD
 *
 *  @since  1.0.0
 */
@interface QSCustomHUDView : UIView

/**
 *  @author yangshengmeng, 15-01-27 12:01:41
 *
 *  @brief  显示自定义的HUD
 *
 *  @return 返回当前显示的HUD
 *
 *  @since  1.0.0
 */
+ (instancetype)showCustomHUD;

/**
 *  @author     yangshengmeng, 15-01-27 13:01:03
 *
 *  @brief      显示一个自定义的HUD，并且显示给定的提示信息
 *
 *  @param tips 给定的提示信息
 *
 *  @return     返回当前显示的HUD
 *
 *  @since      1.0.0
 */
+ (instancetype)showCustomHUDWithTips:(NSString *)tips;

/**
 *  @author             yangshengmeng, 15-01-27 13:01:48
 *
 *  @brief              显示一个有前置提示信息的自定义HUD
 *
 *  @param tips         主要提示信息
 *  @param headerTips   前置提示信息
 *
 *  @return             返回当前显示的HUD
 *
 *  @since              1.0.0
 */
+ (instancetype)showCustomHUDWithTips:(NSString *)tips andHeaderTips:(NSString *)headerTips;

/**
 *  @author yangshengmeng, 15-01-27 14:01:58
 *
 *  @brief  开始自定义HUD的动画
 *
 *  @since  1.0.0
 */
- (void)startCustomHUDAnimination;

/**
 *  @author yangshengmeng, 15-01-27 13:01:17
 *
 *  @brief  隐藏自定义HUD
 *
 *  @since  1.0.0
 */
- (void)hiddenCustomHUD;

/**
 *  @author             yangshengmeng, 15-01-27 13:01:32
 *
 *  @brief              隐藏自定义HUD，并且移除前显示给定的信息
 *
 *  @param footerTips   移除前显示的提示信息
 *
 *  @since              1.0.0
 */
- (void)hiddenCustomHUDWithFooterTips:(NSString *)footerTips;

@end
