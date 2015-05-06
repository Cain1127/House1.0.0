//
//  QSYTenantInfoViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYTenantInfoViewController.h"
#import "QSPOrderDetailBookedViewController.h"
#import "QSYTalkPTPViewController.h"
#import "QSYContactSettingViewController.h"
#import "QSYTenantDetailRecommendRentHouseViewController.h"
#import "QSYTenantDetailRecommendAparmentHouseViewController.h"

#import "QSYTenantAskRentAndBuyRentTableViewCell.h"
#import "QSYTenantAskRentAndBuyBuyTableViewCell.h"
#import "QSYContactInfoView.h"
#import "QSYContactOrderInfoView.h"
#import "QSYContactAppointmentCreditInfoView.h"
#import "QSYPopCustomView.h"
#import "QSYCallTipsPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSYAskRentAndBuyReturnData.h"
#import "QSYContactDetailReturnData.h"
#import "QSYContactDetailInfoModel.h"
#import "QSYAskListOrderInfosModel.h"
#import "QSYAskRentAndBuyDataModel.h"

#import "QSCoreDataManager+User.h"

#import "MJRefresh.h"

@interface QSYTenantInfoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *tenantName;                        //!<经纪人名
@property (nonatomic,copy) NSString *tenantID;                          //!<经纪ID
@property (nonatomic,strong) UITableView *userInfoRootView;             //!<用户消息列表
@property (nonatomic,assign) NSInteger releaseIndex;                    //!<当前展开的cell下标
@property (nonatomic,retain) NSMutableArray *askDataSource;             //!<求租求购的记录
@property (nonatomic,assign) int askDataStarStep;                       //!<求租求租下标减掉的数量
@property (nonatomic,retain) QSYContactDetailReturnData *contactInfo;   //!<联系人信息
@property (nonatomic,retain) QSYAskListOrderInfosModel *orderInfo;      //!<订单信息

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
        
        ///初始化数据源
        self.askDataSource = [[NSMutableArray alloc] init];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.tenantName];
    
    ///说明
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeUserDetail];
    
    UIButton *detailButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        QSYContactSettingViewController *contactSettingVC = [[QSYContactSettingViewController alloc] initWithContactID:self.tenantID andContactName:self.tenantName isFriends:self.contactInfo.contactInfo.id_ isImport:self.contactInfo.contactInfo.is_import andCallBack:^(CONTACT_SETTING_CALLBACK_ACTION_TYPE actionType, id params) {
            
            switch (actionType) {
                    ///添加成为联系人
                case cContactSettingCallBackActionTypeAddContact:
                {
                    
                    self.contactInfo.contactInfo.id_ = params;
                    [self.userInfoRootView reloadData];
                    
                    ///回调通知联系人改变
                    if (self.contactInfoChangeCallBack) {
                        
                        self.contactInfoChangeCallBack(YES);
                        
                    }
                    
                }
                    break;
                    
                    ///删除联系人
                case cContactSettingCallBackActionTypeDeleteContact:
                {
                    
                    self.contactInfo.contactInfo.id_ = @"0";
                    [self.userInfoRootView reloadData];
                    
                    ///回调通知联系人改变
                    if (self.contactInfoChangeCallBack) {
                        
                        self.contactInfoChangeCallBack(YES);
                        
                    }
                    
                }
                    break;
                    
                    ///设置为重点联系人
                case cContactSettingCallBackActionTypeSetImport:
                {
                    
                    self.contactInfo.contactInfo.is_import = @"1";
                    
                    ///回调通知联系人改变
                    if (self.contactInfoChangeCallBack) {
                        
                        self.contactInfoChangeCallBack(YES);
                        
                    }
                    
                }
                    break;
                    
                    ///设置为普通联系人
                case cContactSettingCallBackActionTypeSetUNImport:
                {
                    
                    self.contactInfo.contactInfo.is_import = @"0";
                    
                    ///回调通知联系人改变
                    if (self.contactInfoChangeCallBack) {
                        
                        self.contactInfoChangeCallBack(YES);
                        
                    }
                    
                }
                    break;
                    
                    ///备注联系人
                case cContactSettingCallBackActionTypeRemarkContact:
                {
                    
                    self.contactInfo.contactInfo.remark = APPLICATION_NSSTRING_SETTING_NIL(params);
                    [self.userInfoRootView reloadData];
                    
                    ///回调通知联系人改变
                    if (self.contactInfoChangeCallBack) {
                        
                        self.contactInfoChangeCallBack(YES);
                        
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        [self.navigationController pushViewController:contactSettingVC animated:YES];
        
    }];
    [self setNavigationBarRightView:detailButton];
    
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
    
    ///判断是否是中介
    if (uUserCountTypeAgency == [QSCoreDataManager getUserType]) {
        
        return;
        
    }
    
    ///非中介时，添加功能按钮
    self.userInfoRootView.frame = CGRectMake(self.userInfoRootView.frame.origin.x, self.userInfoRootView.frame.origin.y, self.userInfoRootView.frame.size.width, self.userInfoRootView.frame.size.height - 44.0f - 16.0f);
    
    ///按钮风格
    CGFloat widthButton = (SIZE_DEVICE_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///发送消息
    buttonStyle.title = @"发送消息";
    UIButton *sendMessageButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 8.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入聊天页
        QSYTalkPTPViewController *talkVC = [[QSYTalkPTPViewController alloc] initWithUserModel:[self.contactInfo.contactInfo contactDetailChangeToSimpleUserModel]];
        [self.navigationController pushViewController:talkVC animated:YES];
        
    }];
    [self.view addSubview:sendMessageButton];
    
    ///打电话
    buttonStyle.title = @"打电话";
    UIButton *callButton = [UIButton createBlockButtonWithFrame:CGRectMake(sendMessageButton.frame.origin.x + sendMessageButton.frame.size.width + 8.0f,sendMessageButton.frame.origin.y, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if ([self.contactInfo.contactInfo.is_order isEqualToString:@"true"]) {
            
            ///打电话
            [self callContact];
            
        } else {
        
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"当前用户并未预约您，暂时无法查看联系电话", 1.0f, ^(){})
        
        }
        
    }];
    [self.view addSubview:callButton];
    
}

