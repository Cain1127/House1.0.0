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
#import "QSCustomPickerView.h"

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
    QSCustomPickerView *houseListTypePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andPickerType:cCustomPickerTypeNavigationBarHouseMainType andPickerViewStyle:cCustomPickerStyleLeftArrow andIndicaterCenterXPoint:0.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *houseTypeKey, NSString *houseTypeVal) {
        
        NSLog(@"====================列表类型选择====================");
        NSLog(@"当前选择城市：%@,%@",houseTypeKey,houseTypeVal);
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
    
    ///频道栏底view
    UIView *channelBarRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 40.0f)];
    [self createChannelBarUI:channelBarRootView];
    [self.view addSubview:channelBarRootView];
    
}

///搭建频道栏的UI
- (void)createChannelBarUI:(UIView *)view
{
    
    ///高级筛选按钮
    UIButton *advanceFilterButton = [UIButton createBlockButtonWithFrame:CGRectMake(view.frame.size.width - 49.0f, 0.0f, 49.0f, 40.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    [advanceFilterButton setImage:[UIImage imageNamed:IMAGE_CHANNELBAR_ADVANCEFILTER_NORMAL] forState:UIControlStateNormal];
    [advanceFilterButton setImage:[UIImage imageNamed:IMAGE_CHANNELBAR_ADVANCEFILTER_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [view addSubview:advanceFilterButton];
    
    ///计算每个按钮的间隙
    CGFloat gap = SIZE_DEVICE_WIDTH > 568.0f ? 25.0f : 15.0f;
    CGFloat width = (view.frame.size.width - gap * 3.0f - 49.0f) / 3.0f;
    
    ///三个选择框的指针
    __block QSCustomPickerView *distictPickerView;
    __block QSCustomPickerView *houseTypePickerView;
    __block QSCustomPickerView *pricePickerView;
    
    ///区域
    distictPickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(gap, 0.0f, width, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarDistrict andPickerViewStyle:cCustomPickerStyleLeftArrow andIndicaterCenterXPoint:gap + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [houseTypePickerView removePickerView];
            [pricePickerView removePickerView];
            
        }
        
    }];
    [view addSubview:distictPickerView];
    
    ///户型
    houseTypePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(gap * 2.0f + width, 0.0f, width, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarHouseType andPickerViewStyle:cCustomPickerStyleLeftArrow andIndicaterCenterXPoint:gap * 2.0f + width + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [distictPickerView removePickerView];
            [pricePickerView removePickerView];
            
        }
        
    }];
    [view addSubview:houseTypePickerView];
    
    ///总价
    pricePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(gap * 3.0f + width * 2.0f, 0.0f, width, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarTotalPrice andPickerViewStyle:cCustomPickerStyleLeftArrow andIndicaterCenterXPoint:gap * 3.0f + width * 2.0f + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [houseTypePickerView removePickerView];
            [distictPickerView removePickerView];
            
        }
        
    }];
    [view addSubview:pricePickerView];

    ///底部分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height - 0.5f, view.frame.size.width, 0.5f)];
    bottomLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:bottomLineLabel];
    
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
