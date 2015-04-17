//
//  QSYAskRecommendRentHouseViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskRecommendRentHouseViewController.h"
#import "QSRentHouseDetailViewController.h"

#import "QSHouseListTitleCollectionViewCell.h"
#import "QSHouseCollectionViewCell.h"
#import "QSCollectionWaterFlowLayout.h"

#import "QSRentHouseListReturnData.h"
#import "QSRentHouseInfoDataModel.h"

#import "MJRefresh.h"

@interface QSYAskRecommendRentHouseViewController () <QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,copy) NSString *recommendID;                       //!<求租记录的ID
@property (nonatomic,strong) UICollectionView *houseListView;           //!<列表
@property (nonatomic,retain) QSRentHouseListReturnData *dataSourceModel;//!<数据源

@end

@implementation QSYAskRecommendRentHouseViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-03 09:04:13
 *
 *  @brief              根据求租记录的ID，创建对应的推荐房源列表
 *
 *  @param recommendID  求租记录的ID
 *
 *  @return             返回当前创建的求租记录推荐房源列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRecommendID:(NSString *)recommendID
{
    
    if (self = [super init]) {
        
        self.recommendID = recommendID;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"推荐出租房源"];
    
}

- (void)createMainShowUI
{

    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
    self.houseListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) collectionViewLayout:defaultLayout];
    
    self.houseListView.backgroundColor = [UIColor clearColor];
    self.houseListView.alwaysBounceVertical = YES;
    self.houseListView.delegate = self;
    self.houseListView.dataSource = self;
    self.houseListView.showsHorizontalScrollIndicator = NO;
    self.houseListView.showsVerticalScrollIndicator = NO;
    
    [self.houseListView registerClass:[QSHouseListTitleCollectionViewCell class] forCellWithReuseIdentifier:@"titleCell"];
    [self.houseListView registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
    [self.view addSubview:self.houseListView];
    
    ///添加刷新
    [self.houseListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(requestHeaderData)];
    [self.houseListView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestFooterData)];
    self.houseListView.footer.hidden = YES;
    
    ///开始就刷新
    [self.houseListView.header beginRefreshing];
    
}

#pragma mark - 返回每个房源信息
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///判断是否标题栏
    if (0 == indexPath.row) {
        
        ///复用标识
        static NSString *titleCellIndentify = @"titleCell";
        
        ///从复用队列中获取cell
        QSHouseListTitleCollectionViewCell *cellTitle = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellIndentify forIndexPath:indexPath];
        
        ///更新数据
        [cellTitle updateTitleInfoWithTitle:[self.dataSourceModel.headerData.total_num stringValue] andSubTitle:@"套出租房信息"];
        
        return cellTitle;
        
    }
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///刷新数据
    [cellHouse updateHouseInfoCellUIWithDataModel:self.dataSourceModel.headerData.rentHouseList[indexPath.row - 1] andListType:fFilterMainTypeRentalHouse];
    
    return cellHouse;
    
}

#pragma mark - 列表设置
///返回当前显示的cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger sumCount = [self.dataSourceModel.headerData.rentHouseList count];
    return (sumCount > 0) ? (sumCount + 1) : 0;
    
}

///返回每一个cell的固定宽度
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultSizeOfItemInSection:(NSInteger)section
{
    
    return (SIZE_DEVICE_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    
}

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

///返回cell的上间隙
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultScrollSpaceOfItemInSection:(NSInteger)section
{
    
    return (SIZE_DEVICE_WIDTH > 320.0f ? 20.0f : 15.0f);
    
}

///返回当前的section数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}

#pragma mark - 点击房源进入详情页
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return;
        
    }
    
    ///获取房子模型
    QSRentHouseInfoDataModel *houseInfoModel = self.dataSourceModel.headerData.rentHouseList[indexPath.row - 1];
    QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:([houseInfoModel.title  length] > 0 ? houseInfoModel.title : houseInfoModel.village_name) andDetailID:houseInfoModel.id_ andDetailType:fFilterMainTypeRentalHouse];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - 请求数据
- (void)requestHeaderData
{

    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"need_id" : APPLICATION_NSSTRING_SETTING(self.recommendID, @""),
                                @"key" : @"",
                                @"page_num " : @"10",
                                @"now_page" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeMyZoneAskRentPurphaseRentHouse andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSRentHouseListReturnData *resultDataModel = resultData;
            
            ///将数据模型置为nil
            self.dataSourceModel = nil;
            
            ///判断是否有房子数据
            if ([resultDataModel.headerData.rentHouseList count] <= 0) {
                
                ///没有记录，显示暂无记录提示
                [self showNoRecordTips:YES andTips:@"暂无推荐出租房"];
                
            } else {
                
                ///移除暂无记录
                [self showNoRecordTips:NO];
                
                ///更新数据源
                self.dataSourceModel = resultDataModel;
                
                self.houseListView.footer.hidden = NO;
                if ([self.dataSourceModel.headerData.per_page intValue] ==
                    [self.dataSourceModel.headerData.next_page intValue]) {
                    
                    [self.houseListView.footer noticeNoMoreData];
                    
                }
                
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
            
            ///重置数据
            self.dataSourceModel = nil;
            [self.houseListView reloadData];
            
            ///由于是第一页，请求失败，显示暂无记录
            self.houseListView.footer.hidden = YES;
            [self showNoRecordTips:YES andTips:@"暂无推荐出租房"];
            
        }
        
    }];

}

- (void)requestFooterData
{
    
    ///判断是否最大页码
    if ([self.dataSourceModel.headerData.per_page intValue] == [self.dataSourceModel.headerData.next_page intValue]) {
        
        ///结束刷新动画
        [self.houseListView.footer endRefreshing];
        return;
        
    }
    
    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"need_id" : APPLICATION_NSSTRING_SETTING(self.recommendID, @""),
                                @"key" : @"",
                                @"page_num " : @"10",
                                @"now_page" : self.dataSourceModel.headerData.next_page};
    
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouse andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSRentHouseListReturnData *resultDataModel = resultData;
            
            ///更改房子数据
            NSMutableArray *localArray = [NSMutableArray arrayWithArray:self.dataSourceModel.headerData.rentHouseList];
            
            ///更新数据源
            self.dataSourceModel = resultDataModel;
            [localArray addObjectsFromArray:resultDataModel.headerData.rentHouseList];
            self.dataSourceModel.headerData.rentHouseList = localArray;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self.houseListView reloadData];
                
            });
            
            ///结束刷新动画
            [self.houseListView.footer endRefreshing];
            
            if ([self.dataSourceModel.headerData.per_page intValue] ==
                [self.dataSourceModel.headerData.next_page intValue]) {
                
                [self.houseListView.footer noticeNoMoreData];
                
            }
            
        } else {
            
            ///结束刷新动画
            [self.houseListView.footer endRefreshing];
            
        }
        
    }];
    
}

@end
