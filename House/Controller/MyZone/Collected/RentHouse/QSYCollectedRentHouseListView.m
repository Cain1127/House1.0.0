//
//  QSYCollectedRentHouseListView.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYCollectedRentHouseListView.h"

#import "QSCollectionWaterFlowLayout.h"

#import "QSHouseCollectionViewCell.h"
#import "QSYHistoryHouseCollectionViewCell.h"

#import "QSRentHouseListReturnData.h"
#import "QSRentHouseInfoDataModel.h"
#import "QSRentHouseDetailDataModel.h"
#import "QSWRentHouseInfoDataModel.h"

#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+Collected.h"

#import "QSRequestManager.h"

#import "MJRefresh.h"

@interface QSYCollectedRentHouseListView () <QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///点击房源时的回调
@property (nonatomic,copy) void(^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

@property (nonatomic,retain) NSMutableArray *customDataSource;  //!<数据源
@property (nonatomic,retain) NSMutableArray *seletedDataSource; //!<当前选择删除的数据源
@property (nonatomic,assign) BOOL isLocalData;                  //!<是否是本地数据

///网络请求返回的数据模型
@property (nonatomic,retain) QSRentHouseListReturnData *dataSourceModel;

@end

@implementation QSYCollectedRentHouseListView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-01-30 08:01:06
 *
 *  @brief          创建收藏出租房列表，并且点击出租房时，回调
 *
 *  @param frame    大小和位置
 *  @param callBack 点击出租房时的回调
 *
 *  @return         返回当前创建的出租房列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack
{
    
    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
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
        self.seletedDataSource = [NSMutableArray array];
        
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSYHistoryHouseCollectionViewCell class] forCellWithReuseIdentifier:@"localHouseCell"];
        [self registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"serverHouseCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(rentHouseListHeaderRequest)];
        [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(rentHouseListFooterRequest)];
        self.footer.hidden = YES;
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;
    
}

