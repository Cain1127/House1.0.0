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
#import "QSCommunityCollectionViewCell.h"

#import "QSCoreDataManager+Collected.h"

#import "QSCommunityHouseDetailDataModel.h"
#import "QSWCommunityDataModel.h"
#import "QSCommunityListReturnData.h"

#import "MJRefresh.h"

@interface QSYAttentionCommunityViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (assign) BOOL isLocalData;                            //!<是否本地数据
@property (nonatomic,strong) QSCollectionView *collectionView;  //!<小区列表
@property (nonatomic,retain) NSMutableArray *dataSource;        //!<数据源
@property (nonatomic,strong) UIView *noRecordsView;             //!<无记录提示页面

///网络请求的数据
@property (nonatomic,retain) QSCommunityListReturnData *dataSourceModel;

@end

@implementation QSYAttentionCommunityViewController

#pragma mark - 初始化
- (instancetype)init
{

    if (self = [super init]) {
        
        ///初始化数据源
        self.dataSource = [[NSMutableArray alloc] init];
        
        ///初始化数据是网络数据，还是本地数据
        if (lLoginCheckActionTypeLogined == [self checkLogin]) {
            
            self.isLocalData = NO;
            
        } else {
        
            self.isLocalData = YES;
        
        }
        
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
    
    ///创建无记录页面
    [self createNoRecordUI];

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
    [self.collectionView registerClass:[QSAttentionCommunityCell class] forCellWithReuseIdentifier:@"communityCellLocal"];
    [self.collectionView registerClass:[QSCommunityCollectionViewCell class] forCellWithReuseIdentifier:@"communityCellNetwork"];
    [self.view addSubview:self.collectionView];
    
    ///添加刷新
    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(communityListHeaderRequest)];
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(communityListFooterRequest)];
    self.collectionView.footer.stateHidden = YES;
    
    ///开始就刷新
    [self.collectionView.header beginRefreshing];

}

- (void)createNoRecordUI
{

    

}

#pragma mark - 返回每一个小区/新房的信息cell
///返回每一个小区/新房的信息cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.isLocalData) {
        
        static NSString *networkCellName = @"communityCellNetwork";
        QSCommunityCollectionViewCell *cellNetwork = [collectionView dequeueReusableCellWithReuseIdentifier:networkCellName forIndexPath:indexPath];
        
        ///刷新数据
        [cellNetwork updateCommunityInfoCellUIWithDataModel:self.dataSourceModel.communityListHeaderData.communityList[indexPath.row] andListType:fFilterMainTypeCommunity];
        
        return cellNetwork;
        
    }
    
    static NSString *normalCellName = @"communityCellLocal";
    
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
 
    if (self.isLocalData) {
        
        return [self.dataSource count];
        
    }
    
    return [self.dataSourceModel.communityListHeaderData.communityList count];
    
}

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (self.isLocalData) {
        
        ///获取房子模型
        QSCommunityHouseDetailDataModel *houseInfoModel = self.dataSource[indexPath.row];
        QSCommunityDetailViewController *detailVC = [[QSCommunityDetailViewController alloc] initWithTitle:houseInfoModel.village.title andCommunityID:houseInfoModel.village.id_ andCommendNum:@"10" andHouseType:@"second"];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else {
    
        ///获取房子模型
        QSCommunityDataModel *houseInfoModel = self.dataSourceModel.communityListHeaderData.communityList[indexPath.row];
        QSCommunityDetailViewController *detailVC = [[QSCommunityDetailViewController alloc] initWithTitle:houseInfoModel.title andCommunityID:houseInfoModel.id_ andCommendNum:@"10" andHouseType:@"second"];
        [self.navigationController pushViewController:detailVC animated:YES];
    
    }
    
}

