//
//  QSYAttentionCommunityViewController.m
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAttentionCommunityViewController.h"
#import "QSCommunityDetailViewController.h"
#import "QSYHousesNormalListViewController.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "QSAttentionCommunityCell.h"
#import "QSCommunityCollectionViewCell.h"

#import "QSCoreDataManager+Collected.h"

#import "QSCommunityHouseDetailDataModel.h"
#import "QSWCommunityDataModel.h"
#import "QSCommunityListReturnData.h"

#import "MJRefresh.h"

@interface QSYAttentionCommunityViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (assign) BOOL isRefreshIntentionList;                 //!<关注小区是否已变动：变动则刷新
@property (assign) BOOL isLocalData;                            //!<是否本地数据
@property (nonatomic,strong) QSCollectionView *collectionView;  //!<小区列表
@property (assign) BOOL isEditing;                              //!<当前是否是编辑状态
@property (nonatomic,retain) NSMutableArray *dataSource;        //!<数据源
@property (nonatomic,retain) NSMutableArray *seletedDataSource; //!<删除关注时的数据源
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
        self.seletedDataSource = [NSMutableArray array];
        
        ///初始化关注刷新标识
        self.isRefreshIntentionList = NO;
        self.isEditing = NO;
        
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
            
            self.isEditing = NO;
            button.selected = NO;
            [self.collectionView reloadData];
            
        } else {
        
            if ([self.dataSource count] > 0) {
                
                self.isEditing = YES;
                button.selected = YES;
                [self.collectionView reloadData];
                
            }
        
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
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[QSAttentionCommunityCell class] forCellWithReuseIdentifier:@"communityCellLocal"];
    [self.collectionView registerClass:[QSCommunityCollectionViewCell class] forCellWithReuseIdentifier:@"communityCellNetwork"];
    [self.view addSubview:self.collectionView];
    
    ///添加刷新
    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(communityListHeaderRequest)];
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(communityListFooterRequest)];
    self.collectionView.footer.hidden = YES;
    
    ///开始就刷新
    [self.collectionView.header beginRefreshing];
    
    ///注册关注列表变动监听
    [QSCoreDataManager setCoredataChangeCallBack:cCoredataDataTypeMyzoneCommunityIntention andCallBack:^(COREDATA_DATA_TYPE dataType, DATA_CHANGE_TYPE changeType, NSString *paramsID, id params) {
        
        ///修改刷新标识
        self.isRefreshIntentionList = YES;
        
    }];

}

///搭建无关注小区的UI
- (void)createNoRecordUI
{

    self.noRecordsView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    self.noRecordsView.hidden = YES;
    [self.view addSubview:self.noRecordsView];
    
    ///无记录说明信息
    UIImageView *tipsImage = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 75.0f) / 2.0f, (SIZE_DEVICE_HEIGHT - 64.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f - 85.0f, 75.0f, 85.0f)];
    tipsImage.image = [UIImage imageNamed:IMAGE_PUBLIC_NOCOLLECTED];
    [self.noRecordsView addSubview:tipsImage];
    
    ///提示信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsImage.frame.origin.y + tipsImage.frame.size.height + 15.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    tipsLabel.text = @"暂无关注小区";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [self.noRecordsView addSubview:tipsLabel];
    
    ///按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"看看附近小区";
    
    UIButton *lookButton = [UIButton createBlockButtonWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 160.0f) / 2.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 25.0f, 160.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入小区列表
        QSYHousesNormalListViewController *houseListVC = [[QSYHousesNormalListViewController alloc] initWithHouseType:fFilterMainTypeCommunity];
        [self.navigationController pushViewController:houseListVC animated:YES];
        
    }];
    lookButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_18];
    [self.noRecordsView addSubview:lookButton];

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
        cellNetwork.isEditing = self.isEditing;
        cellNetwork.selected = [self isSelectedIndexPath:indexPath];
        
        return cellNetwork;
        
    }
    
    static NSString *normalCellName = @"communityCellLocal";
    
    ///从复用队列中返回cell
    QSAttentionCommunityCell *cellNormal = [collectionView dequeueReusableCellWithReuseIdentifier:normalCellName forIndexPath:indexPath];
    
    ///刷新数据
    [cellNormal updateIntentionCommunityInfoCellUIWithDataModel:self.dataSource[indexPath.row]];
    cellNormal.isEditing = self.isEditing;
    cellNormal.selected = [self isSelectedIndexPath:indexPath];
    
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
    
    ///编辑状态
    if (self.isEditing) {
        
        ///已存在，则删除
        for (int i = 0; i < [self.seletedDataSource count]; i++) {
            
            NSIndexPath *selectedPath = self.seletedDataSource[i];
            if (selectedPath.section == indexPath.section &&
                selectedPath.row == indexPath.row) {
                
                [self.seletedDataSource removeObjectAtIndex:i];
                [collectionView reloadData];
                return;
                
            }
            
        }
        
        ///添加
        [self.seletedDataSource addObject:indexPath];
        
        ///显示选择
        [collectionView reloadData];
        
        return;
        
    }
 
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

