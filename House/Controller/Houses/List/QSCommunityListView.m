//
//  QSCommunityListView.m
//  House
//
//  Created by ysmeng on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommunityListView.h"
#import "QSCommunityCollectionViewCell.h"

#import "QSFilterDataModel.h"
#import "QSCommunityListReturnData.h"
#import "QSCommunityDataModel.h"

#import "QSRequestManager.h"
#import "QSCoreDataManager+Filter.h"
#import "QSCoreDataManager+House.h"

#import "MJRefresh.h"

@interface QSCommunityListView () <UICollectionViewDataSource,UICollectionViewDelegate>

///点击房源时的回调
@property (nonatomic,copy) void (^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

///数据源
@property (nonatomic,retain) QSCommunityListReturnData *dataSourceModel;

@end

@implementation QSCommunityListView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-14 14:04:02
 *
 *  @brief          创建小区列表
 *
 *  @param frame    大小和位置
 *  @param callBack 小区列表相关事件的回调
 *
 *  @return         返回当前创建的小区列表
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
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSCommunityCollectionViewCell class] forCellWithReuseIdentifier:@"communityCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(communityListHeaderRequest)];
        [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(communityListFooterRequest)];
        self.footer.hidden = YES;
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;

}

#pragma mark - 返回每一个小区的信息cell
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

#pragma mark - 返回一共有多少个小区/新房项
///返回一共有多少个小区/新房项
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.dataSourceModel.communityListHeaderData.communityList count];
    
}

#pragma mark - 点击房源
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

#pragma mark - 请求小区列表数据
///请求小区列表头数据
- (void)communityListHeaderRequest
{
    
    ///封装参数：主要是添加页码控制
    NSMutableDictionary *temParams = [NSMutableDictionary dictionaryWithDictionary:[QSCoreDataManager getHouseListRequestParams:fFilterMainTypeCommunity]];
    [temParams setObject:@"1" forKey:@"now_page"];
    [temParams setObject:@"10" forKey:@"page_num"];
    
    [QSRequestManager requestDataWithType:rRequestTypeCommunity andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSCommunityListReturnData *resultDataModel = resultData;
            
            ///将数据模型置为nil
            self.dataSourceModel = nil;
            
            ///判断是否有房子数据
            if ([resultDataModel.communityListHeaderData.communityList count] <= 0) {
                
                ///没有记录，显示暂无记录提示
                if (self.houseListTapCallBack) {
                    
                    self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
                    
                }
                
            } else {
                
                ///移除暂无记录
                if (self.houseListTapCallBack) {
                    
                    self.houseListTapCallBack(hHouseListActionTypeHaveRecord,nil);
                    
                }
                
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
            if (self.houseListTapCallBack) {
                
                self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
                
            }
        
        }
        
    }];

}

///获取更多数据
- (void)communityListFooterRequest
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
    NSMutableDictionary *temParams = [NSMutableDictionary dictionaryWithDictionary:[QSCoreDataManager getHouseListRequestParams:fFilterMainTypeCommunity]];
    [temParams setObject:[NSString stringWithFormat:@"%@",self.dataSourceModel.communityListHeaderData.next_page] forKey:@"now_page"];
    [temParams setObject:@"10" forKey:@"page_num"];
    
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

@end
