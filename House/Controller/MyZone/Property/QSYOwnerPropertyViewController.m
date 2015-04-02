//
//  QSYOwnerPropertyViewController.m
//  House
//
//  Created by ysmeng on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYOwnerPropertyViewController.h"
#import "QSYReleaseSaleHouseViewController.h"
#import "QSYReleaseRentHouseViewController.h"

#import "QSYPopCustomView.h"
#import "QSYSaleOrRentHouseTipsView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

@interface QSYOwnerPropertyViewController ()

///当前的房源类型
@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;

@end

@implementation QSYOwnerPropertyViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-02 22:04:10
 *
 *  @brief              创建物业管理页
 *
 *  @param houseType    当前默认的房源类型：通过此类型，将会显示对应类型的列表
 *
 *  @return             返回当前创建的物业管理页
 *
 *  @since              1.0.0
 */
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存默认类型
        self.houseType = houseType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"我的物业"];
    
    ///增加物业按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeAdd];
    
    UIButton *addButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///弹出发布物业咨询页面
        [self popReleaseHouseTipsView];
        
    }];
    addButton.hidden = YES;
    [self setNavigationBarRightView:addButton];

}

- (void)popReleaseHouseTipsView
{

    ///弹出窗口的指针
    __block QSYPopCustomView *popView = nil;
    
    ///提示选择窗口
    QSYSaleOrRentHouseTipsView *saleTipsView = [[QSYSaleOrRentHouseTipsView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 134.0f) andCallBack:^(SALE_RENT_HOUSE_TIPS_ACTION_TYPE actionType) {
        
        ///加收弹出窗口
        [popView hiddenCustomPopview];
        
        ///进入发布物业的窗口
        if (sSaleRentHouseTipsActionTypeSale == actionType) {
            
            ///进入发布物业过滤窗口
            QSYReleaseSaleHouseViewController *releaseRentHouseVC = [[QSYReleaseSaleHouseViewController alloc] init];
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
            
        }
        
        ///进入发布出租物业添加窗口
        if (sSaleRentHouseTipsActionTypeRent == actionType) {
            
            ///进入发布出租物业添加窗口
            QSYReleaseRentHouseViewController *releaseRentHouseVC = [[QSYReleaseRentHouseViewController alloc] init];
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
            
        }
        
    }];
    
    ///弹出窗口
    popView = [QSYPopCustomView popCustomView:saleTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];

}

@end
