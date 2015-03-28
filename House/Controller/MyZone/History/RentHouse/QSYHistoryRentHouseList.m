//
//  QSYHistoryRentHouseList.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryRentHouseList.h"

#import "QSCollectionWaterFlowLayout.h"

#import "QSHouseCollectionViewCell.h"

#import "QSRentHouseListReturnData.h"
#import "QSRentHouseInfoDataModel.h"

#import "MJRefresh.h"

@interface QSYHistoryRentHouseList () <QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///点击房源时的回调
@property (nonatomic,copy) void(^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

@property (nonatomic,retain) NSMutableArray *customDataSource;  //!<数据源
@property (nonatomic,assign) BOOL isLocalData;                  //!<是否是本地数据

///网络请求返回的数据模型
@property (nonatomic,retain) QSRentHouseListReturnData *dataSourceModel;

@end

@implementation QSYHistoryRentHouseList

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
        
        self.backgroundColor = [UIColor blueColor];
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
        
        ///添加刷新
        [self addHeaderWithTarget:self action:@selector(rentHouseListHeaderRequest)];
        [self addFooterWithTarget:self action:@selector(rentHouseListFooterRequest)];
        
        ///开始就刷新
        [self headerBeginRefreshing];
        
    }
    
    return self;
    
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
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///获取数据模型
    QSRentHouseInfoDataModel *tempModel;
    if (self.isLocalData) {
        
        tempModel = self.customDataSource[indexPath.row];
        
    } else {
        
        tempModel = self.dataSourceModel.headerData.rentHouseList[indexPath.row];
        
    }
    [cellHouse updateHouseInfoCellUIWithDataModel:tempModel andListType:fFilterMainTypeSecondHouse];
    
    return cellHouse;
    
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

#pragma mark - 请求列表数据
- (void)rentHouseListHeaderRequest
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self headerEndRefreshing];
        [self footerEndRefreshing];
        
    });
    
}

- (void)rentHouseListFooterRequest
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self headerEndRefreshing];
        [self footerEndRefreshing];
        
    });
    
}

@end
