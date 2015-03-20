//
//  QSMasterViewController.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderViewController.h"

///首页不同功能按钮的事件通知
static NSString *nHomeNewHouseActionNotification = @"nHomeNewHouseActionNotification";
static NSString *nHomeRentHouseActionNotification = @"nHomeRentHouseActionNotification";
static NSString *nHomeSecondHandHouseActionNotification = @"nHomeSecondHandHouseActionNotification";
static NSString *nHomeCommunityActionNotification = @"nHomeCommunityActionNotification";
static NSString *nHouseMapListFilterInfoChanggeActionNotification = @"nHouseMapListFilterInfoChanggeActionNotification";
static NSString *nHouseMapListFilterChanggeActionNotification = @"nHouseMapListFilterChanggeActionNotification";

///用户默认城市修改
static NSString *nUserDefaultCityChanged = @"nUserDefaultCityChanged";

@interface QSMasterViewController : QSHeaderViewController

#pragma mark - 导航栏设置
/**
 *  @author             yangshengmeng, 15-01-17 14:01:16
 *
 *  @brief              通过图片的名字，设置导航栏背景图片
 *
 *  @param imageName    背景图片名字
 *
 *  @since              1.0.0
 */
- (void)setNavigationBarBackgroudImageWithImageName:(NSString *)imageName;
- (void)setNavigationBarBackgroudColor:(UIColor *)color;

/**
 *  @author         yangshengmeng, 15-01-17 14:01:57
 *
 *  @brief          通过图片设置导航栏背景图片
 *
 *  @param image    图片
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarBackgroudImageWithImage:(UIImage *)image;

/**
 *  @author         yangshengmeng, 15-01-17 14:01:24
 *
 *  @brief          设置导航栏中间标题
 *
 *  @param title    标题
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarTitle:(NSString *)title;

/**
 *  @author         yangshengmeng, 15-01-17 14:01:42
 *
 *  @brief          添加一个自定义的中间视图
 *
 *  @param view     中间视图
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarMiddleView:(UIView *)view;

/**
 *  @author     yangshengmeng, 15-01-17 14:01:04
 *
 *  @brief      设置导航栏右侧视图
 *
 *  @param view 右侧显示视图
 *
 *  @since      1.0.0
 */
- (void)setNavigationBarRightView:(UIView *)view;

/**
 *  @author     yangshengmeng, 15-01-17 14:01:33
 *
 *  @brief      设置左侧显示视图
 *
 *  @param view 左侧视图
 *
 *  @since      1.0.0
 */
- (void)setNavigationBarLeftView:(UIView *)view;

/**
 *  @author     yangshengmeng, 15-02-10 15:02:45
 *
 *  @brief      底部分隔线是否添加
 *
 *  @param flag 标识：YES-显示，NO-添加
 *
 *  @since      1.0.0
 */
- (void)showBottomSeperationLine:(BOOL)flag;

/**
 *  @author     yangshengmeng, 15-02-06 10:02:20
 *
 *  @brief      显示暂无记录提示框
 *
 *  @param flag 是否显示：YES-显示,NO-移除
 *
 *  @since      1.0.0
 */
- (void)showNoRecordTips:(BOOL)flag;

#pragma mark - 显示或者隐藏tabbar
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

#pragma mark - 登录检测
/**
 *  @author yangshengmeng, 15-03-13 14:03:28
 *
 *  @brief  返回应用当前是否已登录
 *
 *  @return 已登录-YES
 *
 *  @since  1.0.0
 */
- (BOOL)checkLogin;

/**
 *  @author yangshengmeng, 15-03-13 14:03:46
 *
 *  @brief  检测当前登录状态，如若未登录，则进入登录页面
 *
 *  @since  1.0.0
 */
- (void)checkLoginAndShowLogin;

/**
 *  @author                 yangshengmeng, 15-03-13 14:03:05
 *
 *  @brief                  检测当前登录状态，如若未登录，进入登录页面，并且在登录成功后执行对应的回调block
 *
 *  @param loginCallBack    登录成功后的回调block
 *
 *  @since                  1.0.0
 */
- (void)checkLoginAndShowLoginWithBlock:(void(^)(BOOL flag))loginCallBack;

@end
