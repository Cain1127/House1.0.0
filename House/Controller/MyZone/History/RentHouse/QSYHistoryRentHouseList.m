//
//  QSYHistoryRentHouseList.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHistoryRentHouseList.h"

#import "QSCollectionWaterFlowLayout.h"

#import "QSYHistoryHouseCollectionViewCell.h"
#import "QSCustomHUDView.h"

#import "QSCoreDataManager+History.h"
#import "QSCoreDataManager+User.h"

#import "QSYHistoryRentHouseListReturnData.h"
#import "QSYHistoryListRentHouseDataModel.h"
#import "QSRentHouseInfoDataModel.h"
#import "QSRentHouseDetailDataModel.h"
#import "QSWRentHouseInfoDataModel.h"

#import "QSRequestManager.h"
#import "MJRefresh.h"

@interface QSYHistoryRentHouseList () <QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///点击房源时的回调
@property (nonatomic,copy) void(^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

@property (assign) BOOL isLocalData;                                        //!<是否是本地数据
@property (nonatomic,retain) NSMutableArray *customDataSource;              //!<数据源
@property (nonatomic,retain) QSYHistoryRentHouseListReturnData *dataModel;  //!<数据模型

@end

@implementation QSYHistoryRentHouseList

#pragma mark - 初台化
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack
{
    
    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
    if (self = [super initWithFrame:frame collectionViewLayout:defaultLayout]) {
        
        ///初始化数组
        self.customDataSource = [[NSMutableArray alloc] init];
        
        ///保存参数
        if (callBack) {
            
            self.houseListTapCallBack = callBack;
            
        }
        
        ///判断是否本数据
        self.isLocalData = ![QSCoreDataManager isLogin];
        
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSYHistoryHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(rentHouseListHeaderRequest)];
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;
    
}

#pragma mark - 返回当前的房源个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (!self.isLocalData) {
        
        return [self.dataModel.headerData.dataList count];
        
    }
    
    return [self.customDataSource count];
    
}

#pragma mark - 返回每一个房源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSYHistoryHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///数据模型
    QSRentHouseDetailDataModel *tempModel;
    if (self.isLocalData) {
        
        tempModel = self.customDataSource[indexPath.row];
        
    } else {
    
        QSYHistoryListRentHouseDataModel *historyModel = self.dataModel.headerData.dataList[indexPath.row];
        tempModel = [historyModel.houseInfo changeToRentHouseDetailModel];
    
    }
    
    [cellHouse updateHouseInfoCellUIWithDataModel:tempModel andHouseType:fFilterMainTypeRentalHouse andPickedBoxStatus:NO];
    cellHouse.isEditing = self.isEditing;
    cellHouse.selected = YES;
    
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

#pragma mark - 点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isEditing) {
        
        return;
        
    }
    
    ///数据模型
    QSRentHouseDetailDataModel *tempModel;
    if (self.isLocalData) {
        
        tempModel = self.customDataSource[indexPath.row];
        
    } else {
        
        QSYHistoryListRentHouseDataModel *historyModel = self.dataModel.headerData.dataList[indexPath.row];
        tempModel = [historyModel.houseInfo changeToRentHouseDetailModel];
        
    }

    if (self.houseListTapCallBack) {
        
        self.houseListTapCallBack(hHouseListActionTypeGotoDetail,tempModel);
        
    }

}

