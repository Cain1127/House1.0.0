//
//  QSHousesViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHousesViewController.h"

#import "QSHouseKeySearchViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSWHousesMapDistributionViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSNewHouseDetailViewController.h"
#import "QSCommunityDetailViewController.h"
#import "QSFilterViewController.h"
#import "QSYBrowseHouseViewController.h"

#import "QSCustomPickerView.h"
#import "QSYPopCustomView.h"
#import "QSYComparisonTipsPopView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSHouseListView.h"
#import "QSCommunityListView.h"
#import "QSRentHouseListView.h"
#import "QSNewHouseListView.h"

#import "QSFilterDataModel.h"
#import "QSHouseInfoDataModel.h"
#import "QSCommunityDataModel.h"
#import "QSNewHouseInfoDataModel.h"
#import "QSRentHouseInfoDataModel.h"
#import "QSBaseConfigurationDataModel.h"

#import "QSCoreDataManager+Filter.h"
#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+App.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char CollectionViewKey;      //!<collectionView的关联
static char ChannelButtonRootView;  //!<频道栏底view关联
static char PopViewKey;             //!<摇一摇view关联


@interface QSHousesViewController ()

@property (nonatomic,assign) FILTER_MAIN_TYPE listType;                     //!<列表类型
@property (nonatomic,retain) QSFilterDataModel *filterModel;                //!<过滤模型
@property (nonatomic,assign) BOOL isCanShake;                               //!<是否能摇一摇事件变量

@property (nonatomic,strong) QSCustomPickerView *houseListTypePickerView;   //!<导航栏列表类型选择
@property (nonatomic,strong) QSCustomPickerView *distictPickerView;         //!<地区选择按钮
@property (nonatomic,strong) QSCustomPickerView *houseTypePickerView;       //!<户型选择按钮
@property (nonatomic,strong) QSCustomPickerView *pricePickerView;           //!<总价选择按钮

@property (nonatomic,retain) NSMutableArray *secondHandHouseBrowseCounts;   //!<二手房浏览详情次数记录
@property (nonatomic,retain) NSMutableArray *rentHandHouseBrowseCounts;     //!<出租房浏览详情次数记录

@end

@implementation QSHousesViewController

#pragma mark - 初始化
- (instancetype)init
{

    ///获取本地默认配置的过滤器
    NSString *filterID = [QSCoreDataManager getCurrentUserDefaultFilterID];
    return [self initWithHouseMainType:((filterID && [filterID length] > 0) ? [filterID intValue] : fFilterMainTypeSecondHouse)];
    
    ///注册通知
    [self registLocalHomePageActionNotification];
    
    ///初始化计数数组
    self.secondHandHouseBrowseCounts = [[NSMutableArray alloc] init];
    self.rentHandHouseBrowseCounts = [[NSMutableArray alloc] init];

}

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
        
        ///获取过滤器模型
        self.filterModel = [QSCoreDataManager getLocalFilterWithType:self.listType];
        
        ///注册通知
        [self registLocalHomePageActionNotification];
        
        ///初始化计数记录数组
        self.secondHandHouseBrowseCounts = [[NSMutableArray alloc] init];
        self.rentHandHouseBrowseCounts = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

#pragma mark - 注册首页不同事件的通知
///注册首页不同事件的通知
- (void)registLocalHomePageActionNotification
{

    ///显示新房通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageNotificationAction:) name:nHomeNewHouseActionNotification object:@"1"];
    
    ///显示出租房通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageNotificationAction:) name:nHomeRentHouseActionNotification object:@"2"];
    
    ///显示二手房通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageNotificationAction:) name:nHomeSecondHandHouseActionNotification object:@"3"];
    
    ///用户更换默认城市通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangeCityInfo) name:nUserDefaultCityChanged object:nil];
    
    ///过滤器变更通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterInfoChangeAction:) name:nHouseMapListFilterInfoChanggeActionNotification object:nil];
    
    ///列表显示小区的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageNotificationAction:) name:nHomeCommunityActionNotification object:@"4"];

}

///过滤器条件变更
- (void)filterInfoChangeAction:(NSNotification *)notification
{
    
    ///获取过滤器ID
    NSString *filterID = [notification object];

    ///刷新本地过滤器
    QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:filterID];
    [self.houseListTypePickerView resetPickerViewCurrentPickedModel:tempModel];
    
    ///重置列表
    [self houseListTypeChangeAction:filterID];
    
}

