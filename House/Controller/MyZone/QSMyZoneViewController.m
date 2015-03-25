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
#import "QSYMySettingViewController.h"
#import "QSYAskSaleAndRentViewController.h"
#import "QSYAttentionCommunityViewController.h"
#import "QSYCollectedHousesViewController.h"
#import "QSYMyHistoryViewController.h"
#import "QSYSystemSettingViewController.h"
#import "QSYReleaseRentHouseViewController.h"
#import "QSYReleaseSaleHouseViewController.h"

#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCoreDataManager+User.h"

#import <objc/runtime.h>

#import "QSPBookingOrdersListsViewController.h"
#import "QSPTransactionOrderListViewController.h"

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
        
        ///获取当前用户类型：如若未登录，直接显示客房类型
        if (lLoginCheckActionTypeLogined == [self checkLogin]) {
            
            self.userType = [QSCoreDataManager getCurrentUserCountType];
            
        } else {
        
            self.userType = uUserCountTypeTenant;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    ///由于个人中心需要全屏滚动，所以重写导航栏方法，不创建任何UI，不能删除此方法

}

///主展示信息UI搭建
- (void)createMainShowUI
{
    
    ///个人页面可以全屏滚动
    QSScrollView *rootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 49.0f)];
    rootView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rootView];
    
    ///导航栏设置按钮
    UIButton *settingButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeLeft andButtonType:nNavigationBarButtonTypeSetting] andCallBack:^(UIButton *button) {
        
        ///进入设置页
        [self gotoSettingViewController];
        
    }];
    [rootView addSubview:settingButton];
    
    ///导航栏消息按钮
    UIButton *messageButton = [UIButton createBlockButtonWithFrame:CGRectMake(rootView.frame.size.width - 44.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeMessage] andCallBack:^(UIButton *button) {
        
        ///进入消息页
        [self gotoMessageViewController];
        
    }];
    [rootView addSubview:messageButton];
    
    ///头像背景
    QSImageView *iconRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 170.0f)];
    iconRootView.backgroundColor = COLOR_NAVIGATIONBAR_LIGHTGRAY;
    [self createIconImageView:iconRootView];
    [rootView addSubview:iconRootView];
    [rootView sendSubviewToBack:iconRootView];
    
    ///三角指示
    QSImageView *arrowImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 7.5f, iconRootView.frame.origin.y + iconRootView.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowImageView.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [rootView addSubview:arrowImageView];
    
    ///功能UI
    [self createMyZoneFunctionUI:rootView andStartYPoint:170.0f];
    
}

///创建头像
- (void)createIconImageView:(UIView *)rootView
{

    ///头像view
    QSImageView *iconImageView = [[QSImageView alloc] initWithFrame:CGRectMake((rootView.frame.size.width - 79.0f) / 2.0f, 64.0f, 79.0f, 79.0f)];
    UIImage *tempImage = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_158];
    iconImageView.image = tempImage;
    [rootView addSubview:iconImageView];
    objc_setAssociatedObject(self, &UserIconKey, iconImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像的六角
    QSImageView *iconSixformImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconImageView.frame.size.width, iconImageView.frame.size.height)];
    iconSixformImageView.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_158];
    [iconImageView addSubview:iconSixformImageView];

}

