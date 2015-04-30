//
//  QSHeaderViewController.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderViewController.h"
#import "QSYAppDelegate.h"

@interface QSHeaderViewController ()

@end

@implementation QSHeaderViewController

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///取消scrollView自适应位移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ///通过统一的方法创建UI
    [self createUI];
    
}

///搭建UI
- (void)createUI
{
    
    ///搭建中间主展示信息
    [self createMainShowUI];
    
    ///搭建导航栏
    [self createNavigationBarUI];
    
    ///搭建tabbar
    [self createBottomTabbar];
    
}

///导航栏UI
- (void)createNavigationBarUI
{
    
    
    
}

///底部功能UI
- (void)createBottomTabbar
{
    
    
    
}

///中间主展示信息UI
- (void)createMainShowUI
{
    
    
    
}

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
- (void)changeWindowRootViewController:(UIViewController *)newVC
{
    
#if 1
    [UIApplication sharedApplication].keyWindow.rootViewController = newVC;
#endif

#if 0
    QSYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = newVC;
#endif
    
}

@end