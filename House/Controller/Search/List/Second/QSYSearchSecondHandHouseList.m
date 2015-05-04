//
//  QSYSearchSecondHandHouseList.m
//  House
//
//  Created by ysmeng on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSearchSecondHandHouseList.h"

#import "QSHouseListTitleCollectionViewCell.h"
#import "QSHouseCollectionViewCell.h"

#import "QSCollectionWaterFlowLayout.h"

#import "QSSecondHandHouseListReturnData.h"

#import "QSRequestManager.h"
#import "MJRefresh.h"

@interface QSYSearchSecondHandHouseList () <QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///搜索关键字
@property (nonatomic,copy) NSString *searchKey;

///点击房源时的回调
@property (nonatomic,copy) void (^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

///数据源
@property (nonatomic,retain) QSSecondHandHouseListReturnData *dataSourceModel;

@end

@implementation QSYSearchSecondHandHouseList

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-15 11:04:45
 *
 *  @brief              创建搜索的二手房列表
 *
 *  @param frame        大小和位置
 *  @param searchKey    当前的搜索关键字
 *  @param callBack     列表中的回调
 *
 *  @return             返回当前创建的二手房列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSearchKey:(NSString *)searchKey andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack
{

    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
    if (self = [super initWithFrame:frame collectionViewLayout:defaultLayout]) {
        
        ///保存参数
        if (callBack) {
            
            self.houseListTapCallBack = callBack;
            
        }
        
        self.searchKey = searchKey;
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSHouseListTitleCollectionViewCell class] forCellWithReuseIdentifier:@"titleCell"];
        [self registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(requestHeaderData)];
        [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestListFooterData)];
        self.footer.hidden = YES;
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;

}

#pragma mark - 返回信息cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///判断是否标题栏
    if (0 == indexPath.row) {
        
        ///复用标识
        static NSString *titleCellIndentify = @"titleCell";
        
        ///从复用队列中获取cell
        QSHouseListTitleCollectionViewCell *cellTitle = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellIndentify forIndexPath:indexPath];
        
        ///更新数据
        [cellTitle updateTitleInfoWithTitle:[self.dataSourceModel.secondHandHouseHeaderData.total_num stringValue] andSubTitle:@"套二手房信息"];
        
        return cellTitle;
        
    }
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///刷新数据
    QSHouseInfoDataModel *tempModel;
    if ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] > 0) {
        
        tempModel = self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1];
        
    } else if ([self.dataSourceModel.secondHandHouseHeaderData.referrals_list count] > 0) {
    
        tempModel = self.dataSourceModel.secondHandHouseHeaderData.referrals_list[indexPath.row - 1];
    
    }
    
    [cellHouse updateHouseInfoCellUIWithDataModel:tempModel andListType:fFilterMainTypeSecondHouse];
    
    return cellHouse;
    
}

#pragma mark - 布局尺寸相关设置
///返回当前显示的cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger sumCount = [self.dataSourceModel.secondHandHouseHeaderData.houseList count];
    NSInteger sumRecommendCount = [self.dataSourceModel.secondHandHouseHeaderData.referrals_list count];
    return (sumCount > 0) ? (sumCount + 1) : (sumRecommendCount > 0 ? (sumRecommendCount + 1) : 0);
    
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

///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///数量提醒项点击时，不动作
    if (indexPath.row == 0) {
        
        return;
        
    }
    
    ///获取房子模型
    QSHouseInfoDataModel *houseInfoModel;
    if ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] > 0) {
        
        houseInfoModel = self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1];
        
    } else if ([self.dataSourceModel.secondHandHouseHeaderData.referrals_list count] > 0) {
    
        houseInfoModel = self.dataSourceModel.secondHandHouseHeaderData.referrals_list[indexPath.row - 1];
    
    }
    
    ///回调
    if (self.houseListTapCallBack) {
        
        self.houseListTapCallBack(hHouseListActionTypeGotoDetail,houseInfoModel);
        
    }
    
}

#pragma mark - 请求数据
- (void)requestHeaderData
{
    
    ///封装参数：主要是添加页码控制
    self.footer.hidden = YES;
    NSDictionary *temParams = @{@"now_page" : @"1",
                                @"page_num" : @"10",
                                @"key" : APPLICATION_NSSTRING_SETTING(self.searchKey, @"")};
    
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
                
                ///回调通知存在搜索结果
                if (self.houseListTapCallBack) {
                    
                    self.houseListTapCallBack(hHouseListActionTypeSearchHaveResult,nil);
                    
                }
                
            } else if ([resultDataModel.secondHandHouseHeaderData.referrals_list count] > 0) {
            
                ///更新数据源
                self.dataSourceModel = resultDataModel;
                
                ///回调通知不存在搜索结果
                if (self.houseListTapCallBack) {
                    
                    self.houseListTapCallBack(hHouseListActionTypeSearchNoResult,nil);
                    
                }
            
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self reloadData];
                
                self.footer.hidden = NO;
                if ([self.dataSourceModel.secondHandHouseHeaderData.per_page intValue] ==
                    [self.dataSourceModel.secondHandHouseHeaderData.next_page intValue]) {
                    
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
            self.footer.hidden = YES;
            
            ///回调暂无数据
            if (self.houseListTapCallBack) {
                
                self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
                
            }
            
        }
        
    }];
    
}

- (void)requestListFooterData
{
    
    ///判断是否最大页码
    if ([self.dataSourceModel.secondHandHouseHeaderData.per_page intValue] == [self.dataSourceModel.secondHandHouseHeaderData.next_page intValue]) {
        
        ///结束刷新动画
        self.footer.hidden = NO;
        [self.footer noticeNoMoreData];
        [self.footer endRefreshing];
        return;
        
    }
    
    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"now_page" : @"1",
                                @"page_num" : self.dataSourceModel.secondHandHouseHeaderData.next_page,
                                @"commend" : @"Y"};
    
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseList andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSSecondHandHouseListReturnData *resultDataModel = resultData;
            
            ///更改房子数据
            NSMutableArray *localArray = [NSMutableArray arrayWithArray:self.dataSourceModel.secondHandHouseHeaderData.houseList];
            
            ///更新数据源
            self.dataSourceModel = resultDataModel;
            [localArray addObjectsFromArray:resultDataModel.secondHandHouseHeaderData.houseList];
            self.dataSourceModel.secondHandHouseHeaderData.houseList = localArray;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self reloadData];
                
                self.footer.hidden = NO;
                if ([self.dataSourceModel.secondHandHouseHeaderData.per_page intValue] ==
                    [self.dataSourceModel.secondHandHouseHeaderData.next_page intValue]) {
                    
                    [self.footer noticeNoMoreData];
                    
                } else {
                    
                    [self.footer resetNoMoreData];
                    
                }
                
            });
            
            ///结束刷新动画
            [self.footer endRefreshing];
            
            ///回调告知ViewController，当前已满足摇一摇的触发条件
            if (([self.dataSourceModel.secondHandHouseHeaderData.per_page intValue] + 1) % 8 == 0) {
                
                if (self.houseListTapCallBack) {
                    
                    self.houseListTapCallBack(hHouseListActionTypeShake,nil);
                    
                }
                
            }
            
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
