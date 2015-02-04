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
#import "QSCollectionWaterFlowLayout.h"
#import "QSHouseCollectionViewCell.h"
#import "QSHouseListTitleCollectionViewCell.h"
#import "MJRefresh.h"

@interface QSHousesViewController () <UICollectionViewDataSource,UICollectionViewDelegate,QSCollectionWaterFlowLayoutDelegate>

@property (nonatomic,assign) HOUSE_LIST_MAIN_TYPE listType;//!<列表类型

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
- (instancetype)initWithHouseMainType:(HOUSE_LIST_MAIN_TYPE)mainType
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
    
    ///添加头部刷新
    [collectionView addHeaderWithTarget:self action:@selector(houseListHeaderRequest)];
    [collectionView addFooterWithTarget:self action:@selector(houseListFooterRequest)];
    
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
            [houseTypePickerView removePickerView:NO];
            [pricePickerView removePickerView:NO];
            
        }
        
    }];
    [view addSubview:distictPickerView];
    
    ///户型
    houseTypePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(gap * 2.0f + width, 0.0f, width, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarHouseType andPickerViewStyle:cCustomPickerStyleLeftArrow andIndicaterCenterXPoint:gap * 2.0f + width + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
        ///判断是否是弹出回调
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            ///回收其他弹出框
            [distictPickerView removePickerView:NO];
            [pricePickerView removePickerView:NO];
            
        }
        
    }];
    [view addSubview:houseTypePickerView];
    
    ///总价
    pricePickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(gap * 3.0f + width * 2.0f, 0.0f, width, view.frame.size.height) andPickerType:cCustomPickerTypeChannelBarTotalPrice andPickerViewStyle:cCustomPickerStyleLeftArrow andIndicaterCenterXPoint:gap * 3.0f + width * 2.0f + width / 2.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey, NSString *pickedVal) {
        
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

    

}

///请求更多数据
- (void)houseListFooterRequest
{
    
    
    
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

    return 25;

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
        
        return cellTitle;
        
    }
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    return cellHouse;

}

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"===============点击cell=====================");
    NSLog(@"坐标：section : %d row : %d",(int)indexPath.section,(int)indexPath.row);
    NSLog(@"===============点击cell=====================");

}

@end
