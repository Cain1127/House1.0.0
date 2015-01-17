//
//  QSHomeViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHomeViewController.h"
#import "QSTabBarViewController.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSHouseKeySearchViewController.h"

@interface QSHomeViewController ()

@end

@implementation QSHomeViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///添加中间view
    
    
    ///添加右侧搜索按钮
    UIButton *searchButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeSearch] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoSearchViewController];
        
    }];
    [self setNavigationBarRightView:searchButton];

}

///搭建主展示UI
- (void)createMainShowUI
{
    
    ///由于此页面是放置在tabbar页面上的，所以中间可用的展示高度是设备高度减去导航栏和底部tabbar的高度
//    CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f - 49.0f;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton createBlockButtonWithFrame:CGRectMake(30.0f, 100.0f, SIZE_DEVICE_WIDTH - 60.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        QSHouseKeySearchViewController *vc = [[QSHouseKeySearchViewController alloc] init];
        vc.hiddenCustomTabbarWhenPush = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        ///隐藏tabbar
        QSTabBarViewController *tabbarController = (QSTabBarViewController *)self.tabBarController;
        [tabbarController hiddenBottomTabbar:YES];
        
    }];
    [button setTitle:@"测试tabbar隐藏" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}

#pragma mark - 进入搜索页面
- (void)gotoSearchViewController
{

    

}

@end
