//
//  QSMyZoneViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMyZoneViewController.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

@interface QSMyZoneViewController ()

@end

@implementation QSMyZoneViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///设置默认标题
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_MYZONE];
    
    ///导航栏设置按钮
    UIButton *settingButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeLeft andButtonType:nNavigationBarButtonTypeSetting] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoSettingViewController];
        
    }];
    [self setNavigationBarLeftView:settingButton];
    
    ///导航栏消息按钮
    UIButton *messageButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeMessage] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoMessageViewController];
        
    }];
    [self setNavigationBarRightView:messageButton];

}

///主展示信息UI搭建
- (void)createMainShowUI
{
    
    ///由于此页面是放置在tabbar页面上的，所以中间可用的展示高度是设备高度减去导航栏和底部tabbar的高度
//    CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f - 49.0f;
    
    
}

#pragma mark - 点击设置按钮
- (void)gotoSettingViewController
{

    

}

#pragma mark - 点击消息按钮
- (void)gotoMessageViewController
{

    

}

@end
