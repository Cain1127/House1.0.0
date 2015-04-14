//
//  QSWHousesMapDistributionViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWHousesMapDistributionViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "QSCustomAnnotationView.h"

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

#import "QSMapCommunityDataModel.h"
#import "QSMapCommunityListReturnData.h"

#import "QSHousesViewController.h"

#import "MJRefresh.h"
#import "QSCustomHUDView.h"

#import <objc/runtime.h>

#define APIKey      @"0f36774bd285a275b3b8e496e45fe6d9"

#define kDefaultLocationZoomLevel       16.1
#define kDefaultControlMargin           22
#define kDefaultCalloutViewMargin       -8


///关联
static char ChannelButtonRootView;  //!<频道栏底view关联

@interface QSWHousesMapDistributionViewController ()<MAMapViewDelegate,AMapSearchDelegate,CLLocationManagerDelegate>
{
    
    MAMapView *_mapView;                        //!<地图
    AMapSearchAPI *_search;                     //!<搜索服务
    CLLocation *_currentLocation;               //!<用户当前地理位置
    CLLocationManager  *_locationmanager;       //!<定位管理器
    
}

@property (nonatomic,assign) FILTER_MAIN_TYPE listType;                     //!<列表类型
@property (nonatomic,retain) QSFilterDataModel *filterModel;                //!<过滤模型

@property (nonatomic,strong) QSCustomPickerView *houseListTypePickerView;   //!<导航栏列表类型选择
@property (nonatomic,strong) QSCustomPickerView *distictPickerView;         //!<地区选择按钮
@property (nonatomic,strong) QSCustomPickerView *houseTypePickerView;       //!<户型选择按钮
@property (nonatomic,strong) QSCustomPickerView *pricePickerView;           //!<总价选择按钮

@property (nonatomic,retain) QSCustomHUDView *hud;                          //!<HUD

///数据源
@property (nonatomic,retain) QSMapCommunityListReturnData *dataSourceModel;
@property (nonatomic,copy) NSString *title;                                 //!<小区名称
@property (nonatomic,copy) NSString *subtitle;                              //!<每个小区的房源套数或价钱
@property (nonatomic,assign) CGFloat latitude;                              //!<网络请求的经度
@property (nonatomic,assign) CGFloat longtude;                              //!<网络请求的纬度
@property (nonatomic,copy) NSString *coordinate_x;                          //!<网络搜索小区返回的经度
@property (nonatomic,copy) NSString *coordinate_y;                          //!<网络搜索小区返回的纬度

///点击房源时的回调
@property (nonatomic,copy) void (^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

@end

@implementation QSWHousesMapDistributionViewController

#pragma mark - 初始化
- (instancetype)init
{
    
    ///获取本地默认配置的过滤器
    NSString *filterID = [QSCoreDataManager getCurrentUserDefaultFilterID];
    return [self initWithHouseMainType:((filterID && [filterID length] > 0) ? (FILTER_MAIN_TYPE)[filterID intValue] : fFilterMainTypeSecondHouse)];
    
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
        
    }
    
    return self;
    
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
            
            ///发送过滤器变更通知
            [[NSNotificationCenter defaultCenter] postNotificationName:nHouseMapListFilterInfoChanggeActionNotification object:selectedKey];
            
            [self houseListTypeChangeAction:selectedKey];
            
        }
        
    }];
    [self setNavigationBarMiddleView:self.houseListTypePickerView];
    
    
}

