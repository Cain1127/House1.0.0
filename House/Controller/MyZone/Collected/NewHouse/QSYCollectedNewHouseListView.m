//
//  QSYCollectedNewHouseListView.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYCollectedNewHouseListView.h"

#import "QSCommunityCollectionViewCell.h"
#import "QSAttentionCommunityCell.h"

#import "QSNewHouseListReturnData.h"
#import "QSNewHouseInfoDataModel.h"

#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+Collected.h"

#import "QSRequestManager.h"

#import "MJRefresh.h"

@interface QSYCollectedNewHouseListView () <UICollectionViewDataSource,UICollectionViewDelegate>

///点击房源时的回调
@property (nonatomic,copy) void(^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

@property (nonatomic,retain) NSMutableArray *customDataSource;  //!<数据源
@property (nonatomic,assign) BOOL isLocalData;                  //!<是否是本地数据

///网络请求返回的数据模型
@property (nonatomic,retain) QSNewHouseListReturnData *dataSourceModel;

@end

@implementation QSYCollectedNewHouseListView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-01-30 08:01:06
 *
 *  @brief          创建收藏新房列表，并且点击房源时，回调
 *
 *  @param frame    大小和位置
 *  @param callBack 点击出租房时的回调
 *
 *  @return         返回当前创建的房源列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack
{

    ///瀑布流布局器
    UICollectionViewFlowLayout *defaultLayout = [[UICollectionViewFlowLayout alloc] init];
    defaultLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    ///每个信息项显示大小
    defaultLayout.itemSize = CGSizeMake(SIZE_DEVICE_WIDTH, 350.0f / 690.0f * SIZE_DEFAULT_MAX_WIDTH + 39.5f + 5.0f + 25.0f + 20.0f);
    
    ///每项内容的间隙
    defaultLayout.minimumLineSpacing = 20.0f;
    defaultLayout.minimumInteritemSpacing = 0.0f;
    
    if (self = [super initWithFrame:frame collectionViewLayout:defaultLayout]) {
        
        ///保存参数
        if (callBack) {
            
            self.houseListTapCallBack = callBack;
            
        }
        
        ///初始化数据是网络数据，还是本地数据
        if ([QSCoreDataManager isLogin]) {
            
            self.isLocalData = NO;
            
        } else {
            
            self.isLocalData = YES;
            
        }
        
        ///初始化数据源
        self.customDataSource = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSAttentionCommunityCell class] forCellWithReuseIdentifier:@"localCell"];
        [self registerClass:[QSCommunityCollectionViewCell class] forCellWithReuseIdentifier:@"serverCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(newHouseListHeaderRequest)];
        [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(newHouseListFooterRequest)];
        self.footer.hidden = YES;
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;

}

#pragma mark - 请求列表数据
- (void)newHouseListHeaderRequest
{

    if (!self.isLocalData) {
        
        ///封装参数
        NSDictionary *params = @{@"type" : @"200502",
                                 @"page_num " : @"10",
                                 @"now_page" : @"1"};
        
        ///获取网络数据
        [QSRequestManager requestDataWithType:rRequestTypeMyZoneCollectedNewHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///判断请求
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///请求成功后，转换模型
                QSNewHouseListReturnData *resultDataModel = resultData;
                
                ///将数据模型置为nil
                self.dataSourceModel = nil;
                
                ///判断是否有房子数据
                if ([resultDataModel.headerData.houseList count] > 0) {
                    
                    if (self.houseListTapCallBack) {
                        
                        self.houseListTapCallBack(hHouseListActionTypeHaveRecord,nil);
                        
                    }
                    
                    ///更新数据源
                    self.dataSourceModel = resultDataModel;
                    
                    ///刷新数据
                    [self reloadData];
                    
                    self.footer.hidden = NO;
                    if ([self.dataSourceModel.headerData.per_page intValue] ==
                        [self.dataSourceModel.headerData.next_page intValue]) {
                        
                        [self.footer noticeNoMoreData];
                        
                    }
                    
                    ///更新本地数据
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [self updateLocalData];
                        
                    });
                    
                } else {
                    
                    self.footer.hidden = YES;
                    if (self.houseListTapCallBack) {
                        
                        self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
                        
                    }
                    
                    ///刷新数据
                    [self reloadData];
                    
                }
                
                ///结束刷新动画
                [self.header endRefreshing];
                
            } else {
                
                ///重置数据源
                self.dataSourceModel = nil;
                
                ///刷新数据
                [self reloadData];
                
                self.footer.hidden = YES;
                
                if (self.houseListTapCallBack) {
                    
                    self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
                    
                }
                
                ///结束刷新动画
                [self.header endRefreshing];
                
            }
            
        }];
        
    } else {
        
        ///获取本地数据
        [self.customDataSource removeAllObjects];
        [self.customDataSource addObjectsFromArray:[QSCoreDataManager getLocalCollectedDataSourceWithType:fFilterMainTypeNewHouse]];
        
        ///重载数据
        [self reloadData];
        if ([self.customDataSource count] > 0) {
            
            if (self.houseListTapCallBack) {
                
                self.houseListTapCallBack(hHouseListActionTypeHaveRecord,nil);
                
            }
            
            self.footer.hidden = NO;
            [self.footer noticeNoMoreData];
            
        } else {
            
            self.footer.hidden = YES;
            if (self.houseListTapCallBack) {
                
                self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
                
            }
            
        }
        
        [self.header endRefreshing];
        
    }
    
}