#pragma mark - 请求最新的数据
- (void)communityListHeaderRequest
{

    ///判断是否已登录
    if (!self.isLocalData) {
        
        ///封装参数
        NSDictionary *params = @{@"type" : @"200503",
                                 @"page_num " : @"10",
                                 @"now_page" : @"1"};
        
        ///获取网络数据
        [QSRequestManager requestDataWithType:rRequestTypeMyZoneIntentionCommunityList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///判断请求
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///请求成功后，转换模型
                QSCommunityListReturnData *resultDataModel = resultData;
                
                ///将数据模型置为nil
                self.dataSourceModel = nil;
                
                ///判断是否有房子数据
                if ([resultDataModel.communityListHeaderData.communityList count] > 0) {
                    
                    self.noRecordsView.hidden = YES;
                    
                    ///更新数据源
                    self.dataSourceModel = resultDataModel;
                    
                    ///刷新数据
                    [self.collectionView reloadData];
                    
                    self.collectionView.footer.stateHidden = NO;
                    if ([self.dataSourceModel.communityListHeaderData.per_page intValue] ==
                        [self.dataSourceModel.communityListHeaderData.next_page intValue]) {
                        
                        [self.collectionView.footer noticeNoMoreData];
                        
                    }
                    
                } else {
                
                    self.noRecordsView.hidden = NO;
                    [self.collectionView reloadData];
                    self.collectionView.footer.stateHidden = YES;
                    
                    ///刷新数据
                    [self.collectionView reloadData];
                
                }
                
                ///结束刷新动画
                [self.collectionView.header endRefreshing];
                
            } else {
                
                ///重置数据源
                self.dataSourceModel = nil;
                
                ///刷新数据
                [self.collectionView reloadData];
                
                self.noRecordsView.hidden = NO;
                
                ///结束刷新动画
                [self.collectionView.header endRefreshing];
                
            }
            
        }];
        
    } else {
    
        ///获取本地数据
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[QSCoreDataManager getLocalCollectedDataSourceWithType:fFilterMainTypeCommunity]];
        
        ///重载数据
        [self.collectionView reloadData];
        
        if ([self.dataSource count] > 0) {
            
            ///显示无记录页
            self.noRecordsView.hidden = YES;
            
            self.collectionView.footer.stateHidden = NO;
            [self.collectionView.footer noticeNoMoreData];
            
            
        } else {
        
            self.collectionView.footer.stateHidden = YES;
            self.noRecordsView.hidden = NO;
        
        }
        
        [self.collectionView.header endRefreshing];
    
    }

}

#pragma mark - 请求更多数据
- (void)communityListFooterRequest
{

    ///判断是否已登录
    if (!self.isLocalData) {
        
        ///判断是否最大页码
        self.collectionView.footer.hidden = NO;
        if ([self.dataSourceModel.communityListHeaderData.per_page intValue] ==
            [self.dataSourceModel.communityListHeaderData.next_page intValue]) {
            
            [self.collectionView.footer noticeNoMoreData];
            
            ///结束刷新动画
            [self.collectionView.header endRefreshing];
            [self.collectionView.footer endRefreshing];
            return;
            
        }
        
        ///封装参数：主要是添加页码控制
        NSDictionary *params = @{@"type" : @"200503",
                                 @"page_num " : @"10",
                                 @"now_page" : self.dataSourceModel.communityListHeaderData.next_page};
        
        [QSRequestManager requestDataWithType:rRequestTypeMyZoneIntentionCommunityList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///判断请求
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///请求成功后，转换模型
                QSCommunityListReturnData *resultDataModel = resultData;
                
                ///更改房子数据
                NSMutableArray *localArray = [NSMutableArray arrayWithArray:self.dataSourceModel.communityListHeaderData.communityList];
                
                ///更新数据源
                self.dataSourceModel = resultDataModel;
                [localArray addObjectsFromArray:resultDataModel.communityListHeaderData.communityList];
                self.dataSourceModel.communityListHeaderData.communityList = localArray;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ///刷新数据
                    [self.collectionView reloadData];
                    
                    self.collectionView.footer.hidden = NO;
                    if ([self.dataSourceModel.communityListHeaderData.per_page intValue] ==
                        [self.dataSourceModel.communityListHeaderData.next_page intValue]) {
                        
                        [self.collectionView.footer noticeNoMoreData];
                        
                    }
                    
                });
                
                ///结束刷新动画
                [self.collectionView.footer endRefreshing];
                
            } else {
                
                ///结束刷新动画
                [self.collectionView.footer endRefreshing];
                
            }
            
        }];
        
    } else {
        
        ///本地数据已一次取完
        [self.collectionView.footer endRefreshing];
        
    }

}

#pragma mark - 重新校对数据
- (void)updateLocalData
{

    

}

@end
