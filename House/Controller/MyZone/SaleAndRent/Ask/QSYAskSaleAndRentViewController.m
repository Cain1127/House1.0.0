//
//  QSYAskSaleAndRentViewController.m
//  House
//
//  Created by ysmeng on 15/3/18.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskSaleAndRentViewController.h"
#import "QSYAskSecondHandHouseViewController.h"
#import "QSYAskRentHouseViewController.h"
#import "QSYAskRecommendRentHouseViewController.h"
#import "QSYAskRecommendSecondHouseViewController.h"

#import "QSYAskRentAndBuyTableViewCell.h"
#import "QSYAskRentAndBuyRentTableViewCell.h"

#import "QSYPopCustomView.h"
#import "QSCustomHUDView.h"
#import "QSYAskRentAndSecondHandHouseTipsPopView.h"
#import "QSYDeleteAskRentAndBuyHouseTipsPopView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "QSYAskRentAndBuyReturnData.h"
#import "QSYAskRentAndBuyDataModel.h"

#import "MJRefresh.h"

@interface QSYAskSaleAndRentViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *noRecordsRootView;                     //!<无记录底view
@property (nonatomic,strong) UIButton *addButton;                           //!<导航栏添加按钮
@property (nonatomic,strong) UIView *actionButtonRootView;                  //!<功能按钮的底view
@property (nonatomic,strong) UITableView *listView;                         //!<列表
@property (nonatomic,retain) QSYAskRentAndBuyReturnData *dataSourceModel;   //!<数据源
@property (nonatomic,assign) NSInteger releaseIndex;                        //!<当前展开的cell下标
@property (assign) BOOL isRefresh;                                          //!<神力显示时是否刷新数据

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
    
    self.addButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断当前是否可以发布求租求购
        if (5 <= ([self.dataSourceModel.headerData.rent_num intValue] +
            [self.dataSourceModel.headerData.purchase_num intValue])) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"最多只能发布5条求租求购信息", 1.5f, ^(){})
            return;
            
        }
        
        ///弹出求租求购咨询页面
        [self popAskRentAndSecondHandHouseView];
        
    }];
    self.addButton.hidden = YES;
    [self setNavigationBarRightView:self.addButton];

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
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    tipsLabel.numberOfLines = 2;
    [self.noRecordsRootView addSubview:tipsLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///求购按钮
    buttonStyle.title = @"求购";
    UIButton *askSaleButton = [UIButton createBlockButtonWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 15.0f, (SIZE_DEFAULT_MAX_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入求购过滤设置页面
        QSYAskSecondHandHouseViewController *filterVC = [[QSYAskSecondHandHouseViewController alloc] initWithModel:nil andReleaseStatus:bBuyhouseReleaseStatusTypeNew andCallBack:^(BOOL isRelease) {
            
            if (isRelease) {
                
                ///列表刷新
                self.isRefresh = YES;
                
            }
            
        }];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }];
    [self.noRecordsRootView addSubview:askSaleButton];
    
    ///求租按钮
    buttonStyle.title = @"求租";
    UIButton *askRentButton = [UIButton createBlockButtonWithFrame:CGRectMake(askSaleButton.frame.origin.x + askSaleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, askSaleButton.frame.origin.y, askSaleButton.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入求租过滤设置页面
        QSYAskRentHouseViewController *filterVC = [[QSYAskRentHouseViewController alloc] initWithModel:nil andReleaseStatus:rRenthouseReleaseStatusTypeNew andCallBack:^(BOOL isRelease) {
            
            if (isRelease) {
                
                ///列表刷新
                self.isRefresh = YES;
                
            }
            
        }];
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

#pragma mark - 返回求租求购记录
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __block QSYAskRentAndBuyDataModel *tempModel = self.dataSourceModel.headerData.dataList[indexPath.row];
    
    ///判断是否求租
    if ([tempModel.type intValue] == 1) {
        
        static NSString *normalCell = @"askRentHouseCell";
        QSYAskRentAndBuyRentTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
        if (nil == cellNormal) {
            
            cellNormal = [[QSYAskRentAndBuyRentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
            cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
            cellNormal.backgroundColor = [UIColor whiteColor];
            
        }
        
        ///刷新UI
        [cellNormal updateAskRentAndBuyInfoCellUI:tempModel andSettingButtonStatus:(indexPath.row == self.releaseIndex) andCallBack:^(ASK_RENTANDBUY_RENT_CELL_ACTION_TYPE actionType) {
            
            ///根据不同的事件，进入不同的页面
            if (aAskRentAndBuyRentCellActionTypeSetting == actionType) {
                
                self.releaseIndex = indexPath.row;
                [self.listView reloadData];
                
            }
            
            if (aAskRentAndBuyRentCellActionTypeSettingClose == actionType) {
                
                self.releaseIndex = -1;
                [self.listView reloadData];
                
            }
            
            if (aAskRentAndBuyRentCellActionTypeRecommend == actionType) {
                
                ///判断是否有推荐房源
                if (0 >= [tempModel.commend_num intValue]) {
                    
                    TIPS_ALERT_MESSAGE_ANDTURNBACK(@"暂无推荐房源", 1.5f, ^(){})
                    return;
                    
                }
                
                QSYAskRecommendRentHouseViewController *recommendVC = [[QSYAskRecommendRentHouseViewController alloc] initWithRecommendID:tempModel.id_];
                [self.navigationController pushViewController:recommendVC animated:YES];
                
            }
            
            if (aAskRentAndBuyRentCellActionTypeEdit == actionType) {
                
                QSYAskRentHouseViewController *rentEditVC = [[QSYAskRentHouseViewController alloc] initWithModel:[tempModel change_AskDataModel_TO_FilterModel] andReleaseStatus:rRenthouseReleaseStatusTypeRerelease andCallBack:^(BOOL isRelease) {
                    
                    if (isRelease) {
                        
                        ///列表刷新
                        self.isRefresh = YES;
                        
                    }
                    
                }];
                [self.navigationController pushViewController:rentEditVC animated:YES];
                
            }
            
            if (aAskRentAndBuyRentCellActionTypeDelete == actionType) {
                
                [self popAskRentAndBuyDeleteTips:tempModel.id_];
                
            }
            
        }];
        
        ///更新附加功能栏是否显示
        [cellNormal updateButtonActionStatus:(indexPath.row == self.releaseIndex)];
        
        return cellNormal;
        
    }

    static NSString *normalCell = @"askBuyHouseCell";
    QSYAskRentAndBuyTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[QSYAskRentAndBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        cellNormal.backgroundColor = [UIColor whiteColor];
        
    }
    
    ///刷新UI
    [cellNormal updateAskRentAndBuyInfoCellUI:tempModel andSettingButtonStatus:(indexPath.row == self.releaseIndex) andCallBack:^(ASK_RENTANDBUY_CELL_ACTION_TYPE actionType) {
        
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
            
            ///判断是否有推荐房源
            if (0 >= [tempModel.commend_num intValue]) {
                
                TIPS_ALERT_MESSAGE_ANDTURNBACK(@"暂无推荐房源", 1.5f, ^(){})
                return;
                
            }
            
            QSYAskRecommendSecondHouseViewController *recommendVC = [[QSYAskRecommendSecondHouseViewController alloc] initWithRecommendID:tempModel.id_];
            [self.navigationController pushViewController:recommendVC animated:YES];
            
        }
        
        if (aAskRentAndBuyCellActionTypeEdit == actionType) {
            
            QSYAskSecondHandHouseViewController *secondHouseEditVC = [[QSYAskSecondHandHouseViewController alloc] initWithModel:[tempModel change_AskDataModel_TO_FilterModel] andReleaseStatus:bBuyhouseReleaseStatusTypeRerelease andCallBack:^(BOOL isRelease) {
                
                if (isRelease) {
                    
                    ///列表刷新
                    self.isRefresh = YES;
                    
                }
                
            }];
            [self.navigationController pushViewController:secondHouseEditVC animated:YES];
            
        }
        
        if (aAskRentAndBuyCellActionTypeDelete == actionType) {
            
            [self popAskRentAndBuyDeleteTips:tempModel.id_];
            
        }
        
    }];
    
    ///更新附加功能栏是否显示
    [cellNormal updateButtonActionStatus:(indexPath.row == self.releaseIndex)];
    
    return cellNormal;

}

#pragma mark - 请求发布的求租求购信息
- (void)getAskRentAndBuyData
{
    
    ///封装参数
    NSDictionary *params = @{@"order" : @"update_time desc",
                             @"page_num" : @"10",
                             @"now_page" : @"1",
                             @"type" : @"0",
                             @"status" : @"1"};

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
                
                ///显示导航栏按钮
                self.addButton.hidden = NO;
                
                ///结束刷新
                [self.listView.header endRefreshing];
                
                ///隐藏无记录页面
                self.noRecordsRootView.hidden = YES;
                [self.view sendSubviewToBack:self.noRecordsRootView];
                
            } else {
            
                ///结束刷新
                [self.listView.header endRefreshing];
                
                ///隐藏导航栏按钮
                self.addButton.hidden = YES;
                
                ///显示无记录页面
                self.noRecordsRootView.hidden = NO;
                [self.view bringSubviewToFront:self.noRecordsRootView];
            
            }
            
        } else {
            
            ///结束刷新
            [self.listView.header endRefreshing];
            
            ///隐藏导航栏按钮
            self.addButton.hidden = NO;
        
            ///显示无记录页面
            self.noRecordsRootView.hidden = NO;
            [self.view bringSubviewToFront:self.noRecordsRootView];
        
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
            
            ///进入求租过滤设置页面
            QSYAskRentHouseViewController *filterVC = [[QSYAskRentHouseViewController alloc] initWithModel:nil andReleaseStatus:rRenthouseReleaseStatusTypeNew andCallBack:^(BOOL isRelease) {
                
                if (isRelease) {
                    
                    ///列表刷新
                    self.isRefresh = YES;
                    
                }
                
            }];
            [self.navigationController pushViewController:filterVC animated:YES];
            
        }
        
        ///求购
        if (aAskRentAndSecondHouseTipsActionTypeBuy == actionType) {
            
            ///进入求购过滤设置页面
            QSYAskSecondHandHouseViewController *filterVC = [[QSYAskSecondHandHouseViewController alloc] initWithModel:nil andReleaseStatus:bBuyhouseReleaseStatusTypeNew andCallBack:^(BOOL isRelease) {
                
                if (isRelease) {
                    
                    ///列表刷新
                    self.isRefresh = YES;
                    
                }
                
            }];
            [self.navigationController pushViewController:filterVC animated:YES];
            
        }
        
    }];
    
    ///弹出窗口
    popView = [QSYPopCustomView popCustomView:saleTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];

}

