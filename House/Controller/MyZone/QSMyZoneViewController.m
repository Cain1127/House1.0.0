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
#import "QSYSystemMessagesViewController.h"
#import "QSYOwnerPropertyViewController.h"
#import "QSYRecommendTenantViewController.h"

#import "QSCustomHUDView.h"
#import "QSImageView+Block.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "NSString+Calculation.h"

#import "QSCoreDataManager+User.h"

#import "QSYMyzoneStatisticsReturnData.h"
#import "QSYMyzoneStatisticsRenantModel.h"
#import "QSYMyzoneStatisticsOwnerModel.h"
#import "QSUserDataModel.h"

#import <objc/runtime.h>

#import "QSPBuyerBookedOrdersListsViewController.h"
#import "QSPBuyerTransactionOrderListViewController.h"
#import "QSPSalerBookedOrdersListsViewController.h"
#import "QSPSalerTransactionOrderListViewController.h"

#include "MJRefresh.h"

///关联
static char UserIconKey;    //!<用户头像
static char RenantRootView; //!<房客底view
static char OwnerRootView;  //!<业主底view

@interface QSMyZoneViewController ()

@property (nonatomic,assign) USER_COUNT_TYPE userType;  //!<用户类型
@property (nonatomic,strong) QSScrollView *rootView;    //!<所有信息的底view

///用户信息
@property (nonatomic,retain) QSUserDataModel *userInfoData;
///统计数据
@property (nonatomic,retain) QSYMyzoneStatisticsReturnData *statisticsData;

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
    self.rootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 49.0f)];
    self.rootView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rootView];
    
    ///导航栏设置按钮
    UIButton *settingButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeLeft andButtonType:nNavigationBarButtonTypeSetting] andCallBack:^(UIButton *button) {
        
        ///进入设置页
        [self gotoSettingViewController];
        
    }];
    [self.rootView addSubview:settingButton];
    
    ///导航栏消息按钮
    UIButton *messageButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.rootView.frame.size.width - 44.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeMessage] andCallBack:^(UIButton *button) {
        
        ///进入消息页
        [self gotoMessageViewController];
        
    }];
    [self.rootView addSubview:messageButton];
    
    ///头像背景
    QSImageView *iconRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 170.0f)];
    iconRootView.backgroundColor = COLOR_NAVIGATIONBAR_LIGHTGRAY;
    [self createIconImageView:iconRootView];
    [self.rootView addSubview:iconRootView];
    [self.rootView sendSubviewToBack:iconRootView];
    
    ///三角指示
    QSImageView *arrowImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 7.5f, iconRootView.frame.origin.y + iconRootView.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowImageView.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.rootView addSubview:arrowImageView];
    
    ///功能UI
    [self createMyZoneFunctionUI:self.rootView andStartYPoint:170.0f];
    
    ///开始就请求数据
    [self.rootView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getMyZoneCalculationData)];
    
}

