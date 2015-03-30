//
//  QSYComparisonViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYComparisonViewController.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "MJRefresh.h"

@interface QSYComparisonViewController ()

@property (nonatomic,retain) NSArray *houseList;        //!<比一比的原始数据
@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;//!<房源类型
@property (nonatomic,strong) QSScrollView *infoRootView;//!<信息底view

@end

@implementation QSYComparisonViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建比一比列表
 *
 *  @return         返回当前创建的比一比页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedHouseList:(NSArray *)houseList andHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存参数
        self.houseList = [NSArray arrayWithArray:houseList];
        self.houseType = houseType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"房源对比"];
    
    ///收藏按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeAdd];
    
    UIButton *addCollectedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断是否存在数据
        
    }];
    [self setNavigationBarRightView:addCollectedButton];
    
}

- (void)createMainShowUI
{

    self.infoRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    [self.view addSubview:self.infoRootView];
    
    ///添加头部刷新
    [self.infoRootView addHeaderWithTarget:self action:@selector(getComparisionData)];
    
    ///一开始就请求数据
    [self.infoRootView headerBeginRefreshing];

}

#pragma mark - 创建比一比UI

#pragma mark - 请求比一比的结果数据
- (void)getComparisionData
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.infoRootView headerEndRefreshing];
        
    });

}

@end
