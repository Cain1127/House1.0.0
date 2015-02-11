//
//  QSMyZoneViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMyZoneViewController.h"
#import "QSMyZoneTenantView.h"
#import "QSMyZoneOwnerView.h"

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
    
    ///头像背景
    QSImageView *iconRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 106.0f)];
    iconRootView.backgroundColor = COLOR_NAVIGATIONBAR_LIGHTGRAY;
    [self createIconImageView:iconRootView];
    [self.view addSubview:iconRootView];
    
    ///三角指示
    QSImageView *arrowImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 7.5f, iconRootView.frame.origin.y + iconRootView.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowImageView.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowImageView];
    
    ///功能UI
    [self createMyZoneFunctionUI];
    
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

}

#pragma mark - 创建个人中心功能UI
///创建租客个人中心UI
- (void)createMyZoneFunctionUI
{
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    buttonStyle.title = @"房客";
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_BLACK;
    
    ///指示labe指针
    __block UILabel *indicatLabel;
    
    ///房客页面指针
    __block QSMyZoneTenantView *myZoneView;
    
    ///业主页面指针
    __block QSMyZoneOwnerView *ownerView;
    
    ///房客按钮指针
    __block UIButton *renantButton;
    
    ///业主按钮指针
    __block UIButton *ownerButton;

    ///房客按钮
    renantButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 170.0f, SIZE_DEVICE_WIDTH / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///如果当前处于选择状态，则不执行
        if (button.selected) {
            
            return;
            
        }
        
        ///设置按钮处于选择状态
        button.selected = YES;
        ownerButton.selected = NO;
        
        ///动画显示房客页面
        [UIView animateWithDuration:0.3f animations:^{
            
            myZoneView.frame = CGRectMake(0.0f, myZoneView.frame.origin.y, myZoneView.frame.size.width, myZoneView.frame.size.height);
            indicatLabel.frame = CGRectMake(0.0f, indicatLabel.frame.origin.y, indicatLabel.frame.size.width, indicatLabel.frame.size.height);
            
        }];
        
    }];
    renantButton.selected = YES;
    [self.view addSubview:renantButton];
    
    ///业主按钮
    buttonStyle.title = @"业主";
    ownerButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f, 170.0f, SIZE_DEVICE_WIDTH / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///如果当前处于选择状态，则不执行
        if (button.selected) {
            
            return;
            
        }
        
        ///设置按钮处于选择状态
        button.selected = YES;
        renantButton.selected = NO;
        
        ///动画显示房客页面
        [UIView animateWithDuration:0.3f animations:^{
            
            myZoneView.frame = CGRectMake(-myZoneView.frame.size.width, myZoneView.frame.origin.y, myZoneView.frame.size.width, myZoneView.frame.size.height);
            indicatLabel.frame = CGRectMake(indicatLabel.frame.size.width, indicatLabel.frame.origin.y, indicatLabel.frame.size.width, indicatLabel.frame.size.height);
            
        }];
        
    }];
    [self.view addSubview:ownerButton];
    
    ///个人主要功能项的开始坐标
    CGFloat ypoint = renantButton.frame.origin.y + renantButton.frame.size.height;
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, ypoint - 0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLabel];
    
    ///黄色提示
    indicatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, ypoint - 5.0f, SIZE_DEVICE_WIDTH / 2.0f, 5.0f)];
    indicatLabel.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [self.view addSubview:indicatLabel];
    
    ///加载房客主页
    CGFloat tenantViewHeight = SIZE_DEVICE_HEIGHT - ypoint - 49.0f;
    myZoneView = [[QSMyZoneTenantView alloc] initWithFrame:CGRectMake(0.0f, ypoint, SIZE_DEVICE_WIDTH, tenantViewHeight) andCallBack:^(TENANT_ZONE_ACTION_TYPE actionType, id params) {
        
        
        
    }];
    [self.view addSubview:myZoneView];
    
    ///业主页面
    ownerView = [[QSMyZoneOwnerView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, ypoint, SIZE_DEVICE_WIDTH, tenantViewHeight) andUserType:self.userType andCallBack:^(OWNER_ZONE_ACTION_TYPE actionType, id params) {
        
        
        
    }];
    [self.view addSubview:ownerView];

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