#pragma mark - 弹出求租求购记录删除
- (void)popAskRentAndBuyDeleteTips:(NSString *)dataID
{

    ///弹出窗口的指针
    __block QSYPopCustomView *popView = nil;
    
    ///提示选择窗口
    QSYDeleteAskRentAndBuyHouseTipsPopView *saleTipsView = [[QSYDeleteAskRentAndBuyHouseTipsPopView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 109.0f) andCallBack:^(DELETE_ASK_RENTANDBUYHOUSE_TIPS_ACTION_TYPE actionType) {
        
        ///隐藏弹窗
        [popView hiddenCustomPopview];
        
        if (dDeleteAskRentAndBuyHouseTipsActionTypeConfirm == actionType) {
            
            ///显示HUD
            __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在删除"];
            
            ///封装参数
            NSDictionary *params = @{@"id_" : dataID};
            
            [QSRequestManager requestDataWithType:rRequestTypeMyZoneDeleteAskRentPurpase andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
                
                ///删除成功
                if (rRequestResultTypeSuccess == resultStatus) {
                    
                    [hud hiddenCustomHUDWithFooterTips:@"删除成功" andDelayTime:1.0f andCallBack:^(BOOL flag) {
                        
                        ///刷新数据
                        [self.listView.header beginRefreshing];
                        
                    }];
                    
                } else {
                
                    NSString *tipsString = @"删除失败";
                    if (resultData) {
                        
                        tipsString = [resultData valueForKey:@"info"];
                        
                    }
                    [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.0f];
                
                }
                
            }];
            
        }
        
    }];
    
    ///弹出窗口
    popView = [QSYPopCustomView popCustomView:saleTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];

}

#pragma mark - 实图出现时判断是否需要刷新数据
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (self.isRefresh) {
        
        self.isRefresh = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.listView.header beginRefreshing];
            
        });
        
    }

}

@end