- (void)newHouseListFooterRequest
{

    if (!self.isLocalData) {
        
        ///判断是否最大页码
        self.footer.hidden = NO;
        if ([self.dataSourceModel.headerData.per_page intValue] ==
            [self.dataSourceModel.headerData.next_page intValue]) {
            
            [self.footer noticeNoMoreData];
            
            ///结束刷新动画
            [self.footer endRefreshing];
            return;
            
        }
        
        ///封装参数：主要是添加页码控制
        NSDictionary *params = @{@"type" : @"200502",
                                 @"page_num " : @"10",
                                 @"now_page" : self.dataSourceModel.headerData.next_page};
        
        [QSRequestManager requestDataWithType:rRequestTypeMyZoneCollectedNewHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///判断请求
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///请求成功后，转换模型
                QSNewHouseListReturnData *resultDataModel = resultData;
                
                ///更改房子数据
                NSMutableArray *localArray = [NSMutableArray arrayWithArray:self.dataSourceModel.headerData.houseList];
                
                ///更新数据源
                self.dataSourceModel = resultDataModel;
                [localArray addObjectsFromArray:resultDataModel.headerData.houseList];
                self.dataSourceModel.headerData.houseList = localArray;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ///刷新数据
                    [self reloadData];
                    
                    self.footer.hidden = NO;
                    if ([self.dataSourceModel.headerData.per_page intValue] ==
                        [self.dataSourceModel.headerData.next_page intValue]) {
                        
                        [self.footer noticeNoMoreData];
                        
                    }
                    
                });
                
                ///结束刷新动画
                [self.footer endRefreshing];
                
                ///更新本地数据
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [self updateLocalData];
                    
                });
                
            } else {
                
                ///结束刷新动画
                [self.footer endRefreshing];
                
            }
            
        }];
        
    } else {
        
        ///本地数据已一次取完
        [self.footer endRefreshing];
        
    }

}

#pragma mark - 返回当前的房源个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (self.isLocalData) {
        
        return [self.customDataSource count];
        
    }
    
    return [self.dataSourceModel.headerData.houseList count];
    
}

#pragma mark - 返回每一个房源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.isLocalData) {
        
        static NSString *serverCellName = @"serverCell";
        
        ///从复用队列中返回cell
        QSCommunityCollectionViewCell *cellServer = [collectionView dequeueReusableCellWithReuseIdentifier:serverCellName forIndexPath:indexPath];
        
        ///获取数据
        QSNewHouseInfoDataModel *tempModel = self.dataSourceModel.headerData.houseList[indexPath.row];
        
        ///刷新数据
        [cellServer updateCommunityInfoCellUIWithDataModel:tempModel andListType:fFilterMainTypeCommunity];
        
        return cellServer;
        
    }
    
    static NSString *localCellName = @"localCell";
    
    ///从复用队列中返回cell
    QSAttentionCommunityCell *cellLocal = [collectionView dequeueReusableCellWithReuseIdentifier:localCellName forIndexPath:indexPath];
    
    ///获取数据
    QSNewHouseDetailDataModel *tempModel = self.customDataSource[indexPath.row];
    
    ///刷新数据
    [cellLocal updateHistoryNewHouseInfoCellUIWithDataModel:tempModel];
    
    return cellLocal;
    
}

#pragma mark - 重新校对数据
- (void)updateLocalData
{
    
    ///网络请求的收藏数据
    NSArray *tempServerArray = [NSArray arrayWithArray:self.dataSourceModel.headerData.houseList];
    
    if ([tempServerArray count] <= 0) {
        
        return;
        
    }
    
    ///查找本地是否已存在对应收藏
    for (int i = 0;i < [tempServerArray count];i++) {
        
        QSNewHouseInfoDataModel *serverModel = tempServerArray[i];
        serverModel.is_syserver = @"1";
        [QSCoreDataManager saveCollectedDataWithModel:serverModel andCollectedType:fFilterMainTypeNewHouse andCallBack:^(BOOL flag) {
            
            ///保存成功
            if (flag) {
                
                APPLICATION_LOG_INFO(@"添加新房收藏->服务端数据更新本地数据", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加新房收藏->服务端数据更新本地数据", @"失败")
                
            }
            
        }];
        
    }
    
}

@end
