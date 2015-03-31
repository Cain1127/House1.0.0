//
//  QSYAskSaleAndRentViewController.m
//  House
//
//  Created by ysmeng on 15/3/18.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskSaleAndRentViewController.h"
#import "QSFilterViewController.h"

#import "QSYAskRentAndBuyTableViewCell.h"

#import "QSYPopCustomView.h"
#import "QSYAskRentAndSecondHandHouseTipsPopView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "QSYAskRentAndBuyReturnData.h"

#import "MJRefresh.h"

@interface QSYAskSaleAndRentViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *noRecordsRootView;                     //!<无记录底view
@property (nonatomic,strong) UIView *actionButtonRootView;                  //!<功能按钮的底view
@property (nonatomic,strong) UITableView *listView;                         //!<列表
@property (nonatomic,retain) QSYAskRentAndBuyReturnData *dataSourceModel;   //!<数据源
@property (nonatomic,assign) NSInteger releaseIndex;                        //!<当前展开的cell下标

@end

@implementation QSYAskSaleAndRentViewController

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"求租求购"];
    
    ///添加按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeAdd];
    
    UIButton *addButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///弹出求租求购咨询页面
        [self popAskRentAndSecondHandHouseView];
        
    }];
    [self setNavigationBarRightView:addButton];

}

- (void)createMainShowUI
{
    
    ///创建无记录view
    [self createNoRecordsUI];
    
    ///初始化时，展开的cell下标
    self.releaseIndex = -1;

    ///列表
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    self.listView.showsHorizontalScrollIndicator = NO;
    self.listView.showsVerticalScrollIndicator = NO;
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///数据源和代理
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.listView];
    
    ///头部刷新
    [self.listView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getAskRentAndBuyData)];
    [self.listView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreRentAndBuyData)];
    
    ///开始就头部刷新
    [self.listView.header beginRefreshing];

}

- (void)createNoRecordsUI
{
    
    self.noRecordsRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    self.noRecordsRootView.hidden = YES;
    [self.view addSubview:self.noRecordsRootView];

    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, self.noRecordsRootView.frame.size.height / 2.0f - 60.0f, SIZE_DEVICE_WIDTH - 60.0f, 60.0f)];
    tipsLabel.text = @"暂无求租求购记录\n马上发布吧！";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    tipsLabel.numberOfLines = 2;
    [self.noRecordsRootView addSubview:tipsLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///求购按钮
    buttonStyle.title = @"求购";
    UIButton *askSaleButton = [UIButton createBlockButtonWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 15.0f, (SIZE_DEFAULT_MAX_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入求购过滤设置页面
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeMyZoneAskSecondHouse];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }];
    [self.noRecordsRootView addSubview:askSaleButton];
    
    ///求租按钮
    buttonStyle.title = @"求租";
    UIButton *askRentButton = [UIButton createBlockButtonWithFrame:CGRectMake(askSaleButton.frame.origin.x + askSaleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, askSaleButton.frame.origin.y, askSaleButton.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入求租过滤设置页面
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeMyZoneAskRentHouse];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }];
    [self.noRecordsRootView addSubview:askRentButton];

}

#pragma mark - 记录数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.dataSourceModel.headerData.dataList count];

}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row != self.releaseIndex) {
        
        return 332.0f;
        
    }
    
    return 332.0f + 44.0f;

}