///创建头像
- (void)createIconImageView:(UIView *)rootView
{

    ///头像view
    UIImageView *iconImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake((rootView.frame.size.width - 79.0f) / 2.0f, 64.0f, 79.0f, 79.0f) andSingleTapCallBack:^{
        
        ///进入个人设置页面
        [self gotoPersonSetting];
        
    }];
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
            {
                
                QSPBuyerBookedOrdersListsViewController *bolVc = [[QSPBuyerBookedOrdersListsViewController alloc] init];
                [bolVc setSelectedType:mBuyerBookedOrderListTypeBooked];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
                
            }
                break;
                
                ///已看房点击
            case tTenantZoneActionTypeHavedAround:
            {
                
                QSPBuyerBookedOrdersListsViewController *bolVc = [[QSPBuyerBookedOrdersListsViewController alloc] init];
                [bolVc setSelectedType:mBuyerBookedOrderListTypeCompleted];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
                
            }
                break;
                
                ///待成交点击
            case tTenantZoneActionTypeWaitCommit:
                
            {
                QSPBuyerTransactionOrderListViewController *bolVc = [[QSPBuyerTransactionOrderListViewController alloc] init];
                [bolVc setSelectedType:mBuyerTransactionOrderListTypePending];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
            }
                break;
                
                ///已成交点击
            case tTenantZoneActionTypeCommited:
            {
                QSPBuyerTransactionOrderListViewController *bolVc = [[QSPBuyerTransactionOrderListViewController alloc] init];
                [bolVc setSelectedType:mBuyerTransactionOrderListTypeCompleted];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
                
            }
                break;
                
                ///预约订单击
            case tTenantZoneActionTypeAppointed:
                
            {
                
                QSPBuyerBookedOrdersListsViewController *bolVc = [[QSPBuyerBookedOrdersListsViewController alloc] init];
                [bolVc setSelectedType:mBuyerBookedOrderListTypeBooked];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
                
            }
                break;
                
                ///已成交订单点击
            case tTenantZoneActionTypeDeal:
            {
                
                QSPBuyerBookedOrdersListsViewController *bolVc = [[QSPBuyerBookedOrdersListsViewController alloc] init];
                [bolVc setSelectedType:mBuyerBookedOrderListTypeCompleted];
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
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:askSaleAndRentVC animated:YES];
                        
                    }
                    
                    ///重新成功登录
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        ///刷新页面数据
                        [self.rootView.header beginRefreshing];
                        
                    }
                    
                }];
                
            }
                break;
                
                ///收藏房源
            case tTenantZoneActionTypeCollected:
            {
                
                QSYCollectedHousesViewController *collectedHouseVC = [[QSYCollectedHousesViewController alloc] init];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:collectedHouseVC animated:YES];
                
            }
                break;
                
                ///关注小区
            case tTenantZoneActionTypeCommunity:
            {
                
                QSYAttentionCommunityViewController *attentionCommunityVC = [[QSYAttentionCommunityViewController alloc] init];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:attentionCommunityVC animated:YES];
                
            }
                break;
                
                ///浏览记录
            case tTenantZoneActionTypeHistory:
            {
                
                QSYMyHistoryViewController *myHistoryVC = [[QSYMyHistoryViewController alloc] init];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:myHistoryVC animated:YES];
                
            }
                break;
                
            default:
                break;
                
        }
        
    }];
    [rootView addSubview:myZoneView];
    objc_setAssociatedObject(self, &RenantRootView, myZoneView, OBJC_ASSOCIATION_ASSIGN);
    
    ///业主页面
    ownerView = [[QSMyZoneOwnerView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, ypoint, SIZE_DEVICE_WIDTH, tenantViewHeight) andUserType:self.userType andCallBack:^(OWNER_ZONE_ACTION_TYPE actionType, id params) {
        
        switch (actionType) {
            case oOwnerZoneActionTypeStayAround:
                //待看房
            {
                QSPSalerBookedOrdersListsViewController *bolVc = [[QSPSalerBookedOrdersListsViewController alloc] init];
                [bolVc setSelectedType:mSalerBookedOrderListTypeBooked];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
            }
                break;
                
            case oOwnerZoneActionTypeHavedAround:
                //已看房
            {
                QSPSalerBookedOrdersListsViewController *bolVc = [[QSPSalerBookedOrdersListsViewController alloc] init];
                [bolVc setSelectedType:mSalerBookedOrderListTypeCompleted];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
            }
                break;
                
            case oOwnerZoneActionTypeWaitCommit:
                //待成交
            {
                QSPSalerTransactionOrderListViewController *bolVc = [[QSPSalerTransactionOrderListViewController alloc] init];
                [bolVc setSelectedType:mSalerTransactionOrderListTypePending];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
            }
                break;
                
            case oOwnerZoneActionTypeCommited:
                //已成交
            {
                QSPSalerTransactionOrderListViewController *bolVc = [[QSPSalerTransactionOrderListViewController alloc] init];
                [bolVc setSelectedType:mSalerTransactionOrderListTypeCompleted];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:bolVc animated:YES];
            }
                break;
                
                ///预约订单
            case oOwnerZoneActionTypeAppointed:
            {
            
                
            
            }
                break;
                
                ///成交订单
            case oOwnerZoneActionTypeDeal:
            {
            
                
            
            }
                break;
                
                ///推荐房客
            case oOwnerZoneActionTypeRecommend:
            {
            
                QSYRecommendTenantViewController *recommendVC = [[QSYRecommendTenantViewController alloc] init];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:recommendVC animated:YES];
            
            }
                break;
                
                ///管理物业
            case oOwnerZoneActionTypeProprerty:
            {
            
                QSYOwnerPropertyViewController *propertyVC = [[QSYOwnerPropertyViewController alloc] initWithHouseType:fFilterMainTypeSecondHouse];
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:propertyVC animated:YES];
            
            }
                break;
                
                ///出售物业
            case oOwnerZoneActionTypeSaleHouse:
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                    
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSYReleaseSaleHouseViewController *releaseRentHouseVC = [[QSYReleaseSaleHouseViewController alloc] init];
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
                        
                    }
                    
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        ///刷新当前页面数据
                        [self.rootView.header beginRefreshing];
                        
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
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
                        
                    }
                    
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        ///刷新当前页面数据
                        [self.rootView.header beginRefreshing];
                        
                    }
                    
                }];
                
            }
                break;
                
            default:
                break;
        }
        
    }];
    [rootView addSubview:ownerView];
    objc_setAssociatedObject(self, &OwnerRootView, ownerView, OBJC_ASSOCIATION_ASSIGN);
    
    ///判断是否需要滚动
    if ((myZoneView.frame.origin.y + myZoneView.frame.size.height) > rootView.frame.size.height) {
        
        rootView.contentSize = CGSizeMake(rootView.frame.size.width, (myZoneView.frame.origin.y + myZoneView.frame.size.height) + 10.0f);
        
    }
    
    ///注册用户信息变动的监听
    [QSCoreDataManager setCoredataChangeCallBack:cCoredataDataTypeMyZoneUserInfoChange andCallBack:^(COREDATA_DATA_TYPE dataType, DATA_CHANGE_TYPE changeType, NSString *paramsID, id params) {
        
        ///重构业主UI
        [ownerView rebuildOwnerFunctionUI:[QSCoreDataManager getCurrentUserCountType]];
        
        ///重新请求数据
        [self.rootView.header beginRefreshing];
        
    }];

}

