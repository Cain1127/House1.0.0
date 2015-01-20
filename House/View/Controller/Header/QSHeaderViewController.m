//
//  QSHeaderViewController.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderViewController.h"

@interface QSHeaderViewController ()

@end

@implementation QSHeaderViewController

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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

@end