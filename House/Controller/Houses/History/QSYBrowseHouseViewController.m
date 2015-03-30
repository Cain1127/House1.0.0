//
//  QSYBrowseHouseViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYBrowseHouseViewController.h"
#import "QSYComparisonViewController.h"

#import "QSYHistoryHouseCollectionViewCell.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCoreDataManager+History.h"

#import "QSRentHouseDetailDataModel.h"
#import "QSSecondHouseDetailDataModel.h"
#import "QSWSecondHouseInfoDataModel.h"
#import "QSWRentHouseInfoDataModel.h"

#import "MJRefresh.h"

@interface QSYBrowseHouseViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;        //!<当前列表的房源类型
@property (nonatomic,strong) UICollectionView *houseListView;   //!<房源列表
@property (nonatomic,retain) NSMutableArray *dataSource;        //!<数据源
@property (nonatomic,retain) NSMutableArray *pickedHouseList;   //!<当前选择的房源列表

@end

@implementation QSYBrowseHouseViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建最近浏览对应类型房源的列表
 *
 *  @return         返回当前创建的浏览房源列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存列表类型
        self.houseType = houseType;
        
        ///初始化
        self.dataSource = [[NSMutableArray alloc] init];
        self.pickedHouseList = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"最近浏览房源"];
    
    ///确认选择按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeCommit];
    
    UIButton *commitedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断当前选择个数
        if ([self.pickedHouseList count] <= 1) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择至少2个房源进行对比", 1.0, ^(){})
            return;
            
        }
        
        ///进入比一比页面
        QSYComparisonViewController *comparisonVC = [[QSYComparisonViewController alloc] initWithPickedHouseList:self.pickedHouseList andHouseType:self.houseType];
        [self.navigationController pushViewController:comparisonVC animated:YES];
        
    }];
    [self setNavigationBarRightView:commitedButton];
    
}

- (void)createMainShowUI
{
    
    ///瀑布流布局器
    UICollectionViewFlowLayout *defaultLayout = [[UICollectionViewFlowLayout alloc] init];
    defaultLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    defaultLayout.sectionInset = UIEdgeInsetsMake(20.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT);

    self.houseListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) collectionViewLayout:defaultLayout];
    self.houseListView.alwaysBounceVertical = YES;
    self.houseListView.delegate = self;
    self.houseListView.dataSource = self;
    self.houseListView.showsHorizontalScrollIndicator = NO;
    self.houseListView.showsVerticalScrollIndicator = NO;
    self.houseListView.backgroundColor = [UIColor whiteColor];
    [self.houseListView registerClass:[QSYHistoryHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
    [self.houseListView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"noRecords"];
    [self.view addSubview:self.houseListView];
    
    ///添加刷新
    [self.houseListView addHeaderWithTarget:self action:@selector(historyHouseListHeaderRequest)];
    
    ///开始就刷新
    [self.houseListView headerBeginRefreshing];

}

#pragma mark - 获取最近浏览的记录
- (void)historyHouseListHeaderRequest
{

    NSArray *housesList = [QSCoreDataManager getLocalHistoryDataSourceWithType:self.houseType];
    if ([housesList count] > 0) {
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:housesList];
        
    } else {
    
        [self.dataSource removeAllObjects];
    
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.houseListView reloadData];
        [self.houseListView headerEndRefreshing];
        
    });

}

#pragma mark - 尺寸设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.dataSource count] > 0) {
        
        CGFloat width = (SIZE_DEVICE_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f) / 2.0f;
        CGFloat height = 139.5f + width * 247.0f / 330.0f;
        return CGSizeMake(width, height);
        
    }
    
    return CGSizeMake(SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT);

}

#pragma mark - 返回当前的房源个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if ([self.dataSource count] > 0) {
        
        return [self.dataSource count];
        
    }
    
    return 1;
    
}

