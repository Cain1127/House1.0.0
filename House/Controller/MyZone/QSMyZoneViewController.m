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
#import "QSLoginViewController.h"

#import "QSCustomHUDView.h"
#import "QSImageView+Block.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "NSString+Calculation.h"

#import "QSCoreDataManager+User.h"
#import "QSSocketManager.h"

#import "QSYMyzoneStatisticsReturnData.h"
#import "QSYMyzoneStatisticsRenantModel.h"
#import "QSYMyzoneStatisticsOwnerModel.h"
#import "QSUserDataModel.h"

#import <objc/runtime.h>

#import "QSPBuyerBookedOrdersListsViewController.h"
#import "QSPBuyerTransactionOrderListViewController.h"
#import "QSPSalerBookedOrdersListsViewController.h"
#import "QSPSalerTransactionOrderListViewController.h"

///关联
static char UserIconKey;    //!<用户头像
static char RenantRootView; //!<房客底view
static char OwnerRootView;  //!<业主底view
static char UserNameKey;    //!<用户名

@interface QSMyZoneViewController ()

@property (nonatomic,assign) USER_COUNT_TYPE userType;  //!<用户类型
@property (nonatomic,strong) QSScrollView *rootView;    //!<所有信息的底view
@property (nonatomic,copy) NSString *is_release;        //!<是否是指引页进入发布房源
@property (assign) BOOL isNeedRefresh;                  //!<是否需要刷新