#pragma mark - 创建个人中心功能UI
///创建租客个人中心UI
- (void)createMyZoneFunctionUI:(UIScrollView *)rootView andStartYPoint:(CGFloat)startYPoint
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
    renantButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, startYPoint, SIZE_DEVICE_WIDTH / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
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
            ownerView.frame = CGRectMake(ownerView.frame.size.width, ownerView.frame.origin.y, ownerView.frame.size.width, ownerView.frame.size.height);
            indicatLabel.frame = CGRectMake(0.0f, indicatLabel.frame.origin.y, indicatLabel.frame.size.width, indicatLabel.frame.size.height);
            
        }];
        
    }];
    renantButton.selected = YES;
    [rootView addSubview:renantButton];
    
    ///业主按钮
    buttonStyle.title = @"业主";
    ownerButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f, renantButton.frame.origin.y, SIZE_DEVICE_WIDTH / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
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
            ownerView.frame = CGRectMake(0.0f, ownerView.frame.origin.y, ownerView.frame.size.width, ownerView.frame.size.height);
            indicatLabel.frame = CGRectMake(indicatLabel.frame.size.width, indicatLabel.frame.origin.y, indicatLabel.frame.size.width, indicatLabel.frame.size.height);
            
        }];
        
    }];
    [rootView addSubview:ownerButton];
    
    ///个人主要功能项的开始坐标
    CGFloat ypoint = renantButton.frame.origin.y + renantButton.frame.size.height;
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, ypoint - 0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:sepLabel];
    
    ///黄色提示
    indicatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, ypoint - 5.0f, SIZE_DEVICE_WIDTH / 2.0f, 5.0f)];
    indicatLabel.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [rootView addSubview:indicatLabel];
    
    ///加载房客主页
    CGFloat tenantViewHeight = SIZE_DEVICE_HEIGHT > 568.0f ? SIZE_DEVICE_HEIGHT - ypoint - 49.0f : 340.0f;
    myZoneView = [[QSMyZoneTenantView alloc] initWithFrame:CGRectMake(0.0f, ypoint, SIZE_DEVICE_WIDTH, tenantViewHeight) andCallBack:^(TENANT_ZONE_ACTION_TYPE actionType, id params) {
        
        switch (actionType) {
                ///待看房点击
            case tTenantZoneActionTypeStayAround:
                
                NSLog(@"==================待看房======================");
                {
                    QSPBookingOrdersListsViewController *bolVc = [[QSPBookingOrdersListsViewController alloc] init];
                    [bolVc setHiddenCustomTabbarWhenPush:YES];
                    [bolVc setSelectedType:mOrderListTypeBooked];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                }
                break;
                
                ///已看房点击
            case tTenantZoneActionTypeHavedAround:
                
                NSLog(@"==================已看房======================");
                {
                    QSPBookingOrdersListsViewController *bolVc = [[QSPBookingOrdersListsViewController alloc] init];
                    [bolVc setHiddenCustomTabbarWhenPush:YES];
                    [bolVc setSelectedType:mOrderListTypeCompleted];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                }
                break;
                
                ///待成交点击
            case tTenantZoneActionTypeWaitCommit:
                
                NSLog(@"==================待成交======================");
                {
                    QSPTransactionOrderListViewController *bolVc = [[QSPTransactionOrderListViewController alloc] init];
                    [bolVc setHiddenCustomTabbarWhenPush:YES];
                    [bolVc setSelectedType:mTransactionOrderListTypePending];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                }
                break;
                
                ///已成交点击
            case tTenantZoneActionTypeCommited:
                
                NSLog(@"==================已成交======================");
                {
                    QSPTransactionOrderListViewController *bolVc = [[QSPTransactionOrderListViewController alloc] init];
                    [bolVc setHiddenCustomTabbarWhenPush:YES];
                    [bolVc setSelectedType:mTransactionOrderListTypeCompleted];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                }
                break;
                
                ///预约订单击
            case tTenantZoneActionTypeAppointed:
            {
                
                QSPBookingOrdersListsViewController *bolVc = [[QSPBookingOrdersListsViewController alloc] init];
                [bolVc setHiddenCustomTabbarWhenPush:YES];
                [bolVc setSelectedType:mOrderListTypeBooked];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
                
            }
                break;
                
                ///已成交订单点击
            case tTenantZoneActionTypeDeal:
            {
                
                QSPBookingOrdersListsViewController *bolVc = [[QSPBookingOrdersListsViewController alloc] init];
                [bolVc setHiddenCustomTabbarWhenPush:YES];
                [bolVc setSelectedType:mOrderListTypeCompleted];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
                
            }
                break;
                
                ///求租求购点击
            case tTenantZoneActionTypeBeg:
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                    
                    ///已登录
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSYAskSaleAndRentViewController *askSaleAndRentVC = [[QSYAskSaleAndRentViewController alloc] init];
                        askSaleAndRentVC.hiddenCustomTabbarWhenPush = YES;
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:askSaleAndRentVC animated:YES];
                        
                    }
                    
                    ///重新成功登录
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        ///刷新页面数据
                        
                        ///进入求购页面
                        QSYAskSaleAndRentViewController *askSaleAndRentVC = [[QSYAskSaleAndRentViewController alloc] init];
                        askSaleAndRentVC.hiddenCustomTabbarWhenPush = YES;
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:askSaleAndRentVC animated:YES];
                        
                    }
                    
                }];
                
            }
                break;
                
                ///收藏房源
            case tTenantZoneActionTypeCollected:
            {
                
                QSYCollectedHousesViewController *collectedHouseVC = [[QSYCollectedHousesViewController alloc] init];
                [self.navigationController pushViewController:collectedHouseVC animated:YES];
                
            }
                break;
                
                ///关注小区
            case tTenantZoneActionTypeCommunity:
            {
                
                QSYAttentionCommunityViewController *attentionCommunityVC = [[QSYAttentionCommunityViewController alloc] init];
                attentionCommunityVC.hiddenCustomTabbarWhenPush = YES;
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:attentionCommunityVC animated:YES];
                
            }
                break;
                
                ///浏览记录
            case tTenantZoneActionTypeHistory:
            {
                
                QSYMyHistoryViewController *myHistoryVC = [[QSYMyHistoryViewController alloc] init];
                [self.navigationController pushViewController:myHistoryVC animated:YES];
                
            }
                break;
                
            default:
                break;
                
        }
        
    }];
    [rootView addSubview:myZoneView];
    
    ///业主页面
    ownerView = [[QSMyZoneOwnerView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, ypoint, SIZE_DEVICE_WIDTH, tenantViewHeight) andUserType:self.userType andCallBack:^(OWNER_ZONE_ACTION_TYPE actionType, id params) {
        
        switch (actionType) {
                ///出售物业
            case oOwnerZoneActionTypeSaleHouse:
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                    
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSYReleaseSaleHouseViewController *releaseRentHouseVC = [[QSYReleaseSaleHouseViewController alloc] init];
                        releaseRentHouseVC.hiddenCustomTabbarWhenPush = YES;
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
                        
                    }
                    
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        ///刷新当前页面数据
                        
                        ///进入发布出售物业页面
                        QSYReleaseSaleHouseViewController *releaseRentHouseVC = [[QSYReleaseSaleHouseViewController alloc] init];
                        releaseRentHouseVC.hiddenCustomTabbarWhenPush = YES;
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
                        
                    }
                    
                }];
                
            }
                break;
                
                ///出租物业
            case oOwnerZoneActionTypeRenantHouse:
            {
             
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                    
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSYReleaseRentHouseViewController *releaseRentHouseVC = [[QSYReleaseRentHouseViewController alloc] init];
                        releaseRentHouseVC.hiddenCustomTabbarWhenPush = YES;
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
                        
                    }
                    
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        ///刷新当前页面数据
                        
                        ///进入发布出租物业页面
                        QSYReleaseRentHouseViewController *releaseRentHouseVC = [[QSYReleaseRentHouseViewController alloc] init];
                        releaseRentHouseVC.hiddenCustomTabbarWhenPush = YES;
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
                        
                    }
                    
                }];
                
            }
                break;
                
            default:
                break;
        }
        
    }];
    [rootView addSubview:ownerView];
    
    ///判断是否需要滚动
    if ((myZoneView.frame.origin.y + myZoneView.frame.size.height) > rootView.frame.size.height) {
        
        rootView.contentSize = CGSizeMake(rootView.frame.size.width, (myZoneView.frame.origin.y + myZoneView.frame.size.height) + 10.0f);
        
    }

}

