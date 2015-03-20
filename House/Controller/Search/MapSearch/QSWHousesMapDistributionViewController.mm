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
#import "QSAnnotation.h"

#import "QSHouseKeySearchViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSWHousesMapDistributionViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSNewHouseDetailViewController.h"
#import "QSCommunityDetailViewController.h"
#import "QSCustomPickerView.h"

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

#import "QSHousesViewController.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

#define APIKey      @"0f36774bd285a275b3b8e496e45fe6d9"

#define kDefaultLocationZoomLevel       16.1
#define kDefaultControlMargin           22
#define kDefaultCalloutViewMargin       -8


///关联
static char ChannelButtonRootView;  //!<频道栏底view关联

@interface QSWHousesMapDistributionViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{

    MAMapView *_mapView;
    AMapSearchAPI *_search;
    
    CLLocation *_currentLocation;
    UIButton *_locationButton;
    
    NSArray *_pois;

    
    NSMutableArray *_annotations;

    
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
    
    ///添加地图列表
    [self initMapView];
    [self initSearch];
    [self initAttributes];
    
    
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
            //[collectionView headerBeginRefreshing];
            
            ///保存过滤器
            [QSCoreDataManager updateFilterWithType:self.listType andFilterDataModel:self.filterModel andUpdateCallBack:^(BOOL isSuccess) {
                
                ///保存成功后进入房子列表
                if (isSuccess) {
                    
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
        //[collectionView headerBeginRefreshing];
        
        ///保存过滤器
        [QSCoreDataManager updateFilterWithType:self.listType andFilterDataModel:self.filterModel andUpdateCallBack:^(BOOL isSuccess) {
            
            ///保存成功后进入房子列表
            if (isSuccess) {
                
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
        //[self createListView];
        
    });
    
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
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark--地图相关
- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 104.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-104.0f)];
    
    _mapView.delegate = self;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, kDefaultControlMargin);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, kDefaultControlMargin);
    
    [self.view addSubview:_mapView];
    
    CGFloat latitude=23.33;
    
    CGFloat longitude=113.33;
    
    _mapView.centerCoordinate=CLLocationCoordinate2DMake(latitude,longitude);
    
    _mapView.showsUserLocation = YES;
   // [self locateAction];
    [self GeoAction];
    [self reGeoAction];
    
}

- (void)initSearch
{
    _search = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
}


- (void)initAttributes
{
    _annotations = [NSMutableArray array];
    _pois = nil;
}

#pragma mark - Helpers

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

- (void)searchAction
{
    if (_currentLocation == nil || _search == nil)
    {
        NSLog(@"search failed");
        return;
    }
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    
    //request.keywords = @"公交";
    
    [_search AMapPlaceSearch:request];
}

//定位
- (void)locateAction
{
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        [_mapView setZoomLevel:kDefaultLocationZoomLevel animated:YES];
    }
}

///地理编码
- (void)GeoAction
{
   
        AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc] init];
        request.address=@"广东省广州市天河区员村二横路";
        [_search AMapGeocodeSearch:request];
    
}

///反地理编码
- (void)reGeoAction
{
    if (_currentLocation)
    {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        
        [_search AMapReGoecodeSearch:request];
    }
}

#pragma mark - AMapSearchDelegate

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"request :%@, error :%@", request, error);
}

/*!
 @brief 地理编码查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapGeocodeSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapGeocodeSearchResponse类中的定义)
 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{

    APPLICATION_LOG_INFO(@"地理编码回调", response);
    //NSArray *cored=response.geocodes;


}

///反地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"反地理编码回调response :%@", response);
    
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0)
    {
        // 直辖市的city为空，取province
        title = response.regeocode.addressComponent.province;
    }
    
    // 更新我的位置title
    _mapView.userLocation.title = title;
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    NSLog(@"request: %@", request);
    NSLog(@"response: %@", response);
    
    if (response.pois.count > 0)
    {
        _pois = response.pois;
        
        //[_tableView reloadData];
        
        // 清空标注
        [_mapView removeAnnotations:_annotations];
        [_annotations removeAllObjects];
    }
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QSAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        QSCustomAnnotationView *annotationView = (QSCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[QSCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"public_local_highlighted"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = YES;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    // 修改定位按钮状态
    if (mode == MAUserTrackingModeNone)
    {
        [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    }
    else
    {
        [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"userLocation: %@", userLocation.location);
    if (updatingLocation)
    {
        _currentLocation = [userLocation.location copy];
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    // 选中定位annotation的时候进行逆地理编码查询
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        [self reGeoAction];
    }
    
    // 调整自定义callout的位置，使其可以完全显示
    if ([view isKindOfClass:[QSCustomAnnotationView class]]) {
        QSCustomAnnotationView *cusView = (QSCustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:_mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kDefaultCalloutViewMargin, kDefaultCalloutViewMargin, kDefaultCalloutViewMargin, kDefaultCalloutViewMargin));
        
        if (!CGRectContainsRect(_mapView.frame, frame))
        {
            CGSize offset = [self offsetToContainRect:frame inRect:_mapView.frame];
            
            CGPoint theCenter = _mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [_mapView convertPoint:theCenter toCoordinateFromView:_mapView];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

@end

