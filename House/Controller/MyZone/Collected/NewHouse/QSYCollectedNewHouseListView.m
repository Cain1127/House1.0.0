//
//  QSYCollectedNewHouseListView.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYCollectedNewHouseListView.h"

#import "QSCommunityCollectionViewCell.h"

#import "QSNewHouseListReturnData.h"
#import "QSNewHouseInfoDataModel.h"

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
        
        self.backgroundColor = [UIColor redColor];
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSCommunityCollectionViewCell class] forCellWithReuseIdentifier:@"newHouseInfoCell"];
        
        ///添加刷新
        [self addHeaderWithTarget:self action:@selector(newHouseListHeaderRequest)];
        [self addFooterWithTarget:self action:@selector(newHouseListFooterRequest)];
        
        ///开始就刷新
        [self headerBeginRefreshing];
        
    }
    
    return self;

}

#pragma mark - 请求列表数据
- (void)newHouseListHeaderRequest
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self headerEndRefreshing];
        [self footerEndRefreshing];
        
    });

}

- (void)newHouseListFooterRequest
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self headerEndRefreshing];
        [self footerEndRefreshing];
        
    });

}

#pragma mark - 返回当前的房源个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (self.isLocalData) {
        
        return [self.customDataSource count];
        
    }
    
    return 0;
    
}

#pragma mark - 返回每一个房源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *normalCellName = @"newHouseInfoCell";
    
    ///从复用队列中返回cell
    QSCommunityCollectionViewCell *cellNormal = [collectionView dequeueReusableCellWithReuseIdentifier:normalCellName forIndexPath:indexPath];
    
    ///获取数据
    QSNewHouseInfoDataModel *tempModel;
    if (self.isLocalData) {
        
        tempModel = self.customDataSource[indexPath.row];
        
    } else {
    
        tempModel = self.dataSourceModel.headerData.houseList[indexPath.row];
    
    }
    
    ///刷新数据
    [cellNormal updateCommunityInfoCellUIWithDataModel:tempModel andListType:fFilterMainTypeCommunity];
    
    return cellNormal;
    
}

@end
