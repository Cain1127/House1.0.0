//
//  QSYHistoryNewHouseListView.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryNewHouseListView.h"

#import "QSAttentionCommunityCell.h"

#import "QSNewHouseListReturnData.h"
#import "QSNewHouseInfoDataModel.h"

#import "QSCoreDataManager+History.h"

#import "MJRefresh.h"

@interface QSYHistoryNewHouseListView () <UICollectionViewDataSource,UICollectionViewDelegate>

///点击房源时的回调
@property (nonatomic,copy) void(^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

@property (nonatomic,retain) NSMutableArray *customDataSource;  //!<数据源
@property (nonatomic,assign) BOOL isLocalData;                  //!<是否是本地数据

///网络请求返回的数据模型
@property (nonatomic,retain) QSNewHouseListReturnData *dataSourceModel;

@end

@implementation QSYHistoryNewHouseListView

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
        
        ///初始化数据源
        self.customDataSource = [[NSMutableArray alloc] init];
        
        ///保存参数
        if (callBack) {
            
            self.houseListTapCallBack = callBack;
            
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSAttentionCommunityCell class] forCellWithReuseIdentifier:@"newHouseInfoCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(newHouseListHeaderRequest)];
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;
    
}

#pragma mark - 请求列表数据
- (void)newHouseListHeaderRequest
{
    
    ///获取本地数据
    NSArray *tempArray = [QSCoreDataManager getLocalHistoryDataSourceWithType:fFilterMainTypeNewHouse];
    
    if ([tempArray count] > 0) {
        
        if (self.houseListTapCallBack) {
            
            self.houseListTapCallBack(hHouseListActionTypeHaveRecord,nil);
            
        }
        
        [self.customDataSource removeAllObjects];
        [self.customDataSource addObjectsFromArray:tempArray];
        [self reloadData];
        
        [self.header endRefreshing];
        
    } else {
        
        if (self.houseListTapCallBack) {
            
            self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
            
        }
        
        [self.customDataSource removeAllObjects];
        [self reloadData];
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
    }
    
}

#pragma mark - 返回当前的房源个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.customDataSource count];
    
}

#pragma mark - 返回每一个房源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *normalCellName = @"newHouseInfoCell";
    
    ///从复用队列中返回cell
    QSAttentionCommunityCell *cellNormal = [collectionView dequeueReusableCellWithReuseIdentifier:normalCellName forIndexPath:indexPath];
    
    ///获取数据
    QSNewHouseDetailDataModel *tempModel = self.customDataSource[indexPath.row];
    
    ///刷新数据
    [cellNormal updateHistoryNewHouseInfoCellUIWithDataModel:tempModel];
    
    return cellNormal;
    
}

#pragma mark - 进入新房详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    ///获取数据
    QSNewHouseDetailDataModel *tempModel = self.customDataSource[indexPath.row];
    if (self.houseListTapCallBack) {
        
        self.houseListTapCallBack(hHouseListActionTypeGotoDetail,tempModel);
        
    }

}

@end