///个人中心右上角系统消息数量提示
@property (nonatomic,strong) UILabel *systemMessageCountTipsLabel;

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
    
    ///中间标题
    UILabel *titlaLabel = [[UILabel alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 120.0f) / 2.0f, 27.0f, 120.0f, 30.0f)];
    titlaLabel.textAlignment = NSTextAlignmentCenter;
    titlaLabel.font = [UIFont boldSystemFontOfSize:FONT_NAVIGATIONBAR_TITLE];
    titlaLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.rootView addSubview:titlaLabel];
    objc_setAssociatedObject(self, &UserNameKey, titlaLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///导航栏设置按钮
    UIButton *settingButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeLeft andButtonType:nNavigationBarButtonTypeSetting] andCallBack:^(UIButton *button) {
        
        ///进入设置页
        [self gotoSettingViewController];
        
    }];
    [self.rootView addSubview:settingButton];
    
    ///导航栏消息按钮
    UIButton *messageButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.rootView.frame.size.width - 44.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeMessage] andCallBack:^(UIButton *button) {
        
        ///隐藏数量提示
        self.systemMessageCountTipsLabel.text = @"0";
        self.systemMessageCountTipsLabel.hidden = YES;
        
        ///注销系统消息数量监听
        [QSSocketManager offsSystemMessageReceiveNotification];
        
        ///进入消息页
        [self gotoMessageViewController];
        
    }];
    [self.rootView addSubview:messageButton];
    
    ///系统消息数量提示
    self.systemMessageCountTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(messageButton.frame.origin.x + messageButton.frame.size.width - 10.0f, messageButton.frame.origin.y + 10.0f, 20.0f, 20.0f)];
    self.systemMessageCountTipsLabel.layer.cornerRadius = 10.0f;
    self.systemMessageCountTipsLabel.layer.masksToBounds = YES;
    self.systemMessageCountTipsLabel.textAlignment = NSTextAlignmentCenter;
    self.systemMessageCountTipsLabel.textColor = [UIColor whiteColor];
    self.systemMessageCountTipsLabel.backgroundColor = [UIColor redColor];
    self.systemMessageCountTipsLabel.adjustsFontSizeToFitWidth = YES;
    self.systemMessageCountTipsLabel.hidden = YES;
    [self.rootView addSubview:self.systemMessageCountTipsLabel];
    
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self getMyZoneCalculationData];
        
    });
    
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
    renantButton.selected = !([self.is_release length] > 0);
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
    ownerButton.selected = ([self.is_release length] > 0);
    [rootView addSubview:ownerButton];
    
    ///个人主要功能项的开始坐标
    CGFloat ypoint = renantButton.frame.origin.y + renantButton.frame.size.height;
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, ypoint - 0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:sepLabel];
    
    ///黄色提示
    CGFloat indicatorXPoint = 0.0f;
    if ([self.is_release length] > 0) {
        
        indicatorXPoint = SIZE_DEVICE_WIDTH / 2.0f;
        
    }
    indicatLabel = [[UILabel alloc] initWithFrame:CGRectMake(indicatorXPoint, ypoint - 5.0f, SIZE_DEVICE_WIDTH / 2.0f, 5.0f)];
    indicatLabel.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [rootView addSubview:indicatLabel];
    
    ///根据当前的发布类型，显示默认功能区
    CGFloat tenantXPoint = 0.0f;
    if ([self.is_release length] > 0) {
        
        tenantXPoint = -SIZE_DEVICE_WIDTH;
        
    }
    
    ///加载房客主页
    CGFloat tenantViewHeight = SIZE_DEVICE_HEIGHT > 568.0f ? SIZE_DEVICE_HEIGHT - ypoint - 49.0f : 340.0f;
    myZoneView = [[QSMyZoneTenantView alloc] initWithFrame:CGRectMake(tenantXPoint, ypoint, SIZE_DEVICE_WIDTH, tenantViewHeight) andCallBack:^(TENANT_ZONE_ACTION_TYPE actionType, id params) {
        
        switch (actionType) {
                ///待看房点击
            case tTenantZoneActionTypeStayAround:
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                    
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSPBuyerBookedOrdersListsViewController *bolVc = [[QSPBuyerBookedOrdersListsViewController alloc] init];
                        [bolVc setSelectedType:mBuyerBookedOrderListTypeBooked];
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:bolVc animated:YES];
                        
                    }
                    
                    ///刷新数据
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        self.isNeedRefresh = YES;
                        
                    }
                    
                }];
                
            }
                break;
                
                ///已看房点击
            case tTenantZoneActionTypeHavedAround:
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                    
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSPBuyerBookedOrdersListsViewController *bolVc = [[QSPBuyerBookedOrdersListsViewController alloc] init];
                        [bolVc setSelectedType:mBuyerBookedOrderListTypeCompleted];
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:bolVc animated:YES];
                        
                    }
                    
                    ///刷新数据
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        self.isNeedRefresh = YES;
                        
                    }
                    
                }];
                
            }
                break;
                
                ///待成交点击
            case tTenantZoneActionTypeWaitCommit:
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSPBuyerTransactionOrderListViewController *bolVc = [[QSPBuyerTransactionOrderListViewController alloc] init];
                        [bolVc setSelectedType:mBuyerTransactionOrderListTypePending];
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:bolVc animated:YES];
                        
                    }
                    
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        self.isNeedRefresh = YES;
                        
                    }
                
                }];
                
            }
                break;
                
                ///已成交点击
            case tTenantZoneActionTypeCommited:
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSPBuyerTransactionOrderListViewController *bolVc = [[QSPBuyerTransactionOrderListViewController alloc] init];
                        [bolVc setSelectedType:mBuyerTransactionOrderListTypeCompleted];
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:bolVc animated:YES];
                        
                    }
                    
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        self.isNeedRefresh = YES;
                        
                    }
                
                }];
                
            }
                break;
                
                ///预约订单击
            case tTenantZoneActionTypeAppointed:
                
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                    
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSPBuyerBookedOrdersListsViewController *bolVc = [[QSPBuyerBookedOrdersListsViewController alloc] init];
                        [bolVc setSelectedType:mBuyerBookedOrderListTypeBooked];
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:bolVc animated:YES];
                        
                    }
                    
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        self.isNeedRefresh = YES;
                        
                    }
                    
                }];
                
            }
                break;
                
                ///已成交订单点击
            case tTenantZoneActionTypeDeal:
            {
                
                [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                
                    if (lLoginCheckActionTypeLogined == flag) {
                        
                        QSPBuyerBookedOrdersListsViewController *bolVc = [[QSPBuyerBookedOrdersListsViewController alloc] init];
                        [bolVc setSelectedType:mBuyerBookedOrderListTypeCompleted];
                        [self hiddenBottomTabbar:YES];
                        [self.navigationController pushViewController:bolVc animated:YES];
                        
                    }
                    
                    if (lLoginCheckActionTypeReLogin == flag) {
                        
                        self.isNeedRefresh = YES;
                        
                    }
                
                }];
                
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
                        self.isNeedRefresh = YES;
                        
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
    ownerView = [[QSMyZoneOwnerView alloc] initWithFrame:CGRectMake(tenantXPoint + SIZE_DEVICE_WIDTH, ypoint, SIZE_DEVICE_WIDTH, tenantViewHeight) andUserType:self.userType andCallBack:^(OWNER_ZONE_ACTION_TYPE actionType, id params) {
        
        switch (actionType) {
            case oOwnerZoneActionTypeStayAround:
                //待看房
            {
                QSPSalerBookedOrdersListsViewController *bolVc = [[QSPSalerBookedOrdersListsViewController alloc] init];
                if ([self checkLogin] == lLoginCheckActionTypeUnLogin) {
                    
                    [self checkLoginAndShowLogin];
                    
                }else if ([self checkLogin] == lLoginCheckActionTypeLogined || [self checkLogin] == lLoginCheckActionTypeReLogin ) {
                    
                    [bolVc setSelectedType:mSalerBookedOrderListTypeBooked];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                    
                }

            }
                break;
                
            case oOwnerZoneActionTypeHavedAround:
                //已看房
            {
                
                QSPSalerBookedOrdersListsViewController *bolVc = [[QSPSalerBookedOrdersListsViewController alloc] init];
                if ([self checkLogin] == lLoginCheckActionTypeUnLogin) {
                    
                    [self checkLoginAndShowLogin];
                    
                }else if ([self checkLogin] == lLoginCheckActionTypeLogined || [self checkLogin] == lLoginCheckActionTypeReLogin ) {
                    
                    [bolVc setSelectedType:mSalerBookedOrderListTypeCompleted];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                    
                }
                
            }
                break;
                
            case oOwnerZoneActionTypeWaitCommit:
                //待成交
            {
                
                QSPSalerTransactionOrderListViewController *bolVc = [[QSPSalerTransactionOrderListViewController alloc] init];
                if ([self checkLogin] == lLoginCheckActionTypeUnLogin) {
                    
                    [self checkLoginAndShowLogin];
                    
                }else if ([self checkLogin] == lLoginCheckActionTypeLogined || [self checkLogin] == lLoginCheckActionTypeReLogin ) {
                    
                    [bolVc setSelectedType:mSalerTransactionOrderListTypePending];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                    
                }
                
            }
                break;
                
            case oOwnerZoneActionTypeCommited:
                ///已成交
            {
                QSPSalerTransactionOrderListViewController *bolVc = [[QSPSalerTransactionOrderListViewController alloc] init];
                if ([self checkLogin] == lLoginCheckActionTypeUnLogin) {
                    
                    [self checkLoginAndShowLogin];
                    
                }else if ([self checkLogin] == lLoginCheckActionTypeLogined || [self checkLogin] == lLoginCheckActionTypeReLogin ) {
                    
                    [bolVc setSelectedType:mSalerTransactionOrderListTypeCompleted];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                    
                }
                
            }
                break;
                
                ///预约订单
            case oOwnerZoneActionTypeAppointed:
            {
            
                QSPSalerBookedOrdersListsViewController *bolVc = [[QSPSalerBookedOrdersListsViewController alloc] init];
                if ([self checkLogin] == lLoginCheckActionTypeUnLogin) {
                    
                    [self checkLoginAndShowLogin];
                    
                }else if ([self checkLogin] == lLoginCheckActionTypeLogined || [self checkLogin] == lLoginCheckActionTypeReLogin ) {
                    
                    [bolVc setSelectedType:mSalerBookedOrderListTypeCompleted];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                    
                }
            
            }
                break;
                
                ///成交订单
            case oOwnerZoneActionTypeDeal:
            {
            
                QSPSalerTransactionOrderListViewController *bolVc = [[QSPSalerTransactionOrderListViewController alloc] init];
                if ([self checkLogin] == lLoginCheckActionTypeUnLogin) {
                    
                    [self checkLoginAndShowLogin];
                    
                }else if ([self checkLogin] == lLoginCheckActionTypeLogined || [self checkLogin] == lLoginCheckActionTypeReLogin ) {
                    
                    [bolVc setSelectedType:mSalerTransactionOrderListTypeCompleted];
                    [self hiddenBottomTabbar:YES];
                    [self.navigationController pushViewController:bolVc animated:YES];
                    
                }
            
            }
                break;
                
                ///推荐房客
            case oOwnerZoneActionTypeRecommend:
            {
            
                QSYRecommendTenantViewController *recommendVC = [[QSYRecommendTenantViewController alloc] initWithRecommendType:rRecommendTenantTypeAll andPropertyType:nil];
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
                        self.isNeedRefresh = YES;
                        
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
                        self.isNeedRefresh = YES;
                        
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
        self.isNeedRefresh = YES;
        
    }];
    
    ///判断是否进入发布物业
    if (fFilterMainTypeSecondHouse == [self.is_release intValue]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self gotoReleaseSaleHouseMyzone];
            
        });
        
    }
    
    if (fFilterMainTypeRentalHouse == [self.is_release intValue]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self gotoReleaseRentHouseMyzone];
            
        });
        
    }

}

