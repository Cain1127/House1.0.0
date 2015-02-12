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
#import "QSCustomPickerView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCollectionWaterFlowLayout.h"
#import "QSHouseCollectionViewCell.h"
#import "QSHouseListTitleCollectionViewCell.h"

#import "QSRequestManager.h"

#import "MJRefresh.h"

#import "QSFilterDataModel.h"
#import "QSSecondHandHouseListReturnData.h"
#import "QSBaseConfigurationDataModel.h"

#import "QSCoreDataManager+Filter.h"
#import "QSCoreDataManager+House.h"

#import <objc/runtime.h>

///关联
static char CollectionViewKey;//!<collectionView的关联

@interface QSHousesViewController () <UICollectionViewDataSource,UICollectionViewDelegate,QSCollectionWaterFlowLayoutDelegate>

@property (nonatomic,assign) FILTER_MAIN_TYPE listType;     //!<列表类型
@property (nonatomic,retain) QSFilterDataModel *filterModel;//!<过滤模型

@property (nonatomic,assign) int currentPage;               //!<当前页

//!<数据源模型
@property (nonatomic,retain) QSSecondHandHouseListReturnData *dataSourceModel;

@end

@implementation QSHousesViewController

#pragma mark - 初始化
- (instancetype)init
{

    return [self initWithHouseMainType:fFilterMainTypeSecondHouse];

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
        
        ///初始化参数
        self.currentPage = 1;
        
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
    
    ///中间选择城市按钮
    QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:self.filterModel.filter_id];
    QSCustomPickerView *houseListTypePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andPickerType:cCustomPickerTypeNavigationBarHouseMainType andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:tempModel andIndicaterCenterXPoint:0.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *houseTypeKey, NSString *houseTypeVal) {
        
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
    
    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
    ///瀑布流父视图
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, channelBarRootView.frame.origin.y + channelBarRootView.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 49.0f - channelBarRootView.frame.size.height) collectionViewLayout:defaultLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[QSHouseListTitleCollectionViewCell class] forCellWithReuseIdentifier:@"titleCell"];
    [collectionView registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
    [self.view addSubview:collectionView];
    objc_setAssociatedObject(self, &CollectionViewKey, collectionView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加头部刷新
    [collectionView addHeaderWithTarget:self action:@selector(houseListHeaderRequest)];
    [collectionView addFooterWithTarget:self action:@selector(houseListFooterRequest)];
    
    ///开始就进行头部请求
    [collectionView headerBeginRefreshing];
    
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
    CGFloat gap = SIZE_DEVICE_WIDTH > 320.0f ? 15.0f : 10.0f;
    CGFloat width = (view.frame.size.width - gap * 3.0f - 55.0f) / 3.0f;
    
    ///三个选择框的指针
    __block QSCustomPickerView *distictPickerView;
    __block QSCustomPickerView *houseTypePickerView;
    __block QSCustomPickerView *pricePickerView;
    
    ///区域
    QSBaseConfigurationDataModel *districtCurrentModel = [[QSBaseConfigurationDataModel alloc] init];
    districtCurrentModel.key = (self.filterModel.street_key && ([self.filterModel.street_key length] > 0)) ? self.filterModel.street_key : nil;
    districtCurrentModel.val = self.filterModel.street_val;
    distictPickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(gap, 0.0f, width, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarDistrict andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:(districtCurrentModel.key ? districtCurrentModel : nil) andIndicaterCenterXPoint:gap + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [houseTypePickerView removePickerView:NO];
            [pricePickerView removePickerView:NO];
            
        }
        
    }];
    [view addSubview:distictPickerView];
    
    ///户型
    QSBaseConfigurationDataModel *houseTypeCurrentModel = [[QSBaseConfigurationDataModel alloc] init];
    houseTypeCurrentModel.key = (self.filterModel.house_type_key && ([self.filterModel.house_type_key length] > 0)) ? self.filterModel.house_type_key : nil;
    houseTypeCurrentModel.val = self.filterModel.house_type_val;
    houseTypePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(distictPickerView.frame.origin.x + distictPickerView.frame.size.width + gap, 0.0f, width - 15.0f, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarHouseType andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:(houseTypeCurrentModel.key ? houseTypeCurrentModel : nil) andIndicaterCenterXPoint:gap * 2.0f + width + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [distictPickerView removePickerView:NO];
            [pricePickerView removePickerView:NO];
            
        }
        
    }];
    [view addSubview:houseTypePickerView];
    
    ///总价
    QSBaseConfigurationDataModel *totalPriceCurrentModel = [[QSBaseConfigurationDataModel alloc] init];
    totalPriceCurrentModel.key = (self.filterModel.sale_price_key && ([self.filterModel.sale_price_key length] > 0)) ? self.filterModel.sale_price_key : nil;
    totalPriceCurrentModel.val = self.filterModel.sale_price_val;
    pricePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(houseTypePickerView.frame.origin.x + houseTypePickerView.frame.size.width + gap, 0.0f, width + 5.0f, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarTotalPrice andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:(totalPriceCurrentModel.key ? totalPriceCurrentModel : nil) andIndicaterCenterXPoint:gap * 3.0f + width * 2.0f + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [houseTypePickerView removePickerView:NO];
            [distictPickerView removePickerView:NO];
            
        }
        
    }];
    [view addSubview:pricePickerView];

    ///底部分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height - 0.5f, view.frame.size.width, 0.5f)];
    bottomLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:bottomLineLabel];
    
}