///搭建主展示UI
- (void)createMainShowUI
{
    
    ///频道栏底view
    UIView *channelBarRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 40.0f)];
    [self createChannelBarUI:channelBarRootView];
    [self.view addSubview:channelBarRootView];
    objc_setAssociatedObject(self, &ChannelButtonRootView, channelBarRootView, OBJC_ASSOCIATION_ASSIGN);
    
    [self initMapView];
    
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
            
            if (districtCurrentModel) {
                
                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:@"street_key" andResetVal:@"street_val" isCurrentModel:YES];
                
            } else {
                
                [self channelBarButtonAction:callBackType andPickedKey:pickedKey andPickedVal:pickedVal andResetKey:@"street_key" andResetVal:@"street_val" isCurrentModel:NO];
                
            }
            
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
    if (pPickerCallBackActionTypeUnLimited == callBackType) {
        
        ///判断原来是否已有选择，如果原来就不限，则不刷新，如果原来有选择项，现在重新不限，则刷新
        if (isCurrentModel) {
            
            ///更新过滤器
            [self.filterModel setValue:@"" forKey:setKey];
            [self.filterModel setValue:@"" forKey:setVal];
            
            ///更新本地对应的过滤器
            self.filterModel.filter_status = @"2";
            
            ///刷新数据
            
            //            UIView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
            //[collectionView.header beginRefreshing];
            
            ///保存过滤器
            [QSCoreDataManager updateFilterWithType:self.listType andFilterDataModel:self.filterModel andUpdateCallBack:^(BOOL isSuccess) {
                
                ///保存成功后进入房子列表
                if (isSuccess) {
                    
                    [self MapCommunityListHeaderRequest];
                    
                    NSLog(@"====================过滤器保存成功=====================");
                    
                } else {
                    
                    NSLog(@"====================过滤器保存失败=====================");
                    
                }
                
            }];
            
            ///将过滤器设置为当前用户的默认过滤器
            [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",self.listType] andCallBack:^(BOOL isSuccess) {}];
            
        }
        
        ///发送过滤器变更通知
        [[NSNotificationCenter defaultCenter] postNotificationName:nHouseMapListFilterInfoChanggeActionNotification object:[NSString stringWithFormat:@"%d",self.listType]];
        
    }
    
    ///选择了内容
    if (pPickerCallBackActionTypePicked == callBackType) {
        
        ///更新过滤器
        [self.filterModel setValue:pickedKey ? pickedKey : @"" forKey:setKey];
        [self.filterModel setValue:pickedVal ? pickedVal : @"" forKey:setVal];
        
        ///更新本地对应的过滤器
        self.filterModel.filter_status = @"2";
        
        ///刷新数据
        
        //        UIView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
        //[collectionView.header beginRefreshing];
        
        ///保存过滤器
        [QSCoreDataManager updateFilterWithType:self.listType andFilterDataModel:self.filterModel andUpdateCallBack:^(BOOL isSuccess) {
            
            ///保存成功后进入房子列表
            if (isSuccess) {
                
                
                [self geoAction];
                
                NSLog(@"====================过滤器保存成功=====================");
                
            } else {
                
                NSLog(@"====================过滤器保存失败=====================");
                
            }
            
        }];
        
        ///将过滤器设置为当前用户的默认过滤器
        [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",self.listType] andCallBack:^(BOOL isSuccess) {}];
        
        ///发送过滤器变更通知
        [[NSNotificationCenter defaultCenter] postNotificationName:nHouseMapListFilterInfoChanggeActionNotification object:[NSString stringWithFormat:@"%d",self.listType]];
        
    }
    
}

#pragma mark - 更换列表类型处理
///更换列表类型处理
- (void)houseListTypeChangeAction:(NSString *)selectedKey
{
    
    ///更新当前保存的列表类型
    self.listType = (FILTER_MAIN_TYPE)[selectedKey intValue];
    
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
        [self MapCommunityListHeaderRequest];
        
    });
    
}

