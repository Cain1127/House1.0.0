//
//  QSHousesViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHousesViewController.h"

#import "QSHouseKeySearchViewController.h"
#import "QSHouseDetailViewController.h"
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

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char CollectionViewKey;      //!<collectionView的关联
static char ChannelButtonRootView;  //!<频道栏底view关联

@interface QSHousesViewController ()

@property (nonatomic,assign) FILTER_MAIN_TYPE listType;                 //!<列表类型
@property (nonatomic,retain) QSFilterDataModel *filterModel;            //!<过滤模型

@property (nonatomic,strong) QSCustomPickerView *houseListTypePickerView; //!<导航栏列表类型选择
@property (nonatomic,strong) QSCustomPickerView *distictPickerView;       //!<地区选择按钮
@property (nonatomic,strong) QSCustomPickerView *houseTypePickerView;     //!<户型选择按钮
@property (nonatomic,strong) QSCustomPickerView *pricePickerView;         //!<总价选择按钮

@end

@implementation QSHousesViewController

#pragma mark - 初始化
- (instancetype)init
{

    ///获取本地默认配置的过滤器
    NSString *filterID = [QSCoreDataManager getCurrentUserDefaultFilterID];
    return [self initWithHouseMainType:((filterID && [filterID length] > 0) ? [filterID intValue] : fFilterMainTypeSecondHouse)];

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
        
            QSNewHouseListView *listView = [[QSNewHouseListView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 40.0f + 20.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - 40.0f - 20.0f) andHouseListType:self.listType andCurrentFilter:self.filterModel andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
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
            
            [self.view addSubview:listView];
            objc_setAssociatedObject(self, &CollectionViewKey, listView, OBJC_ASSOCIATION_ASSIGN);
        
        }
            break;
                        
            ///小区列表
        case fFilterMainTypeCommunity:
        {
        
            ///创建小区/新房的列表UI
            QSCommunityListView *listView = [[QSCommunityListView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 40.0f + 20.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - 40.0f - 20.0f) andHouseListType:self.listType andCurrentFilter:self.filterModel andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
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
            
            [self.view addSubview:listView];
            objc_setAssociatedObject(self, &CollectionViewKey, listView, OBJC_ASSOCIATION_ASSIGN);
        
        }
            break;
            
            ///二手房列表
        case fFilterMainTypeSecondHouse:
        {
        
            ///瀑布流布局器
            QSHouseListView *listView = [[QSHouseListView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 40.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - 40.0f) andHouseListType:self.listType andCurrentFilter:self.filterModel andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType,id tempModel) {
                
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
            
            [self.view addSubview:listView];
            objc_setAssociatedObject(self, &CollectionViewKey, listView, OBJC_ASSOCIATION_ASSIGN);
        
        }
            break;
            
            ///出租房列表
        case fFilterMainTypeRentalHouse:
        {
        
            QSRentHouseListView *listView = [[QSRentHouseListView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 40.0f + 20.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - 40.0f - 20.0f) andHouseListType:self.listType andCurrentFilter:self.filterModel andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
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
    if (pPickerCallBackActionTypeUnLimited == callBackType) {
        
        ///判断原来是否已有选择，如果原来就不限，则不刷新，如果原来有选择项，现在重新不限，则刷新
        if (isCurrentModel) {
            
            ///更新过滤器
            [self.filterModel setValue:@"" forKey:setKey];
            [self.filterModel setValue:@"" forKey:setVal];
            
            ///更新本地对应的过滤器
            self.filterModel.filter_status = @"2";
            
            ///刷新数据
            UICollectionView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
            [collectionView headerBeginRefreshing];
            
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
        
    }
    
    ///选择了内容
    if (pPickerCallBackActionTypePicked == callBackType) {
        
        ///更新过滤器
        [self.filterModel setValue:pickedKey ? pickedKey : @"" forKey:setKey];
        [self.filterModel setValue:pickedVal ? pickedVal : @"" forKey:setVal];
        
        ///更新本地对应的过滤器
        self.filterModel.filter_status = @"2";
        
        ///刷新数据
        UICollectionView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
        [collectionView headerBeginRefreshing];
        
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
  
//    QSHouseKeySearchViewController *searchVC = [[QSHouseKeySearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
    
    QSHouseDetailViewController *detailVC=[[QSHouseDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
            QSNewHouseDetailViewController *detailVC = [[QSNewHouseDetailViewController alloc] initWithTitle:houseInfoModel.title andDetailID:houseInfoModel.id_ andDetailType:self.listType];
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
            QSCommunityDetailViewController *detailVC = [[QSCommunityDetailViewController alloc] initWithTitle:houseInfoModel.title andDetailID:houseInfoModel.id_ andDetailType:self.listType];
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
            QSHouseDetailViewController *detailVC = [[QSHouseDetailViewController alloc] initWithTitle:houseInfoModel.village_name andDetailID:houseInfoModel.id_ andDetailType:self.listType];
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

@end