///用户修改默认城市后的处理
- (void)userChangeCityInfo
{

    ///修改导航栏的显示
    QSBaseConfigurationDataModel *userCityModel = [QSCoreDataManager getCurrentUserCityModel];
    [self.houseListTypePickerView resetPickerViewCurrentPickedModel:userCityModel];
    
    ///刷新数据
    [self houseListTypeChangeAction:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse]];

}

///处理首页的不同按钮事件
- (void)homePageNotificationAction:(NSNotification *)notification
{

    ///获取参数
    int params = [notification.object intValue];
    
    switch (params) {
        case 1:
        {
            
            ///判断是否当前已是相同的列表
            if (fFilterMainTypeNewHouse == self.listType) {
                
                return;
                
            }
            
            ///修改导航栏文字
            QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:[NSString stringWithFormat:@"%d",fFilterMainTypeNewHouse]];
            [self.houseListTypePickerView resetPickerViewCurrentPickedModel:tempModel];
            
            ///列出新房
            [self houseListTypeChangeAction:[NSString stringWithFormat:@"%d",fFilterMainTypeNewHouse]];
            
        }
            break;
            
        case 2:
        {
            
            ///判断是否当前已是相同的列表
            if (fFilterMainTypeRentalHouse == self.listType) {
                
                return;
                
            }
            
            QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:[NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse]];
            [self.houseListTypePickerView resetPickerViewCurrentPickedModel:tempModel];
            
            ///列出出租房
            [self houseListTypeChangeAction:[NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse]];
            
        }
            break;
            
        case 3:
        {
            
            ///判断是否当前已是相同的列表
            if (fFilterMainTypeSecondHouse == self.listType) {
                
                return;
                
            }
            
            QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse]];
            [self.houseListTypePickerView resetPickerViewCurrentPickedModel:tempModel];
            
            ///列出二手房
            [self houseListTypeChangeAction:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse]];
            
        }
            break;
            
        case 4:
        {
            
            ///判断是否当前已是相同的列表
            if (fFilterMainTypeCommunity == self.listType) {
                
                return;
                
            }
            
            QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:[NSString stringWithFormat:@"%d",fFilterMainTypeCommunity]];
            [self.houseListTypePickerView resetPickerViewCurrentPickedModel:tempModel];
            
            ///列出二手房
            [self houseListTypeChangeAction:[NSString stringWithFormat:@"%d",fFilterMainTypeCommunity]];
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - UI搭建
///导航栏UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///中间选择列表类型按钮
    QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:self.filterModel.filter_id];
    self.houseListTypePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andPickerType:cCustomPickerTypeNavigationBarHouseMainType andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:tempModel andIndicaterCenterXPoint:0.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *selectedKey, NSString *selectedVal) {
        
        ///如果是显示选择窗口，则隐藏其他窗口
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出窗口
            [self.distictPickerView removePickerView:NO];
            [self.houseTypePickerView removePickerView:NO];
            [self.pricePickerView removePickerView:NO];
            
        }
        
        ///选择不同的列表类型，事件处理
        if (pPickerCallBackActionTypePicked == callBackType) {
            
            [self houseListTypeChangeAction:selectedKey];
            
        }
        
    }];
    [self setNavigationBarMiddleView:self.houseListTypePickerView];
    
    ///搜索按钮
    UIButton *searchButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeSearch] andCallBack:^(UIButton *button) {
        
        ///隐藏所有弹窗
        [self hiddenAllPickerView];
        
        ///进入搜索页
        [self gotoSearchViewController];
        
    }];
    [self setNavigationBarRightView:searchButton];
    
    ///地图列表按钮
    UIButton *mapListButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeLeft andButtonType:nNavigationBarButtonTypeMapList] andCallBack:^(UIButton *button) {
        
        ///隐藏所有弹窗
        [self hiddenAllPickerView];
        
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
    objc_setAssociatedObject(self, &ChannelButtonRootView, channelBarRootView, OBJC_ASSOCIATION_ASSIGN);
    
    [self createListView];
    
}