#pragma mark - 请求数据
///请求第一页的数据
- (void)houseListHeaderRequest
{

    ///封装参数：主要是添加页码控制
    NSMutableDictionary *temParams = [NSMutableDictionary dictionaryWithDictionary:[QSCoreDataManager getHouseListRequestParams:self.listType]];
    [temParams setObject:@"1" forKey:@"now_page"];
    [temParams setObject:@"10" forKey:@"page_num"];
    
    [QSRequestManager requestDataWithType:[self getRequestType] andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSSecondHandHouseListReturnData *resultDataModel = resultData;
            
            ///修改当前页码
            self.currentPage = 1;
            
            ///将数据模型置为nil
            self.dataSourceModel = nil;
            
            ///判断是否有房子数据
            if ([resultDataModel.secondHandHouseHeaderData.houseList count] <= 0) {
                
                ///没有记录，显示暂无记录提示
                [self showNoRecordTips:YES];
                
            } else {
            
                ///移除暂无记录
                [self showNoRecordTips:NO];
                
                ///更新数据源
                self.dataSourceModel = resultDataModel;
            
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self reloadData];
                
            });
            
            ///结束刷新动画
            [self endRefreshAnimination];
            
        } else {
         
            ///结束刷新动画
            [self endRefreshAnimination];
            
            ///由于是第一页，请求失败，显示暂无记录
            [self showNoRecordTips:YES];
            
        }
        
    }];

}

///请求更多数据
- (void)houseListFooterRequest
{
    
    
    
}

#pragma mark - 主动让CollectionView刷新数据
///主动让CollectionView刷新数据
- (void)reloadData
{

    UICollectionView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
    [collectionView reloadData];

}

#pragma mark - 结束刷新动画
///结束刷新动画
- (void)endRefreshAnimination
{

    UICollectionView *collectionView = objc_getAssociatedObject(self, &CollectionViewKey);
    [collectionView headerEndRefreshing];
    [collectionView footerEndRefreshing];

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

#pragma mark - 列表房源的个数
///返回当前显示的cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] > 0) ? ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] + 1) : 0;

}

#pragma mark - 返回每一个cell的固定宽度
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultSizeOfItemInSection:(NSInteger)section
{

    return (SIZE_DEVICE_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;

}

#pragma mark - 返回不同的cell的高度
///返回不同的cell的高度
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultScrollSizeOfItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (0 == indexPath.row) {
        
        return 80.0f;
        
    }
    
    CGFloat width = (SIZE_DEVICE_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f) / 2.0f;
    CGFloat height = 139.5f + width * 247.0f / 330.0f;
    
    return height;

}

#pragma mark - 返回cell的上间隙
///返回cell的上间隙
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultScrollSpaceOfItemInSection:(NSInteger)section
{
    
    return (SIZE_DEVICE_WIDTH > 320.0f ? 20.0f : 15.0f);
    
}

#pragma mark - 返回当前的section数量
///返回当前的section数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;

}

#pragma mark - 返回每一个房子的信息展示cell
/**
 *  @author                 yangshengmeng, 15-01-30 16:01:04
 *
 *  @brief                  返回每一个房子信息的cell
 *
 *  @param collectionView   当前的瀑布流管理器
 *  @param indexPath        当前下标
 *
 *  @return                 返回当前创建的房子信息cell
 *
 *  @since                  1.0.0
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    ///判断是否标题栏
    if (0 == indexPath.row) {
        
        ///复用标识
        static NSString *titleCellIndentify = @"titleCell";
        
        ///从复用队列中获取cell
        QSHouseListTitleCollectionViewCell *cellTitle = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellIndentify forIndexPath:indexPath];
        
        ///更新数据
        [cellTitle updateTitleInfoWithTitle:[self.dataSourceModel.secondHandHouseHeaderData.total_num stringValue] andSubTitle:@"套二手房信息"];
        
        return cellTitle;
        
    }
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///刷新数据
    [cellHouse updateHouseInfoCellUIWithDataModel:self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1]];
    
    return cellHouse;

}

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    ///获取房子模型
    QSHouseInfoDataModel *houseInfoModel = self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1];
    
    ///进入详情页面
    QSHouseDetailViewController *detailVC = [[QSHouseDetailViewController alloc] initWithTitle:houseInfoModel.village_name andDetailID:houseInfoModel.id_ andDetailType:self.listType];
    detailVC.hiddenCustomTabbarWhenPush = YES;
    [self hiddenBottomTabbar:YES];
    [self.navigationController pushViewController:detailVC animated:YES];

}

#pragma mark - 根据不同的列表类型返回不同的请求类型
///根据不同的列表类型返回不同的请求类型
- (REQUEST_TYPE)getRequestType
{

    switch (self.listType) {
            ///楼盘
        case fFilterMainTypeBuilding:
            
            return rRequestTypeBuilding;
            
            break;
            
            ///新房
        case fFilterMainTypeNewHouse:
            
            return rRequestTypeNewHouse;
            
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
            
            return rRequestTypeCommunity;
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            return rRequestTypeSecondHandHouseList;
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            return rRequestTypeRentalHouse;
            
            break;
            
        default:
            break;
    }
    
    return rRequestTypeSecondHandHouseList;

}

@end