#pragma mark - 返回每一个房源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.dataSource count] > 0) {
        
        ///复用标识
        static NSString *houseCellIndentify = @"houseCell";
        
        ///从复用队列中获取房子信息的cell
        QSYHistoryHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
        
        ///获取数据模型
        [cellHouse updateHouseInfoCellUIWithDataModel:self.dataSource[indexPath.row] andHouseType:self.houseType];
        
        ///设置选择状态
        [cellHouse setPickedTipsStatus:[self checkHouseIsSave:self.dataSource[indexPath.row]]];
        
        return cellHouse;
        
    } else {
        
        ///显示无记录
        static NSString *noRecordsCell = @"noRecords";
        UICollectionViewCell *cellNorecords = [collectionView dequeueReusableCellWithReuseIdentifier:noRecordsCell forIndexPath:indexPath];
        
        ///无记录说明信息
        UIImageView *tipsImage = (UIImageView *)[cellNorecords.contentView viewWithTag:3110];
        if (nil == tipsImage) {
            
            tipsImage = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 75.0f) / 2.0f, (SIZE_DEVICE_HEIGHT - 64.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f - 85.0f, 75.0f, 85.0f)];
            tipsImage.image = [UIImage imageNamed:IMAGE_PUBLIC_NOHISTORY];
            tipsImage.tag = 3110;
            [cellNorecords.contentView addSubview:tipsImage];
            
        }
        
        ///提示信息
        UILabel *tipsLabel = (UILabel *)[cellNorecords.contentView viewWithTag:3111];
        if (nil == tipsLabel) {
            
            tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsImage.frame.origin.y + tipsImage.frame.size.height + 15.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
            tipsLabel.text = @"暂无浏览房源";
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
            tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
            tipsLabel.tag = 3111;
            [cellNorecords.contentView addSubview:tipsLabel];
            
        }
        
        ///按钮:看看附近房源
        UIButton *tipsButton = (UIButton *)[cellNorecords.contentView viewWithTag:3112];
        if (nil == tipsButton) {
            
            QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
            buttonStyle.title = @"看看附近房源";
            
            tipsButton = [UIButton createBlockButtonWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 160.0f) / 2.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 15.0f, 160.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
                
                [self lookAroundHouseAction];
                
            }];
            tipsButton.tag = 3112;
            [cellNorecords.contentView addSubview:tipsButton];
            
        }
        
        return cellNorecords;
    
    }
    
}

#pragma 选择房源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///如果当前已添加达三个，则提示
    if ([self.pickedHouseList count] >= 3) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"最多只能选择3个房源进行对比", 1.0, ^(){})
        return;
        
    }

    ///不同的列表类型，取不同的数据模型
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        QSRentHouseDetailDataModel *tempModel = self.dataSource[indexPath.row];
        
        if ([self checkHouseIsSave:tempModel]) {
            
            [self.pickedHouseList removeObject:tempModel.house.id_];
            
        } else {
        
            [self.pickedHouseList addObject:tempModel.house.id_];
        
        }
        
        ///刷新UI
        [self.houseListView reloadData];
        
    }
    
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        QSSecondHouseDetailDataModel *tempModel = self.dataSource[indexPath.row];
        if ([self checkHouseIsSave:tempModel]) {
            
            [self.pickedHouseList removeObject:tempModel.house.id_];
            
        } else {
        
            [self.pickedHouseList addObject:tempModel.house.id_];
        
        }
        
        ///刷新UI
        [self.houseListView reloadData];
        
    }

}

#pragma mark - 检测当前选择的房源是否已保存
- (BOOL)checkHouseIsSave:(id)model
{

    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        QSRentHouseDetailDataModel *tempModel = model;
        
        for (int i = 0; i < [self.pickedHouseList count]; i++) {
            
            NSString *saveID = self.pickedHouseList[i];
            if ([saveID isEqualToString:tempModel.house.id_]) {
                
                return YES;
                
            }
            
        }
        
    } else if (fFilterMainTypeSecondHouse == self.houseType) {
        
        QSSecondHouseDetailDataModel *tempModel = model;
        for (int i = 0; i < [self.pickedHouseList count]; i++) {
            
            NSString *saveID = self.pickedHouseList[i];
            if ([saveID isEqualToString:tempModel.house.id_]) {
                
                return YES;
                
            }
            
        }
        
    }
    
    return NO;

}

#pragma mark - 看看附近房源事件
- (void)lookAroundHouseAction
{

    APPLICATION_LOG_INFO(@"看看附近房源", @"看看附近房源按钮事件")

}

@end
