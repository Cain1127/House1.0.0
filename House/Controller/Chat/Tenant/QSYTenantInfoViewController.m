//
//  QSYTenantInfoViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYTenantInfoViewController.h"

#import "MJRefresh.h"

@interface QSYTenantInfoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *tenantName;             //!<经纪人名
@property (nonatomic,copy) NSString *tenantID;               //!<经纪ID
@property (nonatomic,strong) UITableView *userInfoRootView; //!<用户消息列表
@property (nonatomic,assign) NSInteger releaseIndex;        //!<当前展开的cell下标

@end

@implementation QSYTenantInfoViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-03 16:04:30
 *
 *  @brief              创建普通房客的信息页
 *
 *  @param tenantName   房客名
 *  @param tenantID     房客的ID
 *
 *  @return             返回当前房客的信息页
 *
 *  @since              1.0.0
 */
- (instancetype)initWithName:(NSString *)agentName andAgentID:(NSString *)agentID
{
    
    if (self = [super init]) {
        
        ///保存信息
        self.tenantID = agentID;
        self.tenantName = agentName;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.tenantName];
    
}

- (void)createMainShowUI
{
    
    ///初始化时，展开的cell下标
    self.releaseIndex = -1;
    
    ///列表
    self.userInfoRootView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    self.userInfoRootView.showsHorizontalScrollIndicator = NO;
    self.userInfoRootView.showsVerticalScrollIndicator = NO;
    self.userInfoRootView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///数据源和代理
    self.userInfoRootView.dataSource = self;
    self.userInfoRootView.delegate = self;
    
    [self.view addSubview:self.userInfoRootView];
    
    ///头部刷新
    [self.userInfoRootView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getUserDetailInfo)];
    
    ///开始就头部刷新
    [self.userInfoRootView.header beginRefreshing];
    
}

#pragma mark - 获取用户详情信息
- (void)getUserDetailInfo
{
    
    
    
}

@end
