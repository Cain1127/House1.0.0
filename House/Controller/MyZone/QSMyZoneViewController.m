//
//  QSMyZoneViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMyZoneViewController.h"
#import "QSMyZoneTenantView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCoreDataManager+User.h"

#import <objc/runtime.h>

///关联
static char UserIconKey;//!<用户头像

@interface QSMyZoneViewController ()

@property (nonatomic,assign) USER_COUNT_TYPE userType;//!<用户类型

@end

@implementation QSMyZoneViewController

#pragma mark - 初始化
///初始化
- (instancetype)init
{

    if (self = [super init]) {
        
        ///获取当前用户类型
        self.userType = [QSCoreDataManager getCurrentUserCountType];
        
    }
    
    return self;

}

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
    [self setNavigationBarBackgroudColor:COLOR_NAVIGATIONBAR_LIGHTGRAY];
    [self showBottomSeperationLine:NO];
    
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
    
    ///头像背景
    QSImageView *iconRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 106.0f)];
    iconRootView.backgroundColor = COLOR_NAVIGATIONBAR_LIGHTGRAY;
    [self createIconImageView:iconRootView];
    [self.view addSubview:iconRootView];
    
    ///三角指示
    QSImageView *arrowImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 7.5f, iconRootView.frame.origin.y + iconRootView.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowImageView.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowImageView];
    
    ///根据用户类型，添加按钮
    if (uUserCountTypeTenant == self.userType) {
        
        
        
    }
    
}

///创建头像
- (void)createIconImageView:(UIView *)rootView
{

    ///头像view
    QSImageView *iconImageView = [[QSImageView alloc] initWithFrame:CGRectMake((rootView.frame.size.width - 79.0f) / 2.0f, (rootView.frame.size.height - 79.0f) / 2.0f, 79.0f, 79.0f)];
    UIImage *tempImage = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_158];
    iconImageView.image = tempImage;
    iconImageView.backgroundColor = [UIColor redColor];
    [rootView addSubview:iconImageView];
    objc_setAssociatedObject(self, &UserIconKey, iconImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像的六角
    QSImageView *iconSixformImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconImageView.frame.size.width, iconImageView.frame.size.height)];
    iconImageView.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_158];
    [iconImageView addSubview:iconSixformImageView];
    
    if (uUserCountTypeTenant == self.userType) {
        
        [self createRenantMyZoneUI];
        
    }
    
    if (uUserCountTypeOwner == self.userType) {
        
        [self createHouseOwnerUI];
        
    }

}

#pragma mark - 创建租客个人中心UI
///创建租客个人中心UI
- (void)createRenantMyZoneUI
{
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.title = @"房客";

    UIButton *renantButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 170.0f, SIZE_DEVICE_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        
        
    }];
    [self.view addSubview:renantButton];
    
    ///个人主要功能项的开始坐标
    CGFloat ypoint = renantButton.frame.origin.y + renantButton.frame.size.height;
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, ypoint - 0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLabel];
    
    ///加载房客主页
    QSMyZoneTenantView *myZoneView = [[QSMyZoneTenantView alloc] initWithFrame:CGRectMake(0.0f, ypoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - ypoint - 49.0f) andCallBack:^(TENANT_ZONE_ACTION_TYPE actionType, id params) {
        
        
        
    }];
    [self.view addSubview:myZoneView];

}

#pragma mark - 创建业主个人中心UI
///创建业主个人中心UI
- (void)createHouseOwnerUI
{

    

}

#pragma mark - 点击设置按钮
///点击设置按钮
- (void)gotoSettingViewController
{

    

}

#pragma mark - 点击消息按钮
///点击消息按钮
- (void)gotoMessageViewController
{

    

}

@end