#pragma mark - 列表数据设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int statusNum = 3;
    if ([self.contactInfo.contactInfo.is_order isEqualToString:@"true"]) {
        
        statusNum = 5;
        
    }
    return statusNum + [self.askDataSource count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.row) {
        
        return 80.0f;
        
    }
    
    if (1 == indexPath.row) {
        
        return 80.0f;
        
    }
    
    if (2 == indexPath.row && ([self.contactInfo.contactInfo.is_order isEqualToString:@"true"])) {
        
        return 44.0f;
        
    }
    
    if (2 == indexPath.row && !([self.contactInfo.contactInfo.is_order isEqualToString:@"true"])) {
        
        return 44.0f;
        
    }
    
    if (3 == indexPath.row && [self.orderInfo.id_ length] > 0) {
        
        return 105.0f;
        
    }
    
    if (4 == indexPath.row && ([self.contactInfo.contactInfo.is_order isEqualToString:@"true"])) {
        
        return 44.0f;
        
    }
    
    if (indexPath.row != self.releaseIndex) {
        
        return 332.0f;
        
    }
    
    return 332.0f;
    
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
            infoRootView.tag = 5555;
            [cellUserInfo.contentView addSubview:infoRootView];
            
        }
        
        ///刷新数据
        [infoRootView updateContactInfoUI:self.contactInfo.contactInfo];
        
        return cellUserInfo;
        
    }
    
    ///用户回复率信息栏
    if (1 == indexPath.row) {
        
        static NSString *appointCreditCell = @"addInfoCell";
        UITableViewCell *cellAppointCreditInfo = [tableView dequeueReusableCellWithIdentifier:appointCreditCell];
        if (nil == cellAppointCreditInfo) {
            
            cellAppointCreditInfo = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appointCreditCell];
            cellAppointCreditInfo.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        ///头view
        QSYContactAppointmentCreditInfoView *infoRootView = (QSYContactAppointmentCreditInfoView *)[cellAppointCreditInfo.contentView viewWithTag:5556];
        if (nil == infoRootView) {
            
            infoRootView = [[QSYContactAppointmentCreditInfoView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 80.0f) andHouseType:uUserCountTypeTenant];
            infoRootView.backgroundColor = [UIColor whiteColor];
            infoRootView.tag = 5556;
            [cellAppointCreditInfo.contentView addSubview:infoRootView];
            
        }
        
        ///刷新数据
        [infoRootView updateContactInfoUI:self.contactInfo.contactInfo];
        
        return cellAppointCreditInfo;
        
    }
    
    ///判断是否有订单
    if (2 == indexPath.row && ([self.contactInfo.contactInfo.is_order isEqualToString:@"true"])) {
        
        static NSString *isOrderCell = @"isOrderCell";
        UITableViewCell *cellHaveOrder = [tableView dequeueReusableCellWithIdentifier:isOrderCell];
        if (nil == cellHaveOrder) {
            
            cellHaveOrder = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:isOrderCell];
            cellHaveOrder.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        ///是订单提示信息
        UILabel *tipsLabel = (UILabel *)[cellHaveOrder.contentView viewWithTag:5557];
        if (nil == tipsLabel) {
            
            tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 7.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f)];
            tipsLabel.text = @"预约我的历史";
            tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
            tipsLabel.tag = 5557;
            [cellHaveOrder.contentView addSubview:tipsLabel];
            
        }
        
        ///分隔线
        UILabel *tipsSepLabel = (UILabel *)[cellHaveOrder.contentView viewWithTag:5558];
        if (nil == tipsSepLabel) {
            
            tipsSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f - 0.25f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f)];
            tipsSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
            tipsSepLabel.tag = 5558;
            [cellHaveOrder.contentView addSubview:tipsSepLabel];
            
        }
        
        return cellHaveOrder;
        
    }
    
    if (2 == indexPath.row && !([self.contactInfo.contactInfo.is_order isEqualToString:@"true"])) {
        
        static NSString *titleCell = @"titleCell";
        UITableViewCell *cellTitle = [tableView dequeueReusableCellWithIdentifier:titleCell];
        if (nil == cellTitle) {
            
            cellTitle = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
            cellTitle.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        ///标题
        UILabel *titleLabel = (UILabel *)[cellTitle.contentView viewWithTag:5559];
        if (nil == titleLabel) {
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 7.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f)];
            titleLabel.text = @"求租求购信息";
            titleLabel.tag = 5559;
            titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
            [cellTitle.contentView addSubview:titleLabel];
            
        }
        
        return cellTitle;
        
    }
    
    if (3 == indexPath.row && [self.orderInfo.id_ length] > 0) {
        
        static NSString *orderInfoCell = @"orderInfoCell";
        UITableViewCell *cellOrderInfo = [tableView dequeueReusableCellWithIdentifier:orderInfoCell];
        if (nil == cellOrderInfo) {
            
            cellOrderInfo = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderInfoCell];
            cellOrderInfo.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        QSYContactOrderInfoView *orderInfoView = (QSYContactOrderInfoView *)[cellOrderInfo.contentView viewWithTag:5560];
        if (nil == orderInfoView) {
            
            orderInfoView = [[QSYContactOrderInfoView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 105.0f)];
            orderInfoView.tag = 5560;
            [cellOrderInfo.contentView addSubview:orderInfoView];
            
        }
        
        [orderInfoView updateContactOrderInfo:self.orderInfo];
        
        return cellOrderInfo;
        
    }
    
    if (4 == indexPath.row && [self.contactInfo.contactInfo.is_order isEqualToString:@"true"]) {
        
        static NSString *titleCell = @"titleCell";
        UITableViewCell *cellTitle = [tableView dequeueReusableCellWithIdentifier:titleCell];
        if (nil == cellTitle) {
            
            cellTitle = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
            cellTitle.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        ///标题
        UILabel *titleLabel = (UILabel *)[cellTitle.contentView viewWithTag:5559];
        if (nil == titleLabel) {
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 7.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f)];
            titleLabel.text = @"求租求购信息";
            titleLabel.tag = 5559;
            titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
            [cellTitle.contentView addSubview:titleLabel];
            
        }
        
        return cellTitle;
        
    }
    
    __block QSYAskRentAndBuyDataModel *tempModel = self.askDataSource[indexPath.row - self.askDataStarStep];
    
    ///判断是否求租
    if ([tempModel.type intValue] == 1) {
        
        static NSString *normalCell = @"askRentHouseCell";
        QSYTenantAskRentAndBuyRentTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
        if (nil == cellNormal) {
            
            cellNormal = [[QSYTenantAskRentAndBuyRentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
            cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
            cellNormal.backgroundColor = [UIColor whiteColor];
            
        }
        
        ///刷新UI
        [cellNormal updateTenantAskRentAndBuyInfoCellUI:tempModel andCallBack:^(TENANT_ASK_RENTANDBUY_RENT_CELL_ACTION_TYPE actionType) {
            
            switch (actionType) {
                    ///推荐房源
                case tTenantAskRentAndBuyRentCellActionTypeRecommendHouse:
                {
                    
                    ///判断是否存在出租物业
                    if (0 >= [QSCoreDataManager getUserRentPropertySumCount]) {
                        
                        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"您当前暂无出租物业", 1.5f, ^(){})
                        return;
                        
                    }
                
                    QSYTenantDetailRecommendRentHouseViewController *pickedHouseVC = [[QSYTenantDetailRecommendRentHouseViewController alloc] initWithCallBack:^(BOOL isPicked, QSBaseModel *houseModel, NSString *commend) {
                        
                    }];
                    [self.navigationController pushViewController:pickedHouseVC animated:YES];
                
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        return cellNormal;
        
    }
    
    ///求租求购列表
    static NSString *normalCell = @"askBuyHouseCell";
    QSYTenantAskRentAndBuyBuyTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[QSYTenantAskRentAndBuyBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    ///刷新UI
    [cellNormal updateTenantAskRentAndBuyInfoCellUI:tempModel andCallBack:^(TENANT_ASK_RENTANDBUY_BUY_CELL_ACTION_TYPE actionType) {
        
        switch (actionType) {
                ///推荐房源
            case tTenantAskRentAndBuyBuyCellActionTypeRecommendHouse:
            {
                
                ///判断是否存在出租物业
                if (0 >= [QSCoreDataManager getUserSalePropertySumCount]) {
                    
                    TIPS_ALERT_MESSAGE_ANDTURNBACK(@"您当前暂无出售物业", 1.5f, ^(){})
                    return;
                    
                }
                
                QSYTenantDetailRecommendAparmentHouseViewController *pickedHouseVC = [[QSYTenantDetailRecommendAparmentHouseViewController alloc] initWithCallBack:^(BOOL isPicked, QSBaseModel *houseModel, NSString *commend) {
                    
                }];
                [self.navigationController pushViewController:pickedHouseVC animated:YES];
                
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    return cellNormal;
    
}

#pragma mark - 点击cell上的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (3 == indexPath.row && [self.orderInfo.id_ length] > 0) {
        
        QSPOrderDetailBookedViewController *orderDetailVC = [[QSPOrderDetailBookedViewController alloc] init];
        orderDetailVC.orderID = self.orderInfo.id_;
        [orderDetailVC setOrderType:mOrderWithUserTypeAppointment];
        [self.navigationController pushViewController:orderDetailVC animated:YES];
        return;
        
    }
    
}

#pragma mark - 获取用户详情信息
- (void)getUserDetailInfo
{
    
    ///参数
    NSDictionary *userInfoParams = @{@"linkman_id" : self.tenantID};
    
    ///先请求联系人信息
    [QSRequestManager requestDataWithType:rRequestTypeChatContactInfo andParams:userInfoParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///获取成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSYContactDetailReturnData *tempModel = resultData;
            self.contactInfo = tempModel;
            
            ///保存列表的起始下标
            if ([tempModel.contactInfo.is_order isEqualToString:@"true"]) {
                
                self.askDataStarStep = 5;
                
            } else {
            
                self.askDataStarStep = 3;
            
            }
            
            ///开始请求求租求购信息
            [self getAskListDataWithLinkManInfo:self.contactInfo.contactInfo.linkman_id];
            
        } else {
            
            [self.userInfoRootView.header endRefreshing];
            
            NSString *tipsString = @"获取联系人信息失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(tipsString, 1.0f, ^(){
                
                [self.navigationController popViewControllerAnimated:YES];
                
            })
            
        }
        
    }];
    
}

- (void)getAskListDataWithLinkManInfo:(NSString *)linkManID
{
    
    NSDictionary *params = @{@"order" : @"update_time desc",
                             @"page_num" : @"10",
                             @"now_page" : @"1",
                             @"type" : @"0",
                             @"be_found_id" : linkManID,
                             @"status" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeMyZoneAskRentPurphaseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSYAskRentAndBuyReturnData *tempModel = resultData;
            
            ///清空原数据
            [self.askDataSource removeAllObjects];
            self.orderInfo = nil;
            
            ///判断是否有数据
            if ([tempModel.headerData.dataList count] > 0) {
                
                [self.askDataSource addObjectsFromArray:tempModel.headerData.dataList];
                
            }
            
            if ([tempModel.headerData.orderList count] > 0) {
                
                self.orderInfo = tempModel.headerData.orderList[0];
                
            }
            
            ///刷新数据
            [self.userInfoRootView reloadData];
            
            ///结束刷新
            [self.userInfoRootView.header endRefreshing];
            
        } else {
            
            [self.userInfoRootView.header endRefreshing];
            NSString *tipsString = @"下载联系人信息失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(tipsString, 1.0f, ^(){})
            
        }
        
    }];
    
}

#pragma mark - 联系业主事件
- (void)callContact
{
    
    ///弹出框
    __block QSYPopCustomView *popView;
    
    QSYCallTipsPopView *callTipsView = [[QSYCallTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 130.0f, SIZE_DEVICE_WIDTH, 130.0f) andName:self.contactInfo.contactInfo.username andPhone:self.contactInfo.contactInfo.mobile andCallBack:^(CALL_TIPS_CALLBACK_ACTION_TYPE actionType) {
        
        ///回收弹框
        [popView hiddenCustomPopview];
        
        ///确认打电话
        if (cCallTipsCallBackActionTypeConfirm == actionType) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.contactInfo.contactInfo.mobile]]];
            
        }
        
    }];
    
    popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:callTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
        
    }];
    
}

@end