#pragma mark - 点击设置按钮
///点击设置按钮
- (void)gotoSettingViewController
{
    
    ///进入设置页面
    QSYSystemSettingViewController *settingVC = [[QSYSystemSettingViewController alloc] init];
    [self hiddenBottomTabbar:YES];
    [self.navigationController pushViewController:settingVC animated:YES];

}

#pragma mark - 点击消息按钮
///点击消息按钮
- (void)gotoMessageViewController
{
    
    ///进入系统消息页面
    QSYSystemMessagesViewController *systemMessageVC = [[QSYSystemMessagesViewController alloc] init];
    [self hiddenBottomTabbar:YES];
    [self.navigationController pushViewController:systemMessageVC animated:YES];

}

#pragma mark - 进入个人设置页面
- (void)gotoPersonSetting
{

    ///判断登录
    [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
        
        if (lLoginCheckActionTypeLogined == flag) {
            
            ///进入系统消息页面
            QSYMySettingViewController *mySettingVC = [[QSYMySettingViewController alloc] init];
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:mySettingVC animated:YES];
            
        }
        
        if (lLoginCheckActionTypeReLogin == flag) {
            
            ///刷新当前页面数据
            
            
        }
        
    }];

}

#pragma mark - 请求个人数据
- (void)getMyZoneCalculationData
{

    ///已经登录，才请求数据
    if (lLoginCheckActionTypeLogined == [self checkLogin]) {
        
        ///显示HUD
        __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
        
        ///获取用户信息
        self.userInfoData = [QSCoreDataManager getCurrentUserDataModel];
        
        ///请求数据
        [QSRequestManager requestDataWithType:rRequestTypeMyZoneStatistics andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///隐藏hud
            [hud hiddenCustomHUD];
            
            ///请求成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                TIPS_ALERT_MESSAGE_ANDTURNBACK(@"下载成功", 1.0f, ^(){
                
                    ///刷新UI
                    self.statisticsData = resultData;
                    [self updateMyzoneUIWithLoginData];
                
                })
                
            } else {
            
                ///提示信息
                [self.rootView.header endRefreshing];
                NSString *tipsString = @"下载失败";
                TIPS_ALERT_MESSAGE_ANDTURNBACK(tipsString, 1.0f, ^(){})
                
            }
            
        }];
        
    }

}

#pragma mark - 更新UI
- (void)updateMyzoneUIWithLoginData
{

    [self updateRenantCountInfo];
    [self updateOwnerCountInfo];
    [self updateuserIcon];
    
    ///停止刷新动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.rootView.header endRefreshing];
        
    });

}

///更新房客信息
- (void)updateRenantCountInfo
{
    
    QSMyZoneOwnerView *view = objc_getAssociatedObject(self, &RenantRootView);
    
}

///更新业主信息
- (void)updateOwnerCountInfo
{
    
    QSMyZoneTenantView *view = objc_getAssociatedObject(self, &OwnerRootView);
    
}

///更新用户头像
- (void)updateuserIcon
{

    UIImageView *iconView = objc_getAssociatedObject(self, &UserIconKey);
    if (iconView && [self.userInfoData.avatar length] > 0) {
        
        [iconView loadImageWithURL:[self.userInfoData.avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_158]];
        
    }

}

#pragma mark - 个人中心出现时显示tabbar
///个人中心出现时显示tabbar
- (void)viewWillAppear:(BOOL)animated
{
    
    [self hiddenBottomTabbar:NO];
    [super viewWillAppear:animated];
    
}

@end
