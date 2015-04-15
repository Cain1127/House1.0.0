//
//  QSYSearchCommunityList.m
//  House
//
//  Created by ysmeng on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSearchCommunityList.h"

#import "QSCommunityCollectionViewCell.h"

#import "QSCommunityListReturnData.h"
#import "QSCommunityDataModel.h"

#import "QSRequestManager.h"
#import "MJRefresh.h"

@interface QSYSearchCommunityList () <UICollectionViewDataSource,UICollectionViewDelegate>

///搜索关键字
@property (nonatomic,copy) NSString *searchKey;

///点击房源时的回调
@property (nonatomic,copy) void (^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

///数据源
@property (nonatomic,retain) QSCommunityListReturnData *dataSourceModel;

@end

@implementation QSYSearchCommunityList

/**
 *  @author             yangshengmeng, 15-04-15 11:04:45
 *
 *  @brief              创建搜索的小区列表
 *
 *  @param frame        大小和位置
 *  @param searchKey    当前的搜索关键字
 *  @param callBack     列表中的回调
 *
 *  @return             返回当前创建的小区列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSearchKey:(NSString *)searchKey andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack
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
        
        self.searchKey = searchKey;
        
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSCommunityCollectionViewCell class] forCellWithReuseIdentifier:@"communityCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(requestHeaderData)];
        [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestListFooterData)];
        self.footer.hidden = YES;
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;

}

#pragma mark - 小区信息展示相关配置
///返回每一个小区/新房的信息cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *normalCellName = @"communityCell";
    
    ///从复用队列中返回cell
    QSCommunityCollectionViewCell *cellNormal = [collectionView dequeueReusableCellWithReuseIdentifier:normalCellName forIndexPath:indexPath];
    
    ///刷新数据
    [cellNormal updateCommunityInfoCellUIWithDataModel:self.dataSourceModel.communityListHeaderData.communityList[indexPath.row] andListType:fFilterMainTypeCommunity];
    
    return cellNormal;
    
}

///返回一共有多少个小区/新房项
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.dataSourceModel.communityListHeaderData.communityList count];
    
}

///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///获取房子模型
    QSCommunityDataModel *houseInfoModel = self.dataSourceModel.communityListHeaderData.communityList[indexPath.row ];
    
    ///回调
    if (self.houseListTapCallBack) {
        
        self.houseListTapCallBack(hHouseListActionTypeGotoDetail,houseInfoModel);
        
    }
    
}

#pragma mark - 请求数据
- (void)requestHeaderData
{

    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"now_page" : @"1",
                                @"page_num" : @"10",
                                @"commend" : @"Y"};
    
    [QSRequestManager requestDataWithType:rRequestTypeCommunity andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSCommunityListReturnData *resultDataModel = resultData;
            
            ///将数据模型置为nil
            self.dataSourceModel = nil;
            
            ///判断是否有房子数据
            if ([resultDataModel.communityListHeaderData.communityList count] > 0) {
                
                ///更新数据源
                self.dataSourceModel = resultDataModel;
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self reloadData];
                
                self.footer.hidden = NO;
                if ([self.dataSourceModel.communityListHeaderData.per_page intValue] ==
                    [self.dataSourceModel.communityListHeaderData.next_page intValue]) {
                    
                    [self.footer noticeNoMoreData];
                    
                }
                
            });
            
            ///结束刷新动画
            [self.header endRefreshing];
            
        } else {
            
            ///结束刷新动画
            [self.header endRefreshing];
            
            ///重置数据源
            self.dataSourceModel = nil;
            
            ///刷新数据
            [self reloadData];
            
            ///由于是第一页，请求失败，显示暂无记录
            self.footer.hidden = YES;
            
        }
        
    }];

}

- (void)requestListFooterData
{

    ///判断是否最大页码
    if ([self.dataSourceModel.communityListHeaderData.per_page intValue] == [self.dataSourceModel.communityListHeaderData.total_page intValue]) {
        
        self.footer.hidden = NO;
        if ([self.dataSourceModel.communityListHeaderData.per_page intValue] ==
            [self.dataSourceModel.communityListHeaderData.next_page intValue]) {
            
            [self.footer noticeNoMoreData];
            
        }
        
        ///结束刷新动画
        [self.footer endRefreshing];
        return;
        
    }
    
    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"now_page" : self.dataSourceModel.communityListHeaderData.next_page,
                                @"page_num" : @"10",
                                @"commend" : @"Y"};
    
    [QSRequestManager requestDataWithType:rRequestTypeCommunity andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
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
                [self reloadData];
                
                self.footer.hidden = NO;
                if ([self.dataSourceModel.communityListHeaderData.per_page intValue] ==
                    [self.dataSourceModel.communityListHeaderData.next_page intValue]) {
                    
                    [self.footer noticeNoMoreData];
                    
                }
                
            });
            
            ///结束刷新动画
            [self.footer endRefreshing];
            
        } else {
            
            ///结束刷新动画
            [self.footer endRefreshing];
            
        }
        
    }];

}

#pragma mark - 根据新的关键字，刷新列表
/**
 *  @author             yangshengmeng, 15-04-15 11:04:54
 *
 *  @brief              根据给定的关键字，重新请求数据
 *
 *  @param searchKey    关键字
 *
 *  @since              1.0.0
 */
- (void)reloadDataWithSearchKey:(NSString *)searchKey
{

    self.searchKey = searchKey;
    [self.header beginRefreshing];

}

@end
