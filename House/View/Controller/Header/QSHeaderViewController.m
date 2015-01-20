//
//  QSHeaderViewController.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderViewController.h"
#import "QSNetworkingStatus.h"

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
- (NETWORK_STATUS)currentReachabilityStatus
{

    QSNetworkingStatus *reach=[QSNetworkingStatus reachabilityWithHostName:@"www.baidu.com"];
    ///返回网络状态的判断
    return [reach currentReachabilityStatus];

}

@end