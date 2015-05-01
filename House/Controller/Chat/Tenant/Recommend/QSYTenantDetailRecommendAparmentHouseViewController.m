//
//  QSYTenantDetailRecommendAparmentHouseViewController.m
//  House
//
//  Created by ysmeng on 15/4/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYTenantDetailRecommendAparmentHouseViewController.h"

#import "QSYTenantDetailRecommendAparmentTableViewCell.h"
#import "QSHouseListTitleCollectionViewCell.h"

#import "QSCollectionWaterFlowLayout.h"

#import "QSSecondHandHouseListReturnData.h"

#import "QSCoreDataManager+User.h"

#import "MJRefresh.h"

@interface QSYTenantDetailRecommendAparmentHouseViewController () <QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///选择物业后的回调
@property (nonatomic,copy) void(^pickedHouseCallBack)(BOOL isPicked,QSBaseModel *houseModel,NSString *commend);

@property (nonatomic,strong) UICollectionView *houseListView;                   //!<房源列表
@property (nonatomic,retain) QSSecondHandHouseListReturnData *dataSourceModel;  //!<数据源

@end

@implementation QSYTenantDetailRecommendAparmentHouseViewController

#pragma mark - 初始
/**
 *  @author         yangshengmeng, 15-04-30 15:04:08
 *
 *  @brief          根据推荐房源回调，创建二手房选择列表
 *
 *  @param callBack 推荐房源回调
 *
 *  @return         返回当前创建的二手房列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithCallBack:(void(^)(BOOL isPicked,QSBaseModel *houseModel,NSString *commend))callBack
{

    if (self = [super init]) {
        
        self.pickedHouseCallBack = callBack;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"选择我的物业"];

}

- (void)createMainShowUI
{
    
    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
    self.houseListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) collectionViewLayout:defaultLayout];
    
    self.houseListView.backgroundColor = [UIColor whiteColor];
    self.houseListView.delegate = self;
    self.houseListView.dataSource = self;
    self.houseListView.showsHorizontalScrollIndicator = NO;
    self.houseListView.showsVerticalScrollIndicator = NO;
    [self.houseListView registerClass:[QSHouseListTitleCollectionViewCell class] forCellWithReuseIdentifier:@"titleCell"];
    [self.houseListView registerClass:[QSYTenantDetailRecommendAparmentTableViewCell class] forCellWithReuseIdentifier:@"houseCell"];
    [self.view addSubview:self.houseListView];
    
    ///添加刷新
    [self.houseListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(rentHouseListHeaderRequest)];
    
    ///开始就刷新
    [self.houseListView.header beginRefreshing];
    
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
        [cellTitle updateTitleInfoWithTitle:[self.dataSourceModel.secondHandHouseHeaderData.total_num stringValue] andSubTitle:@"套二手房信息"];
        
        return cellTitle;
        
    }
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSYTenantDetailRecommendAparmentTableViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///刷新数据
    id tempModel = self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1];
    if (tempModel) {
        
        [cellHouse updateTenantDetailRecommendAparmentUI:self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1]];
        
    }
    
    return cellHouse;
    
}

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///数量提醒项点击时，不动作
    if (indexPath.row == 0) {
        
        return;
        
    }
    
    ///获取房子模型
//    QSHouseInfoDataModel *houseInfoModel = self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1];
    
    ///弹出提示
}

#pragma mark - 瀑布流配置
///返回当前显示的cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger sumCount = [self.dataSourceModel.secondHandHouseHeaderData.houseList count];
    return (sumCount > 0) ? (sumCount + 1) : 0;
    
}

///房源的宽度
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

#pragma mark - 下载数据
- (void)rentHouseListHeaderRequest
{
    
    ///封装参数
    NSString *userID = [QSCoreDataManager getUserID];
    NSDictionary *params = @{@"data_user_id" : APPLICATION_NSSTRING_SETTING(userID, @"")};
    
    ///请求
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSSecondHandHouseListReturnData *tempModel = resultData;
            if ([tempModel.secondHandHouseHeaderData.houseList count] > 0) {
                
                self.dataSourceModel = tempModel;
                
            } else {
            
                self.dataSourceModel = nil;
            
            }
            
            ///结束刷新
            [self.houseListView reloadData];
            [self.houseListView.header endRefreshing];
            
        } else {
            
            [self.houseListView reloadData];
            [self.houseListView.header endRefreshing];
            
        }
        
    }];
    
}

@end