///搭建频道栏的UI
- (void)createChannelBarUI:(UIView *)view
{
    
    ///清空原UI
    for (UIView *obj in [view subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///存在高级筛选时，其他按钮需要减去的宽度
    CGFloat isAdvanceWith = 0.0f;
    
    ///如果是二手房/出租房，则创建高级筛选按钮
    if (fFilterMainTypeSecondHouse == self.listType ||
        fFilterMainTypeRentalHouse == self.listType) {
        
        ///过滤器类型
        __block FILTER_SETTINGVC_TYPE filterVCType = (self.listType == fFilterMainTypeSecondHouse) ? fFilterSettingVCTypeHouseListSecondHouse : fFilterSettingVCTypeHouseListRentHouse;
        
        ///高级筛选按钮
        UIButton *advanceFilterButton = [UIButton createBlockButtonWithFrame:CGRectMake(view.frame.size.width - 49.0f, 0.0f, 49.0f, 40.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
            
            ///隐藏所有弹窗
            [self hiddenAllPickerView];
            
            ///进入高级筛选窗口
            QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:filterVCType];
            filterVC.hiddenCustomTabbarWhenPush = YES;
            filterVC.resetFilterCallBack = ^(BOOL flag){
            
                if (flag) {
                    
                    ///重新刷新数据
                    [self houseListTypeChangeAction:[NSString stringWithFormat:@"%d",self.listType]];
                    
                }
            
            };
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:filterVC animated:YES];
            
        }];
        [advanceFilterButton setImage:[UIImage imageNamed:IMAGE_CHANNELBAR_ADVANCEFILTER_NORMAL] forState:UIControlStateNormal];
        [advanceFilterButton setImage:[UIImage imageNamed:IMAGE_CHANNELBAR_ADVANCEFILTER_HIGHLIGHTED] forState:UIControlStateHighlighted];
        [view addSubview:advanceFilterButton];
        
        ///重置需要减掉的宽度
        isAdvanceWith = 55.0f;
        
    }
    
    ///计算每个按钮的间隙
    CGFloat gap = SIZE_DEVICE_WIDTH > 320.0f ? 15.0f : 10.0f;
    CGFloat width = (view.frame.size.width - gap * 3.0f - isAdvanceWith) / 3.0f;
    
    ///区域
    __block QSBaseConfigurationDataModel *districtCurrentModel = [[QSBaseConfigurationDataModel alloc] init];
    districtCurrentModel.key = (self.filterModel.street_key && ([self.filterModel.street_key length] > 0)) ? self.filterModel.street_key : nil;
    districtCurrentModel.val = self.filterModel.street_val;
    self.distictPickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(gap, 0.0f, width, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarDistrict andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:(districtCurrentModel.key ? districtCurrentModel : nil) andIndicaterCenterXPoint:gap + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [self.houseTypePickerView removePickerView:NO];
            [self.pricePickerView removePickerView:NO];
            [self.houseListTypePickerView removePickerView:NO];
            
        } else if (pPickerCallBackActionTypePicked == callBackType) {
            
            ///查找所在区信息
            QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getDistrictModelWithStreetKey:pickedKey];
            
            ///更新所在区
            self.filterModel.district_key = APPLICATION_NSSTRING_SETTING_NIL(tempModel.key);
            self.filterModel.district_val = APPLICATION_NSSTRING_SETTING_NIL(tempModel.val);
            
            ///更新街道
            [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:@"street_key" andResetVal:@"street_val" isCurrentModel:(districtCurrentModel ? YES : NO)];
            
        } else if (pPickerCallBackActionTypeUnLimited == callBackType) {
        
            ///清空原区信息和街道信息
            self.filterModel.district_key = nil;
            self.filterModel.district_val = nil;
            
            ///更新街道，并刷新数据
            [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:@"street_key" andResetVal:@"street_val" isCurrentModel:(districtCurrentModel ? YES : NO)];
        
        }
        
    }];
    [view addSubview:self.distictPickerView];
    
    ///中间选择按钮
    __block QSBaseConfigurationDataModel *houseTypeCurrentModel = [[QSBaseConfigurationDataModel alloc] init];
    __block NSString *houseTypeSetKey = @"avg_price_key";
    __block NSString *houseTypeSetVal = @"avg_price_val";
    
    ///根据类型设置选择类型
    CUSTOM_PICKER_TYPE houseType = cCustomPickerTypeChannelBarHouseType;
    
    ///新房/小区时，中间选择项为<均价选择>
    if (fFilterMainTypeNewHouse == self.listType ||
        fFilterMainTypeCommunity == self.listType) {
        
        houseType = cCustomPickerTypeChannelBarAveragePrice;
        
        ///设置当前选择信息
        houseTypeCurrentModel.key = (self.filterModel.avg_price_key && ([self.filterModel.avg_price_key length] > 0)) ? self.filterModel.avg_price_key : nil;
        houseTypeCurrentModel.val = self.filterModel.avg_price_val;
        houseTypeSetKey = @"avg_price_key";
        houseTypeSetVal = @"avg_price_val";
        
    } else if (fFilterMainTypeSecondHouse == self.listType ||
               fFilterMainTypeRentalHouse == self.listType) {
        
        ///二手房/出租房，弹出户型价选择窗口
        houseType = cCustomPickerTypeChannelBarHouseType;
        
        ///设置当前选择信息
        houseTypeCurrentModel.key = (self.filterModel.house_type_key && ([self.filterModel.house_type_key length] > 0)) ? self.filterModel.house_type_key : nil;
        houseTypeCurrentModel.val = self.filterModel.house_type_val;
        houseTypeSetKey = @"house_type_key";
        houseTypeSetVal = @"house_type_val";
        
    }
    
    self.houseTypePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(self.distictPickerView.frame.origin.x + self.distictPickerView.frame.size.width + gap, 0.0f, width - 15.0f, view.frame.size.height) andPickerType:houseType andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:(houseTypeCurrentModel.key ? houseTypeCurrentModel : nil) andIndicaterCenterXPoint:gap * 2.0f + width + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [self.distictPickerView removePickerView:NO];
            [self.pricePickerView removePickerView:NO];
            [self.houseListTypePickerView removePickerView:NO];
            
        } else {
            
            if (houseTypeCurrentModel) {
                
                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:houseTypeSetKey andResetVal:houseTypeSetVal isCurrentModel:YES];
                
            } else {
                
                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:houseTypeSetKey andResetVal:houseTypeSetVal isCurrentModel:NO];
                
            }
            
        }
        
    }];
    [view addSubview:self.houseTypePickerView];
    
    ///频道栏第三个按钮
    __block QSBaseConfigurationDataModel *totalPriceCurrentModel = [[QSBaseConfigurationDataModel alloc] init];
    __block NSString *totalPriceSetKey = @"house_type_key";
    __block NSString *totalPriceSetVal = @"house_type_val";
    
    ///样式
    CUSTOM_PICKER_TYPE priceType = cCustomPickerTypeChannelBarTotalPrice;
    
    ///新房/小区时，最后一个选择项为户型选择
    if (fFilterMainTypeNewHouse == self.listType ||
        fFilterMainTypeCommunity == self.listType) {
        
        priceType = cCustomPickerTypeChannelBarHouseType;
        
        ///设置当前选择信息
        totalPriceCurrentModel.key = (self.filterModel.house_type_key && ([self.filterModel.house_type_key length] > 0)) ? self.filterModel.house_type_key : nil;
        totalPriceCurrentModel.val = self.filterModel.house_type_val;
        totalPriceSetKey = @"house_type_key";
        totalPriceSetVal = @"house_type_val";
        
    } else if (fFilterMainTypeSecondHouse == self.listType) {
        
        ///二手房，弹出总价选择窗口
        priceType = cCustomPickerTypeChannelBarTotalPrice;
        
        ///设置当前选择信息
        totalPriceCurrentModel.key = (self.filterModel.sale_price_key && ([self.filterModel.sale_price_key length] > 0)) ? self.filterModel.sale_price_key : nil;
        totalPriceCurrentModel.val = self.filterModel.sale_price_val;
        totalPriceSetKey = @"sale_price_key";
        totalPriceSetVal = @"sale_price_val";
        
    } else if (fFilterMainTypeRentalHouse == self.listType) {
        
        ///出租房，弹出租金选择窗口
        priceType = cCustomPickerTypeChannelBarRentPrice;
        
        ///设置当前选择信息
        totalPriceCurrentModel.key = (self.filterModel.rent_price_key && ([self.filterModel.rent_price_key length] > 0)) ? self.filterModel.rent_price_key : nil;
        totalPriceCurrentModel.val = self.filterModel.rent_price_val;
        totalPriceSetKey = @"rent_price_key";
        totalPriceSetVal = @"rent_price_val";
        
    }
    
    self.pricePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(self.houseTypePickerView.frame.origin.x + self.houseTypePickerView.frame.size.width + gap, 0.0f, width + 5.0f, view.frame.size.height) andPickerType:priceType andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:(totalPriceCurrentModel.key ? totalPriceCurrentModel : nil) andIndicaterCenterXPoint:gap * 3.0f + width * 2.0f + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [self.houseTypePickerView removePickerView:NO];
            [self.houseListTypePickerView removePickerView:NO];
            [self.distictPickerView removePickerView:NO];
            
        } else {
            
            if (totalPriceCurrentModel) {
                
                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:totalPriceSetKey andResetVal:totalPriceSetVal isCurrentModel:YES];
                
            } else {
                
                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:totalPriceSetKey andResetVal:totalPriceSetVal isCurrentModel:NO];
                
            }
            
        }
        
    }];
    [view addSubview:self.pricePickerView];

    ///底部分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height - 0.5f, view.frame.size.width, 0.5f)];
    bottomLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:bottomLineLabel];
    
}

