//
//  QSWCommunityRentHouseList.m
//  House
//
//  Created by 王树朋 on 15/4/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWCommunityRentHouseList.h"

#import "QSHouseCollectionViewCell.h"
#import "QSHouseListTitleCollectionViewCell.h"
#import "QSCollectionWaterFlowLayout.h"

#import "QSRequestManager.h"
#import "QSRentHouseListReturnData.h"
#import "QSWRentHouseInfoDataModel.h"

#import "QSFilterDataModel.h"

#import "MJRefresh.h"

@interface QSWCommunityRentHouseList ()<QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///过滤器数据模型
@property (nonatomic,retain) QSFilterDataModel *filterModel;

///小区ID
@property (nonatomic,copy) NSString *communityID;

///点击房源时的回调
@property (nonatomic,copy) void (^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

///数据源
@property (nonatomic,retain)  QSRentHouseListReturnData *dataSourceModel;

@end

@implementation QSWCommunityRentHouseList

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame andCommunitID:(NSString *)communityID andFilter:(QSFilterDataModel *)filterModel andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack
{
    
    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
    if (self = [super initWithFrame:frame collectionViewLayout:defaultLayout]) {
        
        ///保存参数
        
        self.communityID = communityID;
        self.filterModel = filterModel;
        
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSHouseListTitleCollectionViewCell class] forCellWithReuseIdentifier:@"titleCell"];
        [self registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(houseListHeaderRequest)];
        [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(houseListFooterRequest)];
        self.footer.hidden = YES;
        
        ///开始就刷新
        [self.header beginRefreshing];
        
        
    }
    
    return self;
    
}

#pragma mark - 列表房源的个数
///返回当前显示的cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return ([self.dataSourceModel.headerData.rentHouseList count] > 0) ? ([self.dataSourceModel.headerData.rentHouseList count] + 1) : 0;
    
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
        [cellTitle updateTitleInfoWithTitle:[self.dataSourceModel.headerData.total_num stringValue] andSubTitle:@"套二手房信息"];
        
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

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return;
        
    }
    
    ///获取房子模型
    QSWRentHouseInfoDataModel *houseInfoModel = self.dataSourceModel.headerData.rentHouseList[indexPath.row - 1];
    
    ///回调
    if (self.houseListTapCallBack) {
        
        self.houseListTapCallBack(hHouseListActionTypeGotoDetail,houseInfoModel);
        
    }
    
}

#pragma mark - 加载推荐房源

- (void)reloadServerData:(QSFilterDataModel *)filterModel
{
    
    ///重置过滤器
    self.filterModel = filterModel;
    
    ///开始头刷新
    [self.header beginRefreshing];
    
}

#pragma mark - 请求数据
///请求第一页的数据
- (void)houseListHeaderRequest
{
    
    self.footer.hidden = YES;
    
    ///封装参数
    NSMutableDictionary *temParams = [[self.filterModel getCommunityRentHouseListParams] mutableCopy];
    [temParams setObject:APPLICATION_NSSTRING_SETTING(self.communityID, @"") forKey:@"village_id"];
    [temParams setObject:@"1" forKey:@"now_page"];
    [temParams setObject:@"10" forKey:@"page_num"];
    
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouse andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSRentHouseListReturnData *resultDataModel = resultData;
            
            ///将数据模型置为nil
            self.dataSourceModel = nil;
            
            ///判断是否有房子数据
            if ([resultDataModel.headerData.rentHouseList count] <= 0) {
                
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
                if ([self.dataSourceModel.headerData.per_page intValue] ==
                    [self.dataSourceModel.headerData.next_page intValue]) {
                    
                    [self.footer noticeNoMoreData];
                    
                } else {
                    
                    [self.footer resetNoMoreData];
                    
                }
                
            });
            
            ///结束刷新动画
            [self.header endRefreshing];
            
        } else {
            
            ///结束刷新动画
            [self.header endRefreshing];
            
            ///重置数据指针
            self.dataSourceModel = nil;
            
            ///刷新数据
            [self reloadData];
            
            ///由于是第一页，请求失败，显示暂无记录
            if (self.houseListTapCallBack) {
                
                self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
                
            }
            
        }
        
    }];
    
}


///请求更多数据
- (void)houseListFooterRequest
{
    
    ///判断是否最大页码
    if ([self.dataSourceModel.headerData.per_page intValue] == [self.dataSourceModel.headerData.next_page intValue]) {
        
        ///结束刷新动画
        [self.footer endRefreshing];
        [self.footer noticeNoMoreData];
        return;
        
    }
    
    ///封装参数：主要是添加页码控制
    NSMutableDictionary *temParams = [[self.filterModel getCommunityRentHouseListParams] mutableCopy];
    [temParams setObject:APPLICATION_NSSTRING_SETTING(self.communityID, @"") forKey:@"village_id"];
    [temParams setObject:self.dataSourceModel.headerData.next_page forKey:@"now_page"];
    [temParams setObject:@"10" forKey:@"page_num"];
    
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouse andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSRentHouseListReturnData *resultDataModel = resultData;
            
            ///判断是否有房子数据
            if ([resultDataModel.headerData.rentHouseList count] > 0) {
                
                ///重组数据源
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataSourceModel.headerData.referrals_list];
                self.dataSourceModel = resultDataModel;
                [tempArray addObjectsFromArray:resultDataModel.headerData.rentHouseList];
                self.dataSourceModel.headerData.rentHouseList = [NSArray arrayWithArray:tempArray];
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self reloadData];
                
                self.footer.hidden = NO;
                if ([self.dataSourceModel.headerData.per_page intValue] ==
                    [self.dataSourceModel.headerData.next_page intValue]) {
                    
                    [self.footer noticeNoMoreData];
                    
                } else {
                    
                    [self.footer resetNoMoreData];
                    
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