#pragma mark - 点击房源进入房源详情页
///点击房源
- (void)gotoHouseDetail:(NSString *)title andDetailID:(NSString *)detailID
{
    
    ///根据不同的列表，进入同的详情页
    switch (self.listType) {
            ///进入新房详情
            //        case fFilterMainTypeNewHouse:
            //        {
            //
            //            ///获取房子模型
            //            QSNewHouseInfoDataModel *houseInfoModel = dataModel;
            //
            //            ///进入详情页面
            //            QSNewHouseDetailViewController *detailVC = [[QSNewHouseDetailViewController alloc] initWithTitle:houseInfoModel.title andLoupanID:houseInfoModel.loupan_id andLoupanBuildingID:houseInfoModel.loupan_building_id andDetailType:self.listType];
            //            [self hiddenBottomTabbar:YES];
            //            [self.navigationController pushViewController:detailVC animated:YES];
            //
            //        }
            //            break;
            
            ///进入小区详情
            //        case fFilterMainTypeCommunity:
            //        {
            //
            //            ///获取房子模型
            //            QSCommunityDataModel *houseInfoModel = dataModel;
            //
            //            ///进入详情页面
            //            QSCommunityDetailViewController *detailVC = [[QSCommunityDetailViewController alloc] initWithTitle:houseInfoModel.title andCommunityID:houseInfoModel.id_ andCommendNum:@"10" andHouseType:@"second"];
            //            [self.navigationController pushViewController:detailVC animated:YES];
            //
            //        }
            //            break;
            
            ///进入二手房详情
        case fFilterMainTypeSecondHouse:
        {
            
            ///进入详情页面
            QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:title andDetailID:detailID andDetailType:self.listType];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///进入出租房详情
        case fFilterMainTypeRentalHouse:
        {
            
            ///进入详情页面
            QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:title andDetailID:detailID andDetailType:self.listType];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark--地图相关
///初始化地图
- (void)initMapView

{
    
    [MAMapServices sharedServices].apiKey = APIKey;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 104.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-104.0f)];
    
    _mapView.delegate = self;
    
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, kDefaultControlMargin);
    
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, kDefaultControlMargin);
    
    // 2.设置地图类型
    _mapView.mapType = MAMapTypeStandard;
    
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    
    [_mapView setZoomLevel:kDefaultLocationZoomLevel animated:YES];
    
    [self initSearch];
    
    if (self.filterModel.street_val) {
        ///发起地理编码
        [self geoAction];
    }
    
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ///发起用户定位
            [self locateAction];
            
        });
    }
    
}

- (void)initSearch
{
    _search = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
}

///用户定位
- (void)locateAction
{
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    
    _locationmanager = [[CLLocationManager alloc] init];
    [_locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
    [_locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
    _locationmanager.delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self MapCommunityListHeaderRequest];
        
    });
    
    
}

///定位跟踪代理事件
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation

{
    
    //NSLog(@"用户定位跟踪数据: %@", userLocation.location);
    
    if (updatingLocation)
        
    {
        
        _currentLocation = [userLocation.location copy];
        
    }
    
    [_locationmanager stopUpdatingLocation];
    
}

#pragma mark-地理编码
///发起地理编码
- (void)geoAction
{
    
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc] init];
    
    request.address=[NSString  stringWithFormat:@"%@%@%@%@",self.filterModel.province_val,self.filterModel.city_val,self.filterModel.district_val,self.filterModel.street_val];
    [_search AMapGeocodeSearch:request];
}

///地理编码结果返回
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"地理编码错误返回数据 :%@, error :%@", request, error);
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:
(AMapGeocodeSearchResponse *)response
{
    //NSLog(@"请求地址:%@",request);
    NSLog(@"地理编码数据 :%@", response);
    NSArray *geoArray=[[NSArray alloc] init];
    geoArray=response.geocodes;
    
    for (id item in geoArray) {
        NSLog(@" item :%@",item);
        if (item&&[item isKindOfClass:[AMapGeocode class]]) {
            
            AMapGeocode *tempdata = (AMapGeocode*)item;
            AMapGeoPoint *location = tempdata.location;
            _latitude=location.latitude;
            _longtude=location.longitude;
            
        }
        
    }
    [self MapCommunityListHeaderRequest];
    
}

#pragma mark --添加大头针气泡

- (void)addAnnotations
{
    
    NSMutableArray *annoArray=[[NSMutableArray alloc] init];
    
    for (int i=0; i<[self.dataSourceModel.mapCommunityListHeaderData.communityList count]; i++) {
        
        QSMapCommunityDataModel *tempModel = self.dataSourceModel.mapCommunityListHeaderData.communityList[i];
        self.title=tempModel.mapCommunityDataSubModel.title;
        self.subtitle=tempModel.total_num;
        self.coordinate_x=tempModel.mapCommunityDataSubModel.coordinate_x;
        self.coordinate_y=tempModel.mapCommunityDataSubModel.coordinate_y;
        APPLICATION_LOG_INFO(@"网络返回大头针经度坐标:", self.coordinate_x);
        APPLICATION_LOG_INFO(@"网络返回大头针纬度坐标:", self.coordinate_y);
        
        double latitude= [self.coordinate_x doubleValue];
        double longitude=[self.coordinate_y doubleValue];
        
        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
        
        NSString *tempTitle = [NSString stringWithFormat:@"%@#%@",tempModel.mapCommunityDataSubModel.title,tempModel.mapCommunityDataSubModel.id_];
        anno.title = tempTitle;
        anno.subtitle=self.subtitle;
        anno.coordinate = CLLocationCoordinate2DMake(latitude , longitude);
        
        [annoArray addObject:anno];
        
        [_mapView addAnnotation:anno];
        
    }
    
    [_mapView showAnnotations:annoArray animated:YES];
    
}