#pragma mark - 进入出售物业页面
- (void)gotoReleaseSaleHouseMyzone
{

    QSYReleaseSaleHouseViewController *releaseRentHouseVC = [[QSYReleaseSaleHouseViewController alloc] init];
    [self hiddenBottomTabbar:YES];
    [self.navigationController pushViewController:releaseRentHouseVC animated:YES];

}

#pragma mark - 进入出租物业页面
- (void)gotoReleaseRentHouseMyzone
{
    
    QSYReleaseRentHouseViewController *releaseRentHouseVC = [[QSYReleaseRentHouseViewController alloc] init];
    [self hiddenBottomTabbar:YES];
    [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
    
}

#pragma mark - 点击设置按钮
///点击设置按钮
- (void)gotoSettingViewController
{
    
    ///进入设置页面
    QSYSystemSettingViewController *settingVC = [[QSYSystemSettingViewController alloc] init];
    [self hiddenBottomTabbar:YES];
    settingVC.systemSettingCallBack = ^(SYSTEMSETTING_ACTION_TYPE actionType,id params){
    
        switch (actionType) {
                ///登录
            case sSystemSettingActionTypeLogin:
                
                ///登出
            case sSystemSettingActionTypeLogout:
                
                self.isNeedRefresh = YES;
                
                break;
                
            default:
                break;
        }
    
    };
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
            
            ///进入个要设置页面
            QSYMySettingViewController *mySettingVC = [[QSYMySettingViewController alloc] init];
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:mySettingVC animated:YES];
            
        }
        
        if (lLoginCheckActionTypeReLogin == flag) {
            
            ///刷新当前页面数据
            self.isNeedRefresh = YES;
            
        }
        
    }];

}