#pragma mark - 点击设置按钮
///点击设置按钮
- (void)gotoSettingViewController
{
    
    ///进入设置页面
    QSYSystemSettingViewController *settingVC = [[QSYSystemSettingViewController alloc] init];
    settingVC.hiddenCustomTabbarWhenPush = YES;
    [self hiddenBottomTabbar:YES];
    [self.navigationController pushViewController:settingVC animated:YES];

}

#pragma mark - 点击消息按钮
///点击消息按钮
- (void)gotoMessageViewController
{

    ///判断登录
    [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
        
        if (lLoginCheckActionTypeLogined == flag) {
            
            ///进入设置页面
            QSYMySettingViewController *settingVC = [[QSYMySettingViewController alloc] init];
            settingVC.hiddenCustomTabbarWhenPush = YES;
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }
        
        if (lLoginCheckActionTypeReLogin == flag) {
            
            ///刷新当前页面数据
            
            ///进入设置页面
            QSYMySettingViewController *settingVC = [[QSYMySettingViewController alloc] init];
            settingVC.hiddenCustomTabbarWhenPush = YES;
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }
        
    }];

}

#pragma mark - 请求个人数据
- (void)requestSelfData
{

    ///已经登录，才请求数据
    if (lLoginCheckActionTypeLogined == [self checkLogin]) {
        
        ///显示HUD
        __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
        
        ///请求数据
        [QSRequestManager requestDataWithType:rRequestTypeAdvert andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///隐藏hud
            [hud hiddenCustomHUD];
            
            ///请求成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                TIPS_ALERT_MESSAGE_ANDTURNBACK(@"下载成功", 1.0f, ^(){
                
                    ///刷新UI
                    
                
                })
                
            } else {
            
                ///提示信息
                NSString *tipsString = @"下载失败";
                TIPS_ALERT_MESSAGE_ANDTURNBACK(tipsString, 1.0f, ^(){})
            
            }
            
        }];
        
    }

}

@end