#pragma mark - 请求列表数据
- (void)rentHouseListHeaderRequest
{
    
    ///判断是否已登录
    if (!self.isLocalData) {
        
        ///下载服务端浏览记录
        [self downloadServerHistoryRentHouseData];
        return;
        
    }
    
    ///获取本地数据
    NSArray *tempArray = [QSCoreDataManager getLocalHistoryDataSourceWithType:fFilterMainTypeRentalHouse];
    
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

- (void)downloadServerHistoryRentHouseData
{
    
    ///封装参数
    NSDictionary *params = @{@"view_type" : @"990106",
                             @"key" : @"",
                             @"page_num" : @"10",
                             @"now_page" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeHistoryRentHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///重置数据源
        self.dataModel = nil;
        
        ///下载成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYHistoryRentHouseListReturnData *tempModel = resultData;
            if ([tempModel.headerData.dataList count] > 0) {
                
                self.dataModel = tempModel;
                
                if (self.houseListTapCallBack) {
                    
                    self.houseListTapCallBack(hHouseListActionTypeHaveRecord,nil);
                    
                }
                
                ///刷新数据
                [self reloadData];
                
                ///结束动画
                [self.header endRefreshing];
                
                ///保存数据
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [self saveHistoryRentHouseToLocal];
                    
                });
                
            } else {
                
                APPLICATION_LOG_INFO(@"下载服务端浏览出租房信息", @"服务端数据为空")
                self.isLocalData = YES;
                [self rentHouseListHeaderRequest];
                
            }
            
        } else {
            
            APPLICATION_LOG_INFO(@"下载服务端浏览出租房信息", @"失败")
            self.isLocalData = YES;
            [self rentHouseListHeaderRequest];
            
        }
        
    }];
    
}

- (void)saveHistoryRentHouseToLocal
{
    
    for (int i = 0; i < [self.dataModel.headerData.dataList count]; i++) {
        
        QSYHistoryListRentHouseDataModel *rentHouseModel = self.dataModel.headerData.dataList[i];
        
        BOOL isSave = [QSCoreDataManager checkDataIsSaveToLocal:rentHouseModel.view_id andHouseType:fFilterMainTypeRentalHouse];
        
        if (!isSave) {
            
            QSRentHouseDetailDataModel *saveModel = [rentHouseModel.houseInfo changeToRentHouseDetailModel];
            saveModel.house.is_syserver = @"1";
            [QSCoreDataManager saveHistoryDataWithModel:saveModel andHistoryType:fFilterMainTypeRentalHouse andCallBack:^(BOOL flag) {
                
                if (flag) {
                    
                    APPLICATION_LOG_INFO(@"浏览记录->出租房->同步服务端后保存本地", @"成功")
                    
                } else {
                    
                    APPLICATION_LOG_INFO(@"浏览记录->出租房->同步服务端后保存本地", @"失败")
                    
                }
                
            }];
            
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
    if (!isEditing &&
        ([self.customDataSource count] > 0 ||
         [self.dataModel.headerData.dataList count] > 0)) {
        
        [self clearHistoryRentHouse];
        
    } else {
    
        [self reloadData];
    
    }
    
}

- (void)clearHistoryRentHouse
{

    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在清空"];
    
    ///判断是否已登录
    if (![QSCoreDataManager isLogin]) {
        
        [self clearLocalHistoryData:NO];
        [hud hiddenCustomHUDWithFooterTips:@"已清空出租房浏览记录" andDelayTime:2.5f andCallBack:^(BOOL flag) {
            
            [self.header beginRefreshing];
            
        }];
        
        return;
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"log_type" : [NSString stringWithFormat:@"%d",hHistoryHouseTypeRentHouse]};
    
    [QSRequestManager requestDataWithType:rRequestTypeDeleteHistoryHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///清空成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self clearLocalHistoryData:YES];
            
            [hud hiddenCustomHUDWithFooterTips:@"已清空出租房浏览记录" andDelayTime:2.5f andCallBack:^(BOOL flag) {
                
                [self.header beginRefreshing];
                
            }];
            
        } else {
            
            [self clearLocalHistoryData:NO];
            [hud hiddenCustomHUDWithFooterTips:@"已清空出租房浏览记录" andDelayTime:2.5f andCallBack:^(BOOL flag) {
                
                [self.header beginRefreshing];
                
            }];
            
        }
        
    }];

}

- (void)clearLocalHistoryData:(BOOL)isSendServer
{

    [QSCoreDataManager deleteAllHistoryDataWithType:fFilterMainTypeRentalHouse isSysServer:isSendServer];

}

@end
