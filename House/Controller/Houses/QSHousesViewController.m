//
//  QSHousesViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHousesViewController.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSHouseKeySearchViewController.h"
#import "QSWHousesMapDistributionViewController.h"
#import "QSNavigationBarPickerView.h"

@interface QSHousesViewController ()

@property (nonatomic,assign) FILTER_MAIN_TYPE listType;//!<列表类型

@end

@implementation QSHousesViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-01-30 08:01:06
 *
 *  @brief          根据不同的过滤类型创建房子列表：默认是二手房列表
 *
 *  @param mainType 过滤中房子的主要类型
 *
 *  @return         返回当前创建的房子列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithHouseMainType:(FILTER_MAIN_TYPE)mainType
{

    if (self = [super init]) {
        
        ///保存列表类型
        self.listType = mainType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///导航栏UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///中间选择城市按钮
    QSNavigationBarPickerView *houseListTypePickerView = [[QSNavigationBarPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andPickerType:nNavigationBarPickerStyleTypeHouseMainType andPickerViewStyle:nNavigationBarPickerStyleLeftArrow andPickedCallBack:^(NSString *cityKey, NSString *cityVal) {
        
        NSLog(@"====================列表类型选择====================");
        NSLog(@"当前选择城市：%@,%@",cityKey,cityVal);
        NSLog(@"====================列表类型选择====================");
        
    }];
    [self setNavigationBarMiddleView:houseListTypePickerView];
    
    ///搜索按钮
    UIButton *searchButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeSearch] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoSearchViewController];
        
    }];
    [self setNavigationBarRightView:searchButton];
    
    ///地图列表按钮
    UIButton *mapListButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeLeft andButtonType:nNavigationBarButtonTypeMapList] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoMapListViewController];
        
    }];
    [self setNavigationBarLeftView:mapListButton];

}

///搭建主展示UI
- (void)createMainShowUI
{
    
    ///由于此页面是放置在tabbar页面上的，所以中间可用的展示高度是设备高度减去导航栏和底部tabbar的高度
//    CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f - 49.0f;
    
}

#pragma mark - 进入搜索页面
///进入搜索页面
- (void)gotoSearchViewController
{
  
    QSHouseKeySearchViewController *searchVC=[[QSHouseKeySearchViewController alloc]init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
    
}

#pragma mark - 进入地图列表
///进入地图列表
- (void)gotoMapListViewController
{
    
    QSWHousesMapDistributionViewController *VC=[[QSWHousesMapDistributionViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];

}

@end
