//
//  QSMasterViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMasterViewController.h"
#import "QSTabBarViewController.h"
#import "QSHomeViewController.h"
#import "QSHousesViewController.h"
#import "QSChatViewController.h"
#import "QSMyZoneViewController.h"

#import "QSLoginViewController.h"

#import "QSCoreDataManager+User.h"

#import <objc/runtime.h>

///关联
static char NavigationBarKey;       //!<导航栏的关联key

@interface QSMasterViewController ()

@property (nonatomic,strong) UILabel *noRecordLabel;//!<暂无记录的提示信息

@end

@implementation QSMasterViewController

#pragma mark - 重写导航栏：添加导航栏
///导航栏UI
- (void)createNavigationBarUI
{

    ///创建自定义导航栏
    QSNavigationBar *navigationBar = [[QSNavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 64.0f)];
    [self.view addSubview:navigationBar];
    objc_setAssociatedObject(self, &NavigationBarKey, navigationBar, OBJC_ASSOCIATION_ASSIGN);

}

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
- (void)setNavigationBarBackgroudImageWithImageName:(NSString *)imageName
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarBackgroudImageWithImageName:imageName];
        
    });

}

///设置导航栏背景颜色
- (void)setNavigationBarBackgroudColor:(UIColor *)color
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        navigationBar.backgroundColor = color;
        
    });

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:57
 *
 *  @brief          通过图片设置导航栏背景图片
 *
 *  @param image    图片
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarBackgroudImageWithImage:(UIImage *)image
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarBackgroudImageWithImage:image];
        
    });

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:24
 *
 *  @brief          设置导航栏中间标题
 *
 *  @param title    标题
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarTitle:(NSString *)title
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarTitle:title];
        
    });

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:42
 *
 *  @brief          添加一个自定义的中间视图
 *
 *  @param view     中间视图
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarMiddleView:(UIView *)view
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarMiddleView:view];
        
    });

}

/**
 *  @author     yangshengmeng, 15-01-17 14:01:04
 *
 *  @brief      设置导航栏右侧视图
 *
 *  @param view 右侧显示视图
 *
 *  @since      1.0.0
 */
- (void)setNavigationBarRightView:(UIView *)view
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarRightView:view];
        
    });

}

/**
 *  @author     yangshengmeng, 15-01-17 14:01:33
 *
 *  @brief      设置左侧显示视图
 *
 *  @param view 左侧视图
 *
 *  @since      1.0.0
 */
- (void)setNavigationBarLeftView:(UIView *)view
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarLeftView:view];
        
    });

}

/**
 *  @author     yangshengmeng, 15-02-10 15:02:45
 *
 *  @brief      底部分隔线是否添加
 *
 *  @param flag 标识：YES-显示，NO-添加
 *
 *  @since      1.0.0
 */
- (void)showBottomSeperationLine:(BOOL)flag
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar showBottomSeperationLine:flag];
        
    });

}

#pragma mark - 显示暂无记录
/**
 *  @author     yangshengmeng, 15-02-06 10:02:20
 *
 *  @brief      显示暂无记录提示框
 *
 *  @param flag 是否显示：YES-显示,NO-移除
 *
 *  @since      1.0.0
 */
- (void)showNoRecordTips:(BOOL)flag
{
    
    ///判断是否需要显示
    if (flag) {
        
        ///判断原来是否已有
        if (self.noRecordLabel) {
            
            ///将提示移前
            self.noRecordLabel.hidden = NO;
            [self.view bringSubviewToFront:self.noRecordLabel];
            return;
            
        }
        
        ///没有则创建显示
        self.noRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 140.0f, SIZE_DEVICE_WIDTH - 60.0f, 60.0f)];
        self.noRecordLabel.text = @"暂无记录";
        self.noRecordLabel.textAlignment = NSTextAlignmentCenter;
        self.noRecordLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
        self.noRecordLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
        [self.view addSubview:self.noRecordLabel];
        [self.view bringSubviewToFront:self.noRecordLabel];
        
    } else {
    
        ///不需要显示则移除
        if (self.noRecordLabel) {
            
            self.noRecordLabel.hidden = YES;
            
        }
    
    }

}

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
- (void)hiddenBottomTabbar:(BOOL)flag
{

    QSTabBarViewController *tabbarVC = (QSTabBarViewController *)self.tabBarController;
    [tabbarVC hiddenBottomTabbar:flag];

}

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
- (LOGIN_CHECK_ACTION_TYPE)checkLogin
{

    if ([QSCoreDataManager isLogin]) {
        
        return lLoginCheckActionTypeLogined;
        
    } else {
    
        return lLoginCheckActionTypeUnLogin;
    
    }

}

/**
 *  @author yangshengmeng, 15-03-13 14:03:46
 *
 *  @brief  检测当前登录状态，如若未登录，则进入登录页面
 *
 *  @since  1.0.0
 */
- (void)checkLoginAndShowLogin
{

    [self checkLoginAndShowLoginWithBlock:nil];

}

/**
 *  @author                 yangshengmeng, 15-03-13 14:03:05
 *
 *  @brief                  检测当前登录状态，如若未登录，进入登录页面，并且在登录成功后执行对应的回调block
 *
 *  @param loginCallBack    登录成功后的回调block
 *
 *  @since                  1.0.0
 */
- (void)checkLoginAndShowLoginWithBlock:(void(^)(LOGIN_CHECK_ACTION_TYPE flag))loginCallBack
{

    LOGIN_CHECK_ACTION_TYPE isLogin = [self checkLogin];
    if (lLoginCheckActionTypeUnLogin == isLogin) {
        
        QSLoginViewController *loginVC = [[QSLoginViewController alloc] initWithCallBack:^(LOGIN_CHECK_ACTION_TYPE flag) {
            
            ///判断是否已重新登录
            if (lLoginCheckActionTypeReLogin == flag) {
                
                ///让相关UI重创
                ///回调通知用户信息已修改
                [QSCoreDataManager performCoredataChangeCallBack:cCoredataDataTypeMyZoneUserInfoChange andChangeType:dDataChangeTypeUserInfoChanged andParamsID:nil andParams:nil];
                
            }
            
            if (loginCallBack) {
                
                loginCallBack(flag);
                
            }
            
        }];
        
        ///如果是四个首页，需要隐藏tabbar
        if ([self isKindOfClass:[QSHomeViewController class]] ||
            [self isKindOfClass:[QSHousesViewController class]] ||
            [self isKindOfClass:[QSChatViewController class]] ||
            [self isKindOfClass:[QSMyZoneViewController class]]) {
            
            [self hiddenBottomTabbar:YES];
            
        }
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
    } else {
    
        loginCallBack(isLogin);
    
    }

}

@end
