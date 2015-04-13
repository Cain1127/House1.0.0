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

#import "QSYAskRentAndBuyTableViewCell.h"
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
        
        QSYContactSettingViewController *contactSettingVC = [[QSYContactSettingViewController alloc] initWithContactID:self.tenantID isFriends:([self.contactInfo.contactInfo.id_ intValue] > 0) isImport:self.contactInfo.contactInfo.is_import];
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
        
        ///打电话
        [self callContact];
        
    }];
    [self.view addSubview:callButton];
    
}

#pragma mark - 列表数据设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int statusNum = 3;
    if (1 == [self.contactInfo.contactInfo.is_order intValue]) {
        
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
    
    if (2 == indexPath.row && (1 == [self.contactInfo.contactInfo.is_order intValue])) {
        
        return 44.0f;
        
    }
    
    if (2 == indexPath.row && !(1 == [self.contactInfo.contactInfo.is_order intValue])) {
        
        return 44.0f;
        
    }
    
    if (3 == indexPath.row && [self.orderInfo.id_ length] > 0) {
        
        return 105.0f;
        
    }
    
    if (4 == indexPath.row && (1 == [self.contactInfo.contactInfo.is_order intValue])) {
        
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
    if (2 == indexPath.row && ([self.contactInfo.contactInfo.is_order intValue] == 1)) {
        
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
            tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
            tipsLabel.tag = 5557;
            [cellHaveOrder.contentView addSubview:tipsLabel];
            
        }
        
        ///指示三角
        QSImageView *arrowImageView = (QSImageView *)[cellHaveOrder.contentView viewWithTag:5558];
        if (nil == arrowImageView) {
            
            arrowImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 13.0f, (44.0f - 23.0f) / 2.0f, 13.0f, 23.0f)];
            arrowImageView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            arrowImageView.tag = 5558;
            [cellHaveOrder.contentView addSubview:arrowImageView];
            
        }
        
        return cellHaveOrder;
        
    }
    
    if (2 == indexPath.row && !([self.contactInfo.contactInfo.is_order intValue] == 1)) {
        
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
    
    if (4 == indexPath.row && [self.contactInfo.contactInfo.is_order intValue] == 1) {
        
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
    
    ///求租求购列表
    static NSString *normalCell = @"normalCell";
    QSYAskRentAndBuyTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[QSYAskRentAndBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    ///刷新UI
    [cellNormal updateAskRentAndBuyInfoCellUI:self.askDataSource[indexPath.row - self.askDataStarStep] andSettingButtonStatus:(indexPath.row == self.releaseIndex) andCallBack:^(ASK_RENTANDBUY_CELL_ACTION_TYPE actionType) {
        
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

#pragma mark - 点击cell上的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.row) {
        
        return;
        
    }
    
    if (1 == indexPath.row) {
        
        return;
        
    }
    
    if (2 == indexPath.row && (1 == [self.contactInfo.contactInfo.is_order intValue])) {
        
        return;
        
    }
    
    if (2 == indexPath.row && !(1 == [self.contactInfo.contactInfo.is_order intValue])) {
        
        return;
        
    }
    
    if (3 == indexPath.row && [self.orderInfo.id_ length] > 0) {
        
        QSPOrderDetailBookedViewController *orderDetailVC = [[QSPOrderDetailBookedViewController alloc] init];
        orderDetailVC.orderID = self.orderInfo.id_;
        [orderDetailVC setOrderType:mOrderWithUserTypeAppointment];
        [self.navigationController pushViewController:orderDetailVC animated:YES];
        return;
        
    }
    
    if (4 == indexPath.row && (1 == [self.contactInfo.contactInfo.is_order intValue])) {
        
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
            if (1 == [tempModel.contactInfo.is_order intValue]) {
                
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
