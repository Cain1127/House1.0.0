//
//  QSYRecommendSecondHandHouseList.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRecommendSecondHandHouseList.h"

#import "QSHouseCollectionViewCell.h"

#import "QSCollectionWaterFlowLayout.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "QSHouseInfoDataModel.h"
#import "QSSecondHandHouseListReturnData.h"

#import "QSRequestManager.h"

#import "MJRefresh.h"

@interface QSYRecommendSecondHandHouseList () <QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///点击房源时的回调
@property (nonatomic,copy) void (^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,QSHouseInfoDataModel *tempModel);

///数据源
@property (nonatomic,retain) QSSecondHandHouseListReturnData *dataSourceModel;

@end

@implementation QSYRecommendSecondHandHouseList

#pragma mark - 初始化
///初始化
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,QSHouseInfoDataModel *tempModel))callBack
{
    
    ///瀑布流布局器
    QSCollectionWaterFlowLayout *defaultLayout = [[QSCollectionWaterFlowLayout alloc] initWithScrollDirection:UICollectionViewScrollDirectionVertical];
    defaultLayout.delegate = self;
    
    if (self = [super initWithFrame:frame collectionViewLayout:defaultLayout]) {
        
        ///保存回调
        if (callBack) {
            
            self.houseListTapCallBack = callBack;
            
        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"titleCell"];
        
        ///添加刷新
        [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(houseListHeaderRequest)];
        
        ///开始就刷新
        [self.header beginRefreshing];
        
    }
    
    return self;
    
}

#pragma mark - 请求数据
///请求第一页的数据
- (void)houseListHeaderRequest
{
    
    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"commend" : @"Y",
                                @"now_page" : @"1",
                                @"page_num" : @"10"};
    
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
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self reloadData];
                
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
            
        }
        
    }];
    
}

#pragma mark - 列表房源的个数
///返回当前显示的cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] > 0) ? ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] + 1) : 0;
    
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
        
        return 44.0f;
        
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
    
    ///判断是否是无数据
    if ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] <= 0) {
        
        ///复用标识
        static NSString *titleCellIndentify = @"titleCell";
        
        ///从复用队列中获取cell
        UICollectionViewCell *cellTitle = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellIndentify forIndexPath:indexPath];
        
        ///删除换一批按钮
        UIView *changeButton = [cellTitle.contentView viewWithTag:112];
        if (changeButton) {
            
            [changeButton removeFromSuperview];
            
        }
        
        UIView *sepLabel = [cellTitle.contentView viewWithTag:113];
        if (sepLabel) {
            
            [sepLabel removeFromSuperview];
            
        }
        
        ///显示提示信息
        UIImageView *tipsImage = (UIImageView *)[cellTitle.contentView viewWithTag:110];
        if (nil == tipsImage) {
            
            tipsImage = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 75.0f) / 2.0f, (SIZE_DEVICE_HEIGHT - 64.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f - 85.0f, 75.0f, 85.0f)];
            tipsImage.image = [UIImage imageNamed:IMAGE_PUBLIC_NOHISTORY];
            tipsImage.tag = 110;
            [cellTitle.contentView addSubview:tipsImage];
            
        }
        
        ///提示信息
        UILabel *tipsLabel = (UILabel *)[cellTitle.contentView viewWithTag:111];
        if (nil == tipsLabel) {
            
            tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsImage.frame.origin.y + tipsImage.frame.size.height + 15.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
            tipsLabel.text = @"暂无推荐房源";
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
            tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
            tipsLabel.tag = 111;
            [cellTitle.contentView addSubview:tipsLabel];
            
        }
        
        return cellTitle;
        
    }
    
    ///判断是否标题栏
    if (0 == indexPath.row) {
        
        ///复用标识
        static NSString *titleCellIndentify = @"titleCell";
        
        ///从复用队列中获取cell
        UICollectionViewCell *cellTitle = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellIndentify forIndexPath:indexPath];
        
        ///更新数据
        ///删除无记录提示
        UIView *noRecordsImage = [cellTitle.contentView viewWithTag:110];
        if (noRecordsImage) {
            
            [noRecordsImage removeFromSuperview];
            
        }
        
        UIView *noRecordsLabel = [cellTitle.contentView viewWithTag:111];
        if (noRecordsLabel) {
            
            [noRecordsLabel removeFromSuperview];
            
        }
        
        ///显示提示信息
        UIButton *tipsButton = (UIButton *)[cellTitle.contentView viewWithTag:112];
        if (nil == tipsButton) {
            
            QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
            buttonStyle.title = @"换一批";
            buttonStyle.titleFont = [UIFont boldSystemFontOfSize:FONT_BODY_25];
            
            tipsButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, cellTitle.frame.size.width - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, cellTitle.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
                
                [self.header beginRefreshing];
                
            }];
            tipsButton.tag = 112;
            tipsButton.titleLabel.textAlignment = NSTextAlignmentLeft;
            [cellTitle.contentView addSubview:tipsButton];
            
        }
        
        ///分隔线
        UILabel *sepLineLable = (UILabel *)[cellTitle.contentView viewWithTag:113];
        if (nil == sepLineLable) {
            
            sepLineLable = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, cellTitle.frame.size.height - 0.25f, cellTitle.frame.size.width - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f)];
            sepLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
            sepLineLable.tag = 113;
            [cellTitle.contentView addSubview:sepLineLable];
        }
        
        return cellTitle;
        
    }
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///刷新数据
    [cellHouse updateHouseInfoCellUIWithDataModel:self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1] andListType:fFilterMainTypeSecondHouse];
    
    return cellHouse;
    
}

#pragma mark - 点击房源
///点击房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.dataSourceModel.secondHandHouseHeaderData.houseList count] <= 0) {
        
        return;
        
    }
    
    ///获取房子模型
    QSHouseInfoDataModel *houseInfoModel = self.dataSourceModel.secondHandHouseHeaderData.houseList[indexPath.row - 1];
    
    ///回调
    if (self.houseListTapCallBack) {
        
        self.houseListTapCallBack(hHouseListActionTypeGotoDetail,houseInfoModel);
        
    }
    
}

@end