#pragma mark - 请求个人数据
- (void)getMyZoneCalculationData
{

    ///已经登录，才请求数据
    if (lLoginCheckActionTypeLogined == [self checkLogin]) {

        ///显示HUD
        __block QSCustomHUDView *mbHUD = [QSCustomHUDView showCustomHUDWithTips:@"正在加载"];
        
        ///获取用户信息
        self.userInfoData = [QSCoreDataManager getCurrentUserDataModel];
        
        ///请求数据
        [QSRequestManager requestDataWithType:rRequestTypeMyZoneStatistics andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///请求成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                [mbHUD hiddenCustomHUDWithFooterTips:@"加载成功" andDelayTime:1.5f andCallBack:^(BOOL flag) {
                    
                    ///刷新UI
                    self.statisticsData = resultData;
                    [self updateMyzoneUIWithLoginData];
                    
                    ///下载服务端浏览记录
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
//                        [QSLoginViewController downloadServerHistoryData];
                        
                    });
                    
                }];
                
            } else {
            
                ///提示信息
                NSString *tipsString = @"下载失败";
                if (resultData) {
                    
                    tipsString = [resultData valueForKey:@"info"];
                    
                }
                [mbHUD hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
                
            }
            
        }];
        
    } else {
    
        self.userInfoData = nil;
        self.statisticsData = nil;
        [self updateMyzoneUIWithLoginData];
    
    }

}

#pragma mark - 更新UI
- (void)updateMyzoneUIWithLoginData
{

    [self updateRenantCountInfo];
    [self updateOwnerCountInfo];
    [self updateuserIcon];
    [self updateUserName];

}

///更新用户名
- (void)updateUserName
{

    UILabel *userName = objc_getAssociatedObject(self, &UserNameKey);
    if (userName && [self.userInfoData.username length] > 0) {
        
        userName.text = self.userInfoData.username;
        
    } else {
    
        userName.text = nil;
    
    }

}

///更新房客信息
- (void)updateRenantCountInfo
{
    
    QSMyZoneTenantView *view = objc_getAssociatedObject(self, &RenantRootView);
    [view updateRentCountInfo:self.statisticsData.headerData.renantData];
    
}

///更新业主信息
- (void)updateOwnerCountInfo
{
    
    QSMyZoneOwnerView *view = objc_getAssociatedObject(self, &OwnerRootView);
    [view updateOwnerCountInfo:self.statisticsData.headerData.ownerData];
    
}

///更新用户头像
- (void)updateuserIcon
{

    UIImageView *iconView = objc_getAssociatedObject(self, &UserIconKey);
    if (iconView && [self.userInfoData.avatar length] > 0) {
        
        [iconView loadImageWithURL:[self.userInfoData.avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_158]];
        
    } else {
    
        iconView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_158];
    
    }

}

#pragma mark - 个人中心出现时显示tabbar
///个人中心出现时显示tabbar
- (void)viewWillAppear:(BOOL)animated
{
    
    ///注册系统消息监听
    [QSSocketManager registSystemMessageReceiveNotification:^(int msgNum) {
        
        if (msgNum > 0) {
            
            NSString *tipsString;
            if (msgNum > 99) {
                
                tipsString = @"99+";
                
            } else {
            
                tipsString = [NSString stringWithFormat:@"%d",msgNum];
            
            }
            
            self.systemMessageCountTipsLabel.text = tipsString;
            self.systemMessageCountTipsLabel.hidden = NO;
            
        } else {
        
            self.systemMessageCountTipsLabel.text = @"0";
            self.systemMessageCountTipsLabel.hidden = YES;
        
        }
        
    }];
    
    if (self.isNeedRefresh) {
        
        self.isNeedRefresh = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self getMyZoneCalculationData];
            
        });
        
    }
    
    [self hiddenBottomTabbar:NO];
    [super viewWillAppear:animated];
    
}

@end
