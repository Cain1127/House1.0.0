//
//  QSYHomeRecommendSecondHouseViewController.m
//  House
//
//  Created by ysmeng on 15/4/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHomeRecommendSecondHouseViewController.h"
#import "QSSecondHouseDetailViewController.h"

#import "QSHouseListTitleCollectionViewCell.h"
#import "QSHouseCollectionViewCell.h"
#import "QSYHomeRecommendHouseHeaderCollectionViewCell.h"

#import "QSCollectionVerticalFlowLayout.h"

#import "QSSecondHandHouseListReturnData.h"

#import "MJRefresh.h"

@interface QSYHomeRecommendSecondHouseViewController () <QSCollectionVerticalFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *houseListView;                   //!<推荐房源列表
@property (nonatomic,retain) QSSecondHandHouseListReturnData *dataSourceModel;  //!<数据源
@property (assign) BOOL isNeedRefresh;                                          //!<是否需要刷新

@end

@implementation QSYHomeRecommendSecondHouseViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"说明"];

}

- (void)createMainShowUI
{

    [super createMainShowUI];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///布局器
    CGFloat width = (SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    QSCollectionVerticalFlowLayout *defaultLayout = [[QSCollectionVerticalFlowLayout alloc] initWithItemWidth:width];
    defaultLayout.delegate = self;
    
    self.houseListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 10.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 10.0f) collectionViewLayout:defaultLayout];
    self.houseListView.showsHorizontalScrollIndicator = NO;
    self.houseListView.showsVerticalScrollIndicator = NO;
    self.houseListView.dataSource = self;
    self.houseListView.delegate = self;
    self.houseListView.backgroundColor = [UIColor whiteColor];
    
    [self.houseListView registerClass:[QSYHomeRecommendHouseHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"headerCell"];
    [self.houseListView registerClass:[QSHouseListTitleCollectionViewCell class] forCellWithReuseIdentifier:@"titleCell"];
    [self.houseListView registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
    [self.view addSubview:self.houseListView];
    
    ///头部刷新
    [self.houseListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getRecommendHouse)];
    [self.houseListView.header beginRefreshing];

}

#pragma mark - 瀑布流配置
///头信息的高度
- (CGFloat)heightForCustomVerticalFlowLayoutHeader
{
    
    return 140.0f + SIZE_DEFAULT_MAX_WIDTH * 3.0f / 4.0f;
    
}

- (CGFloat)widthForCustomVerticalFlowLayoutItem
{
    
    return (SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    
}

///垂直方向间隙
- (CGFloat)gapVerticalForCustomVerticalFlowItem
{
    
    return SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    
}

- (CGFloat)customVerticalFlowLayout:(QSCollectionVerticalFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.row) {
        
        return 80.0f;
        
    }
    
    CGFloat width = (SIZE_DEVICE_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f) / 2.0f;
    CGFloat height = 139.5f + width * 247.0f / 330.0f;
    
    return height;
    
}

///cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] > 0) {
        
        return 1 + [self.dataSourceModel.secondHandHouseHeaderData.houseList count];
        
    }
    
    return 0;
    
}

#pragma mark - 返回cell信息
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///头信息
    if (0 == indexPath.row) {
        
        ///复用标识
        static NSString *headerCellIndentify = @"headerCell";
        QSYHomeRecommendHouseHeaderCollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCellIndentify forIndexPath:indexPath];
        
        ///刷新数据
        [headerCell updateRecommendHouseUIWithModel:self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row]];
        
        return headerCell;
        
    }
    
    ///判断是否标题栏
    if (1 == indexPath.row) {
        
        ///复用标识
        static NSString *titleCellIndentify = @"titleCell";
        
        ///从复用队列中获取cell
        QSHouseListTitleCollectionViewCell *cellTitle = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellIndentify forIndexPath:indexPath];
        
        ///更新数据
        NSString *houseCount = [self.dataSourceModel.secondHandHouseHeaderData.total_num intValue] > 10 ? @"10" : [self.dataSourceModel.secondHandHouseHeaderData.total_num stringValue];
        [cellTitle updateTitleInfoWithTitle:houseCount andSubTitle:@"套二手房信息"];
        
        return cellTitle;
        
    }
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///刷新数据
    [cellHouse updateHouseInfoCellUIWithDataModel:self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1] andListType:fFilterMainTypeSecondHouse];
    
    return cellHouse;
    
}

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///数量提醒项点击时，不动作
    if (indexPath.row == 0) {
        
        ///获取房子模型
        QSHouseInfoDataModel *houseInfoModel = self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row];
        
        ///进入详情页面
        QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:([houseInfoModel.title length] > 0 ? houseInfoModel.title : houseInfoModel.village_name) andDetailID:houseInfoModel.id_ andDetailType:fFilterMainTypeSecondHouse];
        
        ///删除物业后的回调
        detailVC.deletePropertyCallBack = ^(BOOL isDelete){
        
            self.isNeedRefresh = YES;
        
        };
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
        return;
        
    }
    
    ///第一项提示信息不执行事件
    if (1 == indexPath.row) {
        
        return;
        
    }
    
    ///获取房子模型
    QSHouseInfoDataModel *houseInfoModel = self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1];
    
    ///进入详情页
    QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:([houseInfoModel.title length] > 0 ? houseInfoModel.title : houseInfoModel.village_name) andDetailID:houseInfoModel.id_ andDetailType:fFilterMainTypeSecondHouse];
    
    ///删除物业后的回调
    detailVC.deletePropertyCallBack = ^(BOOL isDelete){
        
        self.isNeedRefresh = YES;
        
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - 获取推荐房源
- (void)getRecommendHouse
{

    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"commend" : @"Y",
                                @"now_page" : @"1",
                                @"page_num" : @"10"};
    
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseList andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSSecondHandHouseListReturnData *resultDataModel = resultData;
            
            ///将数据模型置为nil
            self.dataSourceModel = nil;
            
            ///判断是否有房子数据
            if ([resultDataModel.secondHandHouseHeaderData.houseList count] > 0) {
                
                ///更新数据源
                self.dataSourceModel = resultDataModel;
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self.houseListView reloadData];
                
            });
            
            ///结束刷新动画
            [self.houseListView.header endRefreshing];
            
        } else {
            
            ///结束刷新动画
            [self.houseListView.header endRefreshing];
            
            ///重置数据指针
            self.dataSourceModel = nil;
            
            ///刷新数据
            [self.houseListView reloadData];
            
        }
        
    }];

}

#pragma mark - 视图显示时刷新数据
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (self.isNeedRefresh) {
        
        self.isNeedRefresh = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.houseListView.header beginRefreshing];
            
        });
        
    }

}

@end
