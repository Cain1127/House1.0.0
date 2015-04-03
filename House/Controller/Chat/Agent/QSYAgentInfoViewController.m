//
//  QSYAgentInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAgentInfoViewController.h"

#import "QSYAskRentAndBuyTableViewCell.h"
#import "QSYContactInfoView.h"

#import "QSYContactDetailReturnData.h"
#import "QSYContactDetailInfoModel.h"

#import "MJRefresh.h"

@interface QSYAgentInfoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *agentName;             //!<经纪人名
@property (nonatomic,copy) NSString *agentID;               //!<经纪ID
@property (nonatomic,strong) UITableView *userInfoRootView; //!<用户消息列表
@property (nonatomic,assign) NSInteger releaseIndex;        //!<当前展开的cell下标
@property (nonatomic,retain) NSMutableArray *askDataSource; //!<求租求购的记录
@property (nonatomic,retain) QSYContactDetailReturnData *contactInfo;

@end

@implementation QSYAgentInfoViewController

#pragma mark - 初始化
- (instancetype)initWithName:(NSString *)agentName andAgentID:(NSString *)agentID
{

    if (self = [super init]) {
        
        ///保存信息
        self.agentID = agentID;
        self.agentName = agentName;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.agentName];
    
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

#pragma mark - 列表数据设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2 + [self.askDataSource count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (0 == indexPath.row) {
        
        return 160.0f;
        
    }
    
    if (1 == indexPath.row) {
        
        return 44.0f;
        
    }
    
    if (indexPath.row != self.releaseIndex) {
        
        return 332.0f;
        
    }
    
    return 332.0f + 44.0f;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///用户基本信息栏
    if (0 == indexPath.row) {
        
        static NSString *userInfoCell = @"userInfoCell";
        UITableViewCell *cellUserInfo = [tableView dequeueReusableCellWithIdentifier:userInfoCell];
        if (nil == cellUserInfo) {
            
            cellUserInfo = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoCell];
            cellUserInfo.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        ///头view
        QSYContactInfoView *infoRootView = (QSYContactInfoView *)[cellUserInfo.contentView viewWithTag:5555];
        if (nil == infoRootView) {
            
            infoRootView = [[QSYContactInfoView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 80.0f)];
            infoRootView.backgroundColor = [UIColor whiteColor];
            [cellUserInfo.contentView addSubview:infoRootView];
            
        }
        
        ///刷新数据
        [infoRootView updateContactInfoUI:self.contactInfo.contactInfo];
        
        return cellUserInfo;
        
    }
    
    ///用户回复率信息栏
    if (1 == indexPath.row) {
        
        static NSString *addInfoCell = @"addInfoCell";
        
    }
    
    ///求租求购列表
    static NSString *normalCell = @"normalCell";
    QSYAskRentAndBuyTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[QSYAskRentAndBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    ///刷新UI
    [cellNormal updateAskRentAndBuyInfoCellUI:self.askDataSource[indexPath.row] andSettingButtonStatus:(indexPath.row == self.releaseIndex) andCallBack:^(ASK_RENTANDBUY_CELL_ACTION_TYPE actionType) {
        
        ///根据不同的事件，进入不同的页面
        if (aAskRentAndBuyCellActionTypeSetting == actionType) {
            
            self.releaseIndex = indexPath.row;
            [tableView reloadData];
            
        }
        
        if (aAskRentAndBuyCellActionTypeSettingClose == actionType) {
            
            self.releaseIndex = -1;
            [tableView reloadData];
            
        }
        
        if (aAskRentAndBuyCellActionTypeRecommend == actionType) {
            
            
            
        }
        
        if (aAskRentAndBuyCellActionTypeEdit == actionType) {
            
            
            
        }
        
        if (aAskRentAndBuyCellActionTypeDelete == actionType) {
            
            
            
        }
        
    }];
    
    return cellNormal;

}

#pragma mark - 获取用户详情信息
- (void)getUserDetailInfo
{

    

}

@end
