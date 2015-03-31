//
//  QSYAttentionCommunityViewController.m
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAttentionCommunityViewController.h"
#import "QSCommunityDetailViewController.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSAttentionCommunityCell.h"

#import "QSCoreDataManager+Collected.h"

#import "QSCommunityHouseDetailDataModel.h"
#import "QSWCommunityDataModel.h"

#import "MJRefresh.h"

@interface QSYAttentionCommunityViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) QSCollectionView *collectionView;  //!<小区列表
@property (nonatomic,retain) NSMutableArray *dataSource;        //!<数据源

@end

@implementation QSYAttentionCommunityViewController

#pragma mark - 初始化
- (instancetype)init
{

    if (self = [super init]) {
        
        ///初始化数据源
        self.dataSource = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///导航栏UI
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"关注小区"];
    
    ///编辑按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeEdit];
    
    UIButton *editButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前非编辑状态，进入删除状态
        if (button.selected) {
            
            button.selected = NO;
            
        } else {
        
            button.selected = YES;
        
        }
        
    }];
    [self setNavigationBarRightView:editButton];

}

- (void)createMainShowUI
{

    ///瀑布流布局器
    UICollectionViewFlowLayout *defaultLayout = [[UICollectionViewFlowLayout alloc] init];
    defaultLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    ///每个信息项显示大小
    defaultLayout.itemSize = CGSizeMake(SIZE_DEVICE_WIDTH, 350.0f / 690.0f * SIZE_DEFAULT_MAX_WIDTH + 39.5f + 5.0f + 25.0f + 20.0f);
    
    ///每项内容的间隙
    defaultLayout.minimumLineSpacing = 20.0f;
    defaultLayout.minimumInteritemSpacing = 0.0f;
    
    self.collectionView = [[QSCollectionView alloc] initWithFrame:CGRectMake(0.0f, 84.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 84.0f) collectionViewLayout:defaultLayout andHorizontalScroll:NO andVerticalScroll:YES];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[QSAttentionCommunityCell class] forCellWithReuseIdentifier:@"communityCell"];
    [self.view addSubview:self.collectionView];
    
    ///添加刷新
    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(communityListHeaderRequest)];
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(communityListFooterRequest)];
    
    ///开始就刷新
    [self.collectionView.header beginRefreshing];

}

#pragma mark - 返回每一个小区/新房的信息cell
///返回每一个小区/新房的信息cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *normalCellName = @"communityCell";
    
    ///从复用队列中返回cell
    QSAttentionCommunityCell *cellNormal = [collectionView dequeueReusableCellWithReuseIdentifier:normalCellName forIndexPath:indexPath];
    
    ///刷新数据
    [cellNormal updateIntentionCommunityInfoCellUIWithDataModel:self.dataSource[indexPath.row]];
    
    return cellNormal;
    
}

#pragma mark - 返回一共有多少个小区/新房项
///返回一共有多少个小区/新房项
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.dataSource count];
    
}

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///获取房子模型
    QSCommunityHouseDetailDataModel *houseInfoModel = self.dataSource[indexPath.row];
    QSCommunityDetailViewController *detailVC = [[QSCommunityDetailViewController alloc] initWithTitle:houseInfoModel.village.title andCommunityID:houseInfoModel.village.id_ andCommendNum:@"10" andHouseType:@"second"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - 请求最新的数据
- (void)communityListHeaderRequest
{

    ///判断是否已登录
    if (lLoginCheckActionTypeLogined == [self checkLogin]) {
        
        ///获取网络数据
        
    } else {
    
        ///获取本地数据
        [self.dataSource addObjectsFromArray:[QSCoreDataManager getLocalCollectedDataSourceWithType:fFilterMainTypeCommunity]];
        
        ///重载数据
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    
    }

}

#pragma mark - 请求更多数据
- (void)communityListFooterRequest
{

    ///判断是否已登录
    if (lLoginCheckActionTypeLogined == [self checkLogin]) {
        
        ///获取网络数据
        
    } else {
        
        ///本地数据已一次取完
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        
    }

}

@end
