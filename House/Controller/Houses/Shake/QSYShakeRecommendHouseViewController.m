//
//  QSYShakeRecommendHouseViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYShakeRecommendHouseViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSRentHouseDetailViewController.h"

#import "QSYRecommendSecondHandHouseList.h"
#import "QSYRecommendRentHouseList.h"

#import "QSHouseInfoDataModel.h"
#import "QSRentHouseInfoDataModel.h"

#import "MJRefresh.h"

@interface QSYShakeRecommendHouseViewController ()

@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;        //!<房源类型
@property (nonatomic,strong) UICollectionView *houseListView;   //!<房源列表
@property (assign) BOOL isNeedRefresh;                          //!<是否需要刷新

@end

@implementation QSYShakeRecommendHouseViewController

#pragma mark - 初始化
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存房源类型
        self.houseType = houseType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"猜你喜欢房源"];

}

- (void)createMainShowUI
{
    
    ///不同的房源类型，加载不同的列表
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        self.houseListView = [[QSYRecommendRentHouseList alloc] initWithFrame:CGRectMake(0.0f, 84.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 84.0f) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, QSRentHouseInfoDataModel *tempModel) {
            
            if (hHouseListActionTypeGotoDetail == actionType) {
                
                ///进入详情页
                [self gotoRecommendHouseDetail:tempModel];
                
            }
            
        }];
        [self.view addSubview:self.houseListView];
        
    }
    
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        self.houseListView = [[QSYRecommendSecondHandHouseList alloc] initWithFrame:CGRectMake(0.0f, 84.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 84.0f) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, QSHouseInfoDataModel *tempModel) {
            
            if (hHouseListActionTypeGotoDetail == actionType) {
                
                ///进入详情页
                [self gotoRecommendHouseDetail:tempModel];
                
            }
            
        }];
        [self.view addSubview:self.houseListView];
        
    }
    
}

#pragma mark - 点击房源进入房源详情页
///点击房源
- (void)gotoRecommendHouseDetail:(id)dataModel
{
    
    ///根据不同的列表，进入同的详情页
    switch (self.houseType) {
            ///进入二手房详情
        case fFilterMainTypeSecondHouse:
        {
            
            ///获取房子模型
            QSHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:houseInfoModel.village_name andDetailID:houseInfoModel.id_ andDetailType:self.houseType];
            
            ///删除物业
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
            
                self.isNeedRefresh = YES;
            
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///进入出租房详情
        case fFilterMainTypeRentalHouse:
        {
            
            ///获取房子模型
            QSRentHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:houseInfoModel.village_name andDetailID:houseInfoModel.id_ andDetailType:self.houseType];
            
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
            
                self.isNeedRefresh = YES;
            
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 是否显示时刷新
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (self.isNeedRefresh) {
        
        self.isNeedRefresh = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.houseListView.header beginRefreshing];
            
        });
        
    }

}

@end