#pragma mark - 返回收藏记录
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *normalCell = @"normalCell";
    QSYAskRentAndBuyTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[QSYAskRentAndBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    ///刷新UI
    [cellNormal updateAskRentAndBuyInfoCellUI:self.dataSourceModel.headerData.dataList[indexPath.row] andSettingButtonStatus:(indexPath.row == self.releaseIndex) andCallBack:^(ASK_RENTANDBUY_CELL_ACTION_TYPE actionType) {
        
        ///根据不同的事件，进入不同的页面
        if (aAskRentAndBuyCellActionTypeSetting == actionType) {
            
            self.releaseIndex = indexPath.row;
            [self.listView reloadData];
            
        }
        
        if (aAskRentAndBuyCellActionTypeSettingClose == actionType) {
            
            self.releaseIndex = -1;
            [self.listView reloadData];
            
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

#pragma mark - 请求发布的求租求购信息
- (void)getAskRentAndBuyData
{
    
    ///封装参数
    NSDictionary *params = @{@"order" : @"update_time desc",
                             @"page_num" : @"10",
                             @"now_page" : @"1",
                             @"type" : @"0"};

    [QSRequestManager requestDataWithType:rRequestTypeMyZoneAskRentPurphaseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSYAskRentAndBuyReturnData *tempModel = resultData;
            
            ///重置指针
            self.dataSourceModel = nil;
            
            ///判断是否有数据
            if ([tempModel.headerData.dataList count] > 0) {
                
                self.dataSourceModel = tempModel;
                
                ///刷新数据
                [self.listView reloadData];
                
                ///结束刷新
                [self.listView.header endRefreshing];
                
                ///隐藏无记录页面
                self.noRecordsRootView.hidden = YES;
                
            } else {
            
                ///结束刷新
                [self.listView.header endRefreshing];
                
                ///显示无记录页面
                self.noRecordsRootView.hidden = NO;
            
            }
            
        } else {
            
            ///结束刷新
            [self.listView.header endRefreshing];
        
            ///显示无记录页面
            self.noRecordsRootView.hidden = NO;
        
        }
        
    }];

}

- (void)getMoreRentAndBuyData
{

    ///封装参数
    int currentPage = [self.dataSourceModel.headerData.per_page intValue];
    int nextPage = [self.dataSourceModel.headerData.next_page intValue];
    
    if (currentPage == nextPage) {
        
        [self.listView.header endRefreshing];
        [self.listView.footer endRefreshing];
        return;
        
    }
    
    ///显示脚
    self.listView.footer.stateHidden = NO;
    
    NSDictionary *params = @{@"order" : @"update_time desc",
                             @"page_num" : @"10",
                             @"now_page" : self.dataSourceModel.headerData.next_page,
                             @"type" : @"0"};
    
    [QSRequestManager requestDataWithType:rRequestTypeMyZoneAskRentPurphaseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSYAskRentAndBuyReturnData *tempModel = resultData;
            
            ///原数据指针
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataSourceModel.headerData.dataList];
            
            ///判断是否有数据
            if ([tempModel.headerData.dataList count] > 0) {
                
                self.dataSourceModel = tempModel;
                [tempArray addObjectsFromArray:tempModel.headerData.dataList];
                self.dataSourceModel.headerData.dataList = tempArray;
                
                ///刷新数据
                [self.listView reloadData];
                
                ///结束刷新
                [self.listView.header endRefreshing];
                [self.listView.footer endRefreshing];
                
            } else {
                
                ///结束刷新
                [self.listView.header endRefreshing];
                [self.listView.footer endRefreshing];
                
                ///显示无记录页面
                self.noRecordsRootView.hidden = YES;
                
            }
            
        } else {
            
            ///结束刷新
            [self.listView.header endRefreshing];
            [self.listView.footer endRefreshing];
            
            ///显示无记录页面
            self.noRecordsRootView.hidden = YES;
            
        }
        
    }];

}

#pragma mark - 弹出求租求购咨询页
- (void)popAskRentAndSecondHandHouseView
{
    
    ///弹出窗口的指针
    __block QSYPopCustomView *popView = nil;
    
    ///提示选择窗口
    QSYAskRentAndSecondHandHouseTipsPopView *saleTipsView = [[QSYAskRentAndSecondHandHouseTipsPopView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 109.0f) andCallBack:^(ASK_RENTANDSECONDHOUSE_TIPS_ACTION_TYPE actionType) {
        
        ///隐藏弹窗
        [popView hiddenCustomPopview];
        
        ///求租
        if (aAskRentAndSecondHouseTipsActionTypeRent == actionType) {
            
            QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeMyZoneAskRentHouse];
            [self.navigationController pushViewController:filterVC animated:YES];
            
        }
        
        ///求购
        if (aAskRentAndSecondHouseTipsActionTypeBuy == actionType) {
            
            QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeMyZoneAskSecondHouse];
            [self.navigationController pushViewController:filterVC animated:YES];
            
        }
        
    }];
    
    ///弹出窗口
    popView = [QSYPopCustomView popCustomView:saleTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];

}

@end
