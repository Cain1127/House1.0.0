//
//  QSYHistorySecondHandHouseListView.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistorySecondHandHouseListView.h"

#import "QSCollectionWaterFlowLayout.h"

#import "QSYHistoryHouseCollectionViewCell.h"
#import "QSCustomHUDView.h"

#import "QSCoreDataManager+History.h"
#import "QSCoreDataManager+User.h"

#import "QSRequestManager.h"
#import "MJRefresh.h"

@interface QSYHistorySecondHandHouseListView () <QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///点击房源时的回调
@property (nonatomic,copy) void(^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

@property (nonatomic,retain) NSMutableArray *customDataSource;  //!<数据源

@end

@implementation QSYHistorySecondHandHouseListView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-01-30 08:01:06
 *
 *  @brief          创建收藏二手房列表，并且点击二手房时，回调
 *
 *  @param frame    大小和位置
 *  @param callBack 点击二手房时的回调
 *
 *  @return         返回当前创建的二手房列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack
{
    
    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
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
        [self registerClass:[QSYHistoryHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(secondHandHouseListHeaderRequest)];
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;
    
}

#pragma mark - 请求列表数据
- (void)secondHandHouseListHeaderRequest
{
    
    ///获取本地数据
    NSArray *tempArray = [QSCoreDataManager getLocalHistoryDataSourceWithType:fFilterMainTypeSecondHouse];
    
    if ([tempArray count] > 0) {
        
        if (self.houseListTapCallBack) {
            
            self.houseListTapCallBack(hHouseListActionTypeHaveRecord,nil);
            
        }
        
        [self.customDataSource removeAllObjects];
        [self.customDataSource addObjectsFromArray:tempArray];
        [self reloadData];
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
    } else {
        
        [self.customDataSource removeAllObjects];
        [self reloadData];
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
        if (self.houseListTapCallBack) {
            
            self.houseListTapCallBack(hHouseListActionTypeNoRecord,nil);
            
        }
        
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
    
    return [self.customDataSource count];
    
}

#pragma mark - 返回每一个房源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSYHistoryHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];

    [cellHouse updateHouseInfoCellUIWithDataModel:self.customDataSource[indexPath.row] andHouseType:fFilterMainTypeSecondHouse andPickedBoxStatus:NO];
    cellHouse.isEditing = self.isEditing;
    cellHouse.selected = YES;
    
    return cellHouse;
    
}

#pragma mark - 点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isEditing) {
        
        return;
        
    }
    
    if ([self.customDataSource count] > 0) {
        
        if (self.houseListTapCallBack) {
            
            self.houseListTapCallBack(hHouseListActionTypeGotoDetail,self.customDataSource[indexPath.row]);
            
        }
        
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
    
    ///判断是否是删除
    if (!isEditing && [self.customDataSource count] > 0) {
        
        [self clearHistorySecondHandHouse];
        
    } else {
        
        [self reloadData];
        
    }
    
}

- (void)clearHistorySecondHandHouse
{
    
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在清空"];
    
    ///判断是否已登录
    if (![QSCoreDataManager isLogin]) {
        
        [self clearLocalHistoryData:NO];
        [hud hiddenCustomHUDWithFooterTips:@"已清空二手房浏览记录" andDelayTime:2.5f andCallBack:^(BOOL flag) {
            
            [self.header beginRefreshing];
            
        }];
        
        return;
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"log_type" : [NSString stringWithFormat:@"%d",hHistoryHouseTypeSecondHandHouse]};
    
    [QSRequestManager requestDataWithType:rRequestTypeDeleteHistoryHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///清空成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self clearLocalHistoryData:YES];
            [hud hiddenCustomHUDWithFooterTips:@"已清空二手房浏览记录" andDelayTime:2.5f andCallBack:^(BOOL flag) {
                
                [self.header beginRefreshing];
                
            }];
            
        } else {
            
            [self clearLocalHistoryData:NO];
            [hud hiddenCustomHUDWithFooterTips:@"已清空二手房浏览记录" andDelayTime:2.5f andCallBack:^(BOOL flag) {
                
                [self.header beginRefreshing];
                
            }];
            
        }
        
    }];
    
}

- (void)clearLocalHistoryData:(BOOL)isSendServer
{
    
    [QSCoreDataManager deleteAllHistoryDataWithType:fFilterMainTypeSecondHouse isSysServer:isSendServer];
    
}

@end