#pragma mark - 地图代理方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        QSCustomAnnotationView *annotationView = (QSCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[QSCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        //annotationView.mapdeteilID=[]
        
        ///更新大头针数据
        [annotationView  updateAnnotation:annotation];
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}

/*!
 @brief 当mapView新添加annotation views时，调用此接口
 @param mapView 地图View
 @param views 新添加的annotation views
 */
//- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//
//
//
//}

/*!
 @brief 当选中一个annotation views时，调用此接口
 @param mapView 地图View
 @param views 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(QSCustomAnnotationView *)view
{
    
    NSString *idString = [view valueForKey:@"deteilID"];
    NSString *titleString = [view valueForKey:@"title"];
    
    [self gotoHouseDetail:titleString andDetailID:idString];
    
}

#pragma mark - 请求小区列表数据
///请求小区列表头数据
- (void)MapCommunityListHeaderRequest
{
    
    ///显示HUD
    __block QSCustomHUDView *hud=[QSCustomHUDView showCustomHUD];
    /// 当前用户坐标
    double clatitude= _currentLocation.coordinate.latitude ? _currentLocation.coordinate.latitude : 23.333;
    double clongitude= _currentLocation.coordinate.longitude ? _currentLocation.coordinate.longitude : 113.333;
    
    ///网络请求坐标
    NSString *latitude=[NSString stringWithFormat:@"%lf",_latitude ? _latitude : clatitude];
    NSString *longtude=[NSString stringWithFormat:@"%lf",_longtude ? _longtude : clongitude];
    NSString *map_type=[NSString stringWithFormat:@"%d",(int)self.listType];
    
    APPLICATION_LOG_INFO(@"网络请求经度", latitude);
    APPLICATION_LOG_INFO(@"网络请求纬度", longtude);
    ///请求参数
    NSDictionary *dict = @{@"map_type" : map_type,
                           @"now_page" : @"1",
                           @"page_num" : @"5",
                           @"range" : @"6000",
                           @"latitude" : latitude,
                           @"longitude" : longtude
                           };
    
    [QSRequestManager requestDataWithType:rRequestTypeMapCommunity andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            APPLICATION_LOG_INFO(@"地图列表数据返回成功", resultData);
            
            if (resultData) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [hud hiddenCustomHUD];
                    
                });
                
                ///请求成功后，转换模型
                QSMapCommunityListReturnData *resultDataModel = resultData;
                
                QSMapCommunityListHeaderData *headerModel=[[QSMapCommunityListHeaderData alloc] init];
                headerModel=resultDataModel.mapCommunityListHeaderData;
                NSLog(@"返回小区的数量:%@",headerModel.total_num);
                
                QSMapCommunityDataModel *tepmodel=[[QSMapCommunityDataModel alloc] init];
                tepmodel=resultDataModel.mapCommunityListHeaderData.communityList[0];
                NSLog(@"第一组小区房源套数:%@",tepmodel.total_num);
                
                QSMapCommunityDataSubModel *tepmodel1=[[QSMapCommunityDataSubModel alloc] init];
                tepmodel1=tepmodel.mapCommunityDataSubModel;
                NSLog(@"第一组小区名称:%@",tepmodel1.title);
                NSLog(@"第一组小区地址:%@",tepmodel1.address);
                
                
                ///将数据模型置为nil
                self.dataSourceModel = nil;
                self.dataSourceModel=resultDataModel;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self addAnnotations];
                    
                });
            }
            else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.hud hiddenCustomHUDWithFooterTips:@"暂无此小区数据..."];
                    
                });
                
            }
            
            
        }
        
        else {
            
            NSLog(@"=====网络请求失败=======");
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///显示提示信息
                [hud hiddenCustomHUDWithFooterTips:@"网络请求失败..." ];
                
            });
            
        }
    }];
    
}

#pragma mark - 重写返回事件，回收弹框
- (void)gotoTurnBackAction
{

    [self hiddenAllPickerView];
    [super gotoTurnBackAction];

}

@end

