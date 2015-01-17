//
//  QSChatViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSChatViewController.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

@interface QSChatViewController ()

@end

@implementation QSChatViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///设置标题
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_CHAT];
    
    ///导航栏工具按钮
    UIButton *toolButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeTool] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoToolViewController];
        
    }];
    [self setNavigationBarRightView:toolButton];

}

///搭建主展示UI
- (void)createMainShowUI
{

    ///由于此页面是放置在tabbar页面上的，所以中间可用的展示高度是设备高度减去导航栏和底部tabbar的高度
//    CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f - 49.0f;

}

#pragma mark - 点击工具按钮
- (void)gotoToolViewController
{

    

}

@end