#pragma mark - 请求列表数据
- (void)rentHouseListHeaderRequest
{
    
    if (!self.isLocalData) {
        
        ///封装参数
        NSDictionary *params = @{@"type" : @"200505",
                                 @"page_num " : @"10",
                                 @"now_page" : @"1"};
        
        ///获取网络数据
        [QSRequestManager requestDataWithType:rRequestTypeMyZoneCollectedRentHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///判断请求
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///请求成功后，转换模型
                QSRentHouseListReturnData *resultDataModel = resultData;
                
                ///将数据模型置为nil
                self.dataSourceModel = nil;
                
                ///判断是否有房子数据
                if ([resultDataModel.headerData.rentHouseList count] > 0) {
                    
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
        [self.customDataSource addObjectsFromArray:[QSCoreDataManager getLocalCollectedDataSourceWithType:fFilterMainTypeRentalHouse]];
        
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

- (void)rentHouseListFooterRequest
{
    
    if (!self.isLocalData) {
        
        ///判断是否最大页码
        self.footer.hidden = NO;
        if ([self.dataSourceModel.headerData.per_page intValue] ==
            [self.dataSourceModel.headerData.next_page intValue]) {
            
            [self.footer noticeNoMoreData];
            
            ///结束刷新动画
            [self.header endRefreshing];
            [self.footer endRefreshing];
            return;
            
        }
        
        ///封装参数：主要是添加页码控制
        NSDictionary *params = @{@"type" : @"200505",
                                 @"page_num " : @"10",
                                 @"now_page" : self.dataSourceModel.headerData.next_page};
        
        [QSRequestManager requestDataWithType:rRequestTypeMyZoneCollectedRentHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
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

#pragma mark - 布局器代理相关设置
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultSizeOfItemInSection:(NSInteger)section
{
    
    return (SIZE_DEVICE_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    
}

- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultScrollSizeOfItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = (SIZE_DEVICE_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f) / 2.0f;
    CGFloat height = 139.5f + width * 247.0f / 330.0f;
    return height;
    
}

- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultScrollSpaceOfItemInSection:(NSInteger)section
{
    
    return (SIZE_DEVICE_WIDTH > 320.0f ? 20.0f : 15.0f);
    
}

#pragma mark - 返回当前的房源个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (self.isLocalData) {
        
        return [self.customDataSource count];
        
    }
    
    return [self.dataSourceModel.headerData.rentHouseList count];
    
}

#pragma mark - 返回每一个房源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.isLocalData) {
        
        ///复用标识
        static NSString *serverHouseCellIndentify = @"serverHouseCell";
        
        ///从复用队列中获取房子信息的cell
        QSHouseCollectionViewCell *cellServerHouse = [collectionView dequeueReusableCellWithReuseIdentifier:serverHouseCellIndentify forIndexPath:indexPath];
        
        ///刷新数据
        [cellServerHouse updateHouseInfoCellUIWithDataModel:self.dataSourceModel.headerData.rentHouseList[indexPath.row] andListType:fFilterMainTypeRentalHouse];
        
        return cellServerHouse;
        
    }
    
    ///复用标识
    static NSString *localHouseCellIndentify = @"localHouseCell";
    
    ///从复用队列中获取房子信息的cell
    QSYHistoryHouseCollectionViewCell *cellLocalHouse = [collectionView dequeueReusableCellWithReuseIdentifier:localHouseCellIndentify forIndexPath:indexPath];
    
    ///获取数据模型
    QSRentHouseDetailDataModel *tempModel = self.customDataSource[indexPath.row];
    [cellLocalHouse updateHouseInfoCellUIWithDataModel:tempModel andHouseType:fFilterMainTypeRentalHouse andPickedBoxStatus:NO];
    
    return cellLocalHouse;
    
}

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isLocalData) {
        
        ///获取房子模型
        QSRentHouseDetailDataModel *houseInfoModel = self.customDataSource[indexPath.row];
        QSRentHouseInfoDataModel *tempModel = [[QSRentHouseInfoDataModel alloc] init];
        tempModel.title = houseInfoModel.house.title;
        tempModel.id_ = houseInfoModel.house.id_;
        if (self.houseListTapCallBack) {
            
            self.houseListTapCallBack(hHouseListActionTypeGotoDetail,tempModel);
            
        }
        
    } else {
        
        ///获取房子模型
        QSRentHouseInfoDataModel *tempModel = self.dataSourceModel.headerData.rentHouseList[indexPath.row];
        if (self.houseListTapCallBack) {
            
            self.houseListTapCallBack(hHouseListActionTypeGotoDetail,tempModel);
            
        }
        
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

#pragma mark - 重新校对数据
- (void)updateLocalData
{
    
    ///网络请求的收藏数据
    NSArray *tempServerArray = [NSArray arrayWithArray:self.dataSourceModel.headerData.rentHouseList];
    
    if ([tempServerArray count] <= 0) {
        
        return;
        
    }
    
    ///查找本地是否已存在对应收藏
    for (int i = 0;i < [tempServerArray count];i++) {
        
        QSRentHouseInfoDataModel *serverModel = tempServerArray[i];
        serverModel.is_syserver = @"1";
        [QSCoreDataManager saveCollectedDataWithModel:serverModel andCollectedType:fFilterMainTypeRentalHouse andCallBack:^(BOOL flag) {
            
            ///保存成功
            if (flag) {
                
                APPLICATION_LOG_INFO(@"添加出租房收藏->服务端数据更新本地数据", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加出租房收藏->服务端数据更新本地数据", @"失败")
                
            }
            
        }];
        
    }
    
}

#pragma mark - 设置编辑状态
/**
 *  @author             yangshengmeng, 15-05-03 12:05:28
 *
 *  @brief              通过给定的数字设置当前的编辑状态
 *
 *  @param isEditing    0-未编辑状态；1-编辑状态
 *
 *  @since              1.0.0
 */
- (void)setIsEditingWithNumber:(NSNumber *)isEditing
{
    
    if ([isEditing intValue] == 1) {
        
        self.isEditing = YES;
        
    } else {
        
        self.isEditing = NO;
        
    }
    
}

- (void)setIsEditing:(BOOL)isEditing
{
    
    _isEditing = isEditing;
    [self reloadData];
    
}

@end