///搭建列表的UI
- (void)createListView
{
    
    ///先清除原列表
    UIView *localListView = objc_getAssociatedObject(self, &CollectionViewKey);
    if (localListView) {
        
        [localListView removeFromSuperview];
        
    }

    ///根据不同的类型，创建不同的列表UI
    switch (self.listType) {
            ///楼盘列表
        case fFilterMainTypeBuilding:
            
            break;
            
            ///新房列表
        case fFilterMainTypeNewHouse:
        {
        
            QSNewHouseListView *listView = [[QSNewHouseListView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 40.0f + 20.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - 40.0f - 20.0f) andHouseListType:self.listType andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
                ///过滤回调类型
                switch (actionType) {
                        ///进入详情页
                    case hHouseListActionTypeGotoDetail:
                        
                        [self gotoHouseDetail:tempModel];
                        
                        break;
                        
                        ///显示暂无记录
                    case hHouseListActionTypeNoRecord:
                        
                        [self showNoRecordTips:YES];
                        
                        break;
                        
                        ///移除暂无记录
                    case hHouseListActionTypeHaveRecord:
                        
                        [self showNoRecordTips:NO];
                        
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            listView.alwaysBounceVertical = YES;
            [self.view addSubview:listView];
            objc_setAssociatedObject(self, &CollectionViewKey, listView, OBJC_ASSOCIATION_ASSIGN);
        
        }
            break;
                        
            ///小区列表
        case fFilterMainTypeCommunity:
        {
        
            ///创建小区/新房的列表UI
            QSCommunityListView *listView = [[QSCommunityListView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 40.0f + 20.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - 40.0f - 20.0f) andHouseListType:self.listType andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
                ///过滤回调类型
                switch (actionType) {
                        ///进入详情页
                    case hHouseListActionTypeGotoDetail:
                        
                        [self gotoHouseDetail:tempModel];
                        
                        break;
                        
                        ///显示暂无记录
                    case hHouseListActionTypeNoRecord:
                        
                        [self showNoRecordTips:YES];
                        
                        break;
                        
                        ///移除暂无记录
                    case hHouseListActionTypeHaveRecord:
                        
                        [self showNoRecordTips:NO];
                        
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            listView.alwaysBounceVertical = YES;
            [self.view addSubview:listView];
            objc_setAssociatedObject(self, &CollectionViewKey, listView, OBJC_ASSOCIATION_ASSIGN);
        
        }
            break;
            
            ///二手房列表
        case fFilterMainTypeSecondHouse:
        {
        
            ///瀑布流布局器
            QSHouseListView *listView = [[QSHouseListView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 40.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - 40.0f) andHouseListType:self.listType andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType,id tempModel) {
                
                ///过滤回调类型
                switch (actionType) {
                        ///进入详情页
                    case hHouseListActionTypeGotoDetail:
                        
                        [self gotoHouseDetail:tempModel];
                        
                        break;
                        
                        ///显示暂无记录
                    case hHouseListActionTypeNoRecord:
                        
                        [self showNoRecordTips:YES];
                        
                        break;
                        
                        ///移除暂无记录
                    case hHouseListActionTypeHaveRecord:
                        
                        [self showNoRecordTips:NO];
                        
                        break;
                        
                        
                        ///摇一摇
                    case hHouseListActionTypeShake:
                        
                        [self popShakeGuideView];
                        
                        break;

                        
                    default:
                        break;
                }
                
            }];
            
            listView.alwaysBounceVertical = YES;
            [self.view addSubview:listView];
            objc_setAssociatedObject(self, &CollectionViewKey, listView, OBJC_ASSOCIATION_ASSIGN);
        
        }
            break;
            
            ///出租房列表
        case fFilterMainTypeRentalHouse:
        {
        
            QSRentHouseListView *listView = [[QSRentHouseListView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 40.0f + 20.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - 40.0f - 20.0f) andHouseListType:self.listType andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
                ///过滤回调类型
                switch (actionType) {
                        ///进入详情页
                    case hHouseListActionTypeGotoDetail:
                        
                        [self gotoHouseDetail:tempModel];
                        
                        break;
                        
                        ///显示暂无记录
                    case hHouseListActionTypeNoRecord:
                        
                        [self showNoRecordTips:YES];
                        
                        break;
                        
                        ///移除暂无记录
                    case hHouseListActionTypeHaveRecord:
                        
                        [self showNoRecordTips:NO];
                        
                        break;
                        
                        ///摇一摇
                    case hHouseListActionTypeShake:
                        
                        [self popShakeGuideView];
                        
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            listView.alwaysBounceVertical = YES;
            [self.view addSubview:listView];
            objc_setAssociatedObject(self, &CollectionViewKey, listView, OBJC_ASSOCIATION_ASSIGN);
        
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 所有弹窗回收
///所有弹窗回收
- (void)hiddenAllPickerView
{

    ///导航栏列表类型选择窗口
    if (self.houseListTypePickerView) {
        
        [self.houseListTypePickerView removePickerView:NO];
        
    }
    
    ///区选择窗口
    if (self.distictPickerView) {
        
        [self.distictPickerView removePickerView:NO];
        
    }
    
    ///户型选择窗口
    if (self.houseTypePickerView) {
        
        [self.houseTypePickerView removePickerView:NO];
        
    }
    
    ///总价选择窗口
    if (self.pricePickerView) {
        
        [self.pricePickerView removePickerView:NO];
        
    }

}

#pragma mark - 频道栏过滤后事件统一处理
- (void)channelBarButtonAction:(PICKER_CALLBACK_ACTION_TYPE)callBackType andPickedKey:(NSString *)pickedKey andPickedVal:(NSString *)pickedVal andResetKey:(NSString *)setKey andResetVal:(NSString *)setVal isCurrentModel:(BOOL)isCurrentModel
{

    ///不限
    if ((pPickerCallBackActionTypeUnLimited == callBackType) && isCurrentModel) {
        
        ///更新过滤器
        [self.filterModel setValue:@"" forKey:setKey];
        [self.filterModel setValue:@"" forKey:setVal];
        
        ///更新本地对应的过滤器
        self.filterModel.filter_status = @"2";
        
        ///保存过滤器
        [QSCoreDataManager updateFilterWithType:self.listType andFilterDataModel:self.filterModel andUpdateCallBack:^(BOOL isSuccess) {
            
            ///保存成功后进入房子列表
            if (isSuccess) {
                
                ///刷新数据
                UICollectionView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
                [collectionView headerBeginRefreshing];
                NSLog(@"====================过滤器保存成功=====================");
                
            } else {
                
                NSLog(@"====================过滤器保存失败=====================");
                
            }
            
        }];
        
        ///将过滤器设置为当前用户的默认过滤器
        [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",self.listType] andCallBack:^(BOOL isSuccess) {}];
        
    }
    
    ///选择了内容
    if (pPickerCallBackActionTypePicked == callBackType) {
        
        ///更新过滤器
        [self.filterModel setValue:pickedKey ? pickedKey : @"" forKey:setKey];
        [self.filterModel setValue:pickedVal ? pickedVal : @"" forKey:setVal];
        
        ///更新本地对应的过滤器
        self.filterModel.filter_status = @"2";
        
        ///保存过滤器
        [QSCoreDataManager updateFilterWithType:self.listType andFilterDataModel:self.filterModel andUpdateCallBack:^(BOOL isSuccess) {
            
            ///保存成功后进入房子列表
            if (isSuccess) {
                
                ///刷新数据
                UICollectionView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
                [collectionView headerBeginRefreshing];
                NSLog(@"====================过滤器保存成功=====================");
                
            } else {
                
                NSLog(@"====================过滤器保存失败=====================");
                
            }
            
        }];
        
        ///将过滤器设置为当前用户的默认过滤器
        [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",self.listType] andCallBack:^(BOOL isSuccess) {}];
        
    }

}

#pragma mark - 更换列表类型处理
///更换列表类型处理
- (void)houseListTypeChangeAction:(NSString *)selectedKey
{

    ///更新当前保存的列表类型
    self.listType = [selectedKey intValue];
    
    ///更新过滤器
    self.filterModel = [QSCoreDataManager getLocalFilterWithType:self.listType];
    
    ///更新用户默认过滤器
    [QSCoreDataManager updateCurrentUserDefaultFilter:selectedKey andCallBack:^(BOOL isSuccess) {}];
    
    ///加载不同的UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///重新创建频道栏按钮
        UIView *channelRootView = objc_getAssociatedObject(self, &ChannelButtonRootView);
        [self createChannelBarUI:channelRootView];
        
        ///重新创建列表数据
        [self createListView];
        
    });

}

#pragma mark - 进入搜索页面
///进入搜索页面
- (void)gotoSearchViewController
{
  
    QSHouseKeySearchViewController *searchVC = [[QSHouseKeySearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma mark - 进入地图列表
///进入地图列表
- (void)gotoMapListViewController
{
    
    QSWHousesMapDistributionViewController *mapHouseListVC = [[QSWHousesMapDistributionViewController alloc] init];
    mapHouseListVC.hiddenCustomTabbarWhenPush = YES;
    [self hiddenBottomTabbar:YES];
    [self.navigationController pushViewController:mapHouseListVC animated:YES];

}

#pragma mark - 点击房源进入房源详情页
///点击房源
- (void)gotoHouseDetail:(id)dataModel
{
    
    ///根据不同的列表，进入同的详情页
    switch (self.listType) {
            ///进入新房详情
        case fFilterMainTypeNewHouse:
        {
        
            ///获取房子模型
            QSNewHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSNewHouseDetailViewController *detailVC = [[QSNewHouseDetailViewController alloc] initWithTitle:houseInfoModel.title andLoupanID:houseInfoModel.loupan_id andLoupanBuildingID:houseInfoModel.loupan_building_id andDetailType:self.listType];
            detailVC.hiddenCustomTabbarWhenPush = YES;
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
        
        }
            break;
            
            ///进入小区详情
        case fFilterMainTypeCommunity:
        {
            
            ///获取房子模型
            QSCommunityDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSCommunityDetailViewController *detailVC = [[QSCommunityDetailViewController alloc] initWithTitle:houseInfoModel.title andCommunityID:houseInfoModel.id_ andCommendNum:@"10" andHouseType:@"second"];
            detailVC.hiddenCustomTabbarWhenPush = YES;
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///进入二手房详情
        case fFilterMainTypeSecondHouse:
        {
            
            ///获取房子模型
            QSHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:houseInfoModel.village_name andDetailID:houseInfoModel.id_ andDetailType:self.listType];
            detailVC.hiddenCustomTabbarWhenPush = YES;
            [self hiddenBottomTabbar:YES];
            
            ///保存浏览记录数的回调
            detailVC.loadingSuccessCallBack = ^(BOOL flag,NSString *detailID){
            
                ///保存浏览计数
                if (flag) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                       
                        ///添加二手房的浏览记录
                        [self addSecondHandHouseBrowseRecord:detailID];
                        
                    });
                    
                }
            
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///进入出租房详情
        case fFilterMainTypeRentalHouse:
        {
            
            ///获取房子模型
            QSRentHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:houseInfoModel.village_name andDetailID:houseInfoModel.id_ andDetailType:self.listType];
            detailVC.hiddenCustomTabbarWhenPush = YES;
            [self hiddenBottomTabbar:YES];
            
            ///保存浏览记录数的回调
            detailVC.loadingSuccessCallBack = ^(BOOL flag,NSString *detailID){
                
                ///保存浏览计数
                if (flag) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        ///添加出租房的浏览记录
                        [self addRentHandHouseBrowseRecord:detailID];
                        
                    });
                    
                }
                
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 添加二手房详情浏览记数
///添加二手房详情浏览记数
- (void)addSecondHandHouseBrowseRecord:(NSString *)detailID
{

    ///原来已有记录，则不再重复添加
    for (int i = 0; i < [self.secondHandHouseBrowseCounts count]; i++) {
        
        NSString *tempString = self.secondHandHouseBrowseCounts[i];
        if ([tempString isEqualToString:detailID]) {
            
            return;
            
        }
        
    }
    
    ///添加
    [self.secondHandHouseBrowseCounts addObject:detailID];

}

#pragma mark - 添加出租房的详情浏览记数
///添加出租房的详情浏览记数
- (void)addRentHandHouseBrowseRecord:(NSString *)detailID
{

    ///原来已有记录，则不再重复添加
    for (int i = 0; i < [self.rentHandHouseBrowseCounts count]; i++) {
        
        NSString *tempString = self.rentHandHouseBrowseCounts[i];
        if ([tempString isEqualToString:detailID]) {
            
            return;
            
        }
        
    }
    
    ///添加
    [self.rentHandHouseBrowseCounts addObject:detailID];

}

#pragma mark - 房源列表显示时，判断是否满足比一比
- (void)viewDidAppear:(BOOL)animated
{

    ///判断是否满足比一比条件
    if ([self.secondHandHouseBrowseCounts count] >= 1) {
        
        ///弹出比一比提示
        __block QSYPopCustomView *popView;
        
        QSYComparisonTipsPopView *tipsView = [[QSYComparisonTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 119.0f, SIZE_DEVICE_WIDTH, 119.0f) andShareCallBack:^(COMPARISION_TIPS_ACTION_TYPE actionType) {
            
            ///回收弹出窗口
            [popView hiddenCustomPopview];
            
            ///清空记录
            [self.secondHandHouseBrowseCounts removeAllObjects];
            
            ///确定
            if (cComparisonTipsActionTypeConfirm == actionType) {
                
                ///跟转到比一比页面
                QSYBrowseHouseViewController *historyVC = [[QSYBrowseHouseViewController alloc] initWithHouseType:self.listType];
                historyVC.hiddenCustomTabbarWhenPush = YES;
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:historyVC animated:YES];
                
            }
            
        }];
        
        ///弹出提示框
        popView = [QSYPopCustomView popCustomView:tipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
            
            if (cCustomPopviewActionTypeDefault == actionType) {
                
                ///回收弹出窗口
                [popView hiddenCustomPopview];
                
                ///清空记录
                [self.secondHandHouseBrowseCounts removeAllObjects];
                
            }
            
        }];
        
    }
    
    ///判断是否满足比一比条件
    if ([self.rentHandHouseBrowseCounts count] >= 10) {
        
        ///弹出比一比提示
        __block QSYPopCustomView *popView;
        
        QSYComparisonTipsPopView *tipsView = [[QSYComparisonTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 119.0f, SIZE_DEVICE_WIDTH, 119.0f) andShareCallBack:^(COMPARISION_TIPS_ACTION_TYPE actionType) {
            
            ///回收弹出窗口
            [popView hiddenCustomPopview];
            
            ///清空记录
            [self.rentHandHouseBrowseCounts removeAllObjects];
            
            ///确定
            if (cComparisonTipsActionTypeConfirm == actionType) {
                
                ///跟转到比一比页面
                QSYBrowseHouseViewController *historyVC = [[QSYBrowseHouseViewController alloc] initWithHouseType:self.listType];
                historyVC.hiddenCustomTabbarWhenPush = YES;
                [self hiddenBottomTabbar:YES];
                [self.navigationController pushViewController:historyVC animated:YES];
                
            }
            
        }];
        
        ///弹出提示框
        popView = [QSYPopCustomView popCustomView:tipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
            
            if (cCustomPopviewActionTypeDefault == actionType) {
                
                ///回收弹出窗口
                [popView hiddenCustomPopview];
                
                ///清空记录
                [self.rentHandHouseBrowseCounts removeAllObjects];
                
            }
            
        }];
        
    }
    
    [super viewDidAppear:animated];

}

#pragma mark - 弹出摇一摇提示页面
///弹出摇一摇提示页面
- (void)popShakeGuideView
{
    
    ///弹出视图
    QSYPopCustomView *popView;
    
    ///底view
    CGFloat maxHeight = 155.0f;
    CGFloat ypoint = (SIZE_DEVICE_HEIGHT - maxHeight) / 2.0f;
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, ypoint, SIZE_DEVICE_WIDTH, maxHeight)];
    
    ///提示图片
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake((rootView.frame.size.width - 95.0f) / 2.0f, 0.0f, 95.0f, 125.0f)];
    iconImgView.image = [UIImage imageNamed:IMAGE_PUBLIC_SHAKE];
    [rootView addSubview:iconImgView];
    
    ///说明信息
    UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, iconImgView.frame.origin.y + iconImgView.frame.size.height, rootView.frame.size.width, 30.0f)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [titleLabel setText:@"摇一摇查看推荐房源"];
    [rootView addSubview:titleLabel];
    
    ///弹出
    popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:rootView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];
    objc_setAssociatedObject(self, &PopViewKey, popView, OBJC_ASSOCIATION_ASSIGN);
    
    ///开启摇一摇感应
    self.isCanShake = YES;
    
}

#pragma mark - 摇一摇事件
///摇一摇事件接收入口
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    ///判断当前是否可以摇一摇
    if (self.isCanShake) {
        
        QSYPopCustomView *popView=objc_getAssociatedObject(self, &PopViewKey);
        if (![popView isHidden]) {
            
            [popView hiddenCustomPopview];
            
            ///重置摇一摇状态
            self.isCanShake = NO;
            
            ///刷新
            UICollectionView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
            if ([collectionView respondsToSelector:@selector(loadRecommendHouse)]) {
                
                [collectionView performSelector:@selector(loadRecommendHouse)];
                
            }
            
        }
        
    }
    
}

@end
