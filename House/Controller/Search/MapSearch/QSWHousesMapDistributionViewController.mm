//
//  QSWHousesMapDistributionViewController.m
//  House
//
//  Created by 王树朋 on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWHousesMapDistributionViewController.h"
#import "MAMapKit.h"

#import "QSHouseKeySearchViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSWHousesMapDistributionViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSNewHouseDetailViewController.h"
#import "QSCommunityDetailViewController.h"
#import "QSCustomPickerView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSFilterDataModel.h"
#import "QSHouseInfoDataModel.h"
#import "QSCommunityDataModel.h"
#import "QSNewHouseInfoDataModel.h"
#import "QSRentHouseInfoDataModel.h"
#import "QSBaseConfigurationDataModel.h"

#import "QSCoreDataManager+Filter.h"
#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+User.h"

#import "QSHouseListView.h"
#import "QSCommunityListView.h"
#import "QSRentHouseListView.h"
#import "QSNewHouseListView.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char MapDistributionViewKey;      //!<MapDistributionView的关联
static char ChannelButtonRootView;  //!<频道栏底view关联


@interface QSWHousesMapDistributionViewController ()<MAMapViewDelegate>
{
    
    MAMapView *_mapView;
    
}
@property (nonatomic,assign) FILTER_MAIN_TYPE listType;                 //!<列表类型
@property (nonatomic,retain) QSFilterDataModel *filterModel;            //!<过滤模型

@property (nonatomic,strong) QSCustomPickerView *houseListTypePickerView; //!<导航栏列表类型选择
@property (nonatomic,strong) QSCustomPickerView *distictPickerView;       //!<地区选择按钮
@property (nonatomic,strong) QSCustomPickerView *houseTypePickerView;     //!<户型选择按钮
@property (nonatomic,strong) QSCustomPickerView *pricePickerView;         //!<总价选择按钮

@end

@implementation QSWHousesMapDistributionViewController

#pragma mark - 初始化
//- (instancetype)init
//{
//
//    ///获取本地默认配置的过滤器
//    NSString *filterID = [QSCoreDataManager getCurrentUserDefaultFilterID];
//    return [self initWithHouseMainType:((filterID && [filterID length] > 0) ? [filterID intValue] : fFilterMainTypeSecondHouse)];
//
//    ///注册通知
//    [self registLocalHomePageActionNotification];
//
//}

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
            
        default:
            break;
    }
    
}




-(void)createNavigationBarUI
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
    
    
    
}


-(void)createMainShowUI
{
    
    [super createMainShowUI];
    
    ///频道栏底view
    UIView *channelBarRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 40.0f)];
    [self createChannelBarUI:channelBarRootView];
    [self.view addSubview:channelBarRootView];
    objc_setAssociatedObject(self, &ChannelButtonRootView, channelBarRootView, OBJC_ASSOCIATION_ASSIGN);
    
    
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
        
        ///高级筛选按钮
        UIButton *advanceFilterButton = [UIButton createBlockButtonWithFrame:CGRectMake(view.frame.size.width - 49.0f, 0.0f, 49.0f, 40.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
            
            ///隐藏所有弹窗
            [self hiddenAllPickerView];
            
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
            
        } else {
            
            //            if (districtCurrentModel) {
            //
            //                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:@"street_key" andResetVal:@"street_val" isCurrentModel:YES];
            //
            //            } else {
            //
            //                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:@"street_key" andResetVal:@"street_val" isCurrentModel:NO];
            //
            //            }
            
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
            
            //            if (houseTypeCurrentModel) {
            //
            //                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:houseTypeSetKey andResetVal:houseTypeSetVal isCurrentModel:YES];
            //
            //            } else {
            //
            //                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:houseTypeSetKey andResetVal:houseTypeSetVal isCurrentModel:NO];
            //
            //            }
            
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
            //
            //            if (totalPriceCurrentModel) {
            //
            //                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:totalPriceSetKey andResetVal:totalPriceSetVal isCurrentModel:YES];
            //
            //            } else {
            //
            //                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:totalPriceSetKey andResetVal:totalPriceSetVal isCurrentModel:NO];
            //
            //            }
            
        }
        
    }];
    [view addSubview:self.pricePickerView];
    
    ///底部分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height - 0.5f, view.frame.size.width, 0.5f)];
    bottomLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:bottomLineLabel];
    
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

#pragma mark - 更换列表类型处理
///更换列表类型处理
- (void)houseListTypeChangeAction:(NSString *)selectedKey
{
    
    ///更新当前保存的列表类型
    // self.listType = [selectedKey intValue];
    
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
        //[self createListView];
        
    });
    
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"0f36774bd285a275b3b8e496e45fe6d9";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 104.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-104.0f)];
    _mapView.delegate = self;
    //显示交通状况
    _mapView.showTraffic= YES;
    
    [self.view addSubview:_mapView];
}



@end