#pragma mark - 检测当前index是否已选择
- (BOOL)isSelectedIndexPath:(NSIndexPath *)indexPath
{

    for (int i = 0; i < [self.seletedDataSource count]; i++) {
        
        NSIndexPath *selectedPath = self.seletedDataSource[i];
        if (selectedPath.section == indexPath.section &&
            selectedPath.row == indexPath.row) {
            
            return YES;
            
        }
        
    }
    return NO;

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
                    [self.view sendSubviewToBack:self.noRecordsView];
                    
                    ///更新数据源
                    self.dataSourceModel = resultDataModel;
                    
                    ///刷新数据
                    [self.collectionView reloadData];
                    
                    self.collectionView.footer.hidden = NO;
                    if ([self.dataSourceModel.communityListHeaderData.per_page intValue] ==
                        [self.dataSourceModel.communityListHeaderData.next_page intValue]) {
                        
                        [self.collectionView.footer noticeNoMoreData];
                        
                    }
                    
                    ///更新本地数据
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [self updateLocalData];
                        
                    });
                    
                } else {
                
                    self.noRecordsView.hidden = NO;
                    [self.view bringSubviewToFront:self.noRecordsView];
                    [self.collectionView reloadData];
                    self.collectionView.footer.hidden = YES;
                    
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
                [self.view bringSubviewToFront:self.noRecordsView];
                
                self.collectionView.footer.hidden = YES;
                
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
            [self.view sendSubviewToBack:self.noRecordsView];
            
            self.collectionView.footer.hidden = NO;
            [self.collectionView.footer noticeNoMoreData];
            
            
        } else {
        
            self.collectionView.footer.hidden = YES;
            self.noRecordsView.hidden = NO;
            [self.view bringSubviewToFront:self.noRecordsView];
        
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
                
                ///更新本地数据
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [self updateLocalData];
                    
                });
                
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

    ///网络请求的收藏数据
    NSArray *tempServerArray = [NSArray arrayWithArray:self.dataSourceModel.communityListHeaderData.communityList];
    
    if ([tempServerArray count] <= 0) {
        
        return;
        
    }
    
    ///查找本地是否已存在对应收藏
    for (int i = 0;i < [tempServerArray count];i++) {
        
        QSCommunityDataModel *serverModel = tempServerArray[i];
        serverModel.is_syserver = @"1";
        [QSCoreDataManager saveCollectedDataWithModel:serverModel andCollectedType:fFilterMainTypeCommunity andCallBack:^(BOOL flag) {
            
            ///保存成功
            if (flag) {
                
                APPLICATION_LOG_INFO(@"添加关注小区->服务端数据更新本地数据", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加关注小区->服务端数据更新本地数据", @"失败")
                
            }
            
        }];
        
    }

}

#pragma mark - 视图将要出现/消失时根据数据变动处理事务
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (self.isRefreshIntentionList) {
        
        self.isRefreshIntentionList = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.collectionView.header beginRefreshing];
            
        });
        
    }

}

- (void)gotoTurnBackAction
{

    ///注销列表监听
    [QSCoreDataManager setCoredataChangeCallBack:cCoredataDataTypeMyzoneCommunityIntention andCallBack:nil];
    [super gotoTurnBackAction];

}

@end
