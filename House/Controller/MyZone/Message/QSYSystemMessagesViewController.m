//
//  QSYSystemMessagesViewController.m
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSystemMessagesViewController.h"
#import "QSYSystemMessageDetailViewController.h"
#import "QSYSystemAdvertViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSNewHouseDetailViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSPOrderDetailBookedViewController.h"

#import "QSChatMessageListTableViewCell.h"

#import "QSYSystemMessageReturnData.h"
#import "QSYSystemMessageListDataModel.h"

#import "MJRefresh.h"

@interface QSYSystemMessagesViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *messageListView;          //!<消息列表
@property (nonatomic,retain) QSYSystemMessageReturnData *returnData;//!<服务端返回数据
@property (assign) BOOL isNeedRefresh;                              //!<出现时是否刷新

@end

@implementation QSYSystemMessagesViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"我的消息"];
    
}

- (void)createMainShowUI
{

    self.messageListView = [[UITableView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + 10.0f, SIZE_DEFAULT_MAX_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 10.0f) style:UITableViewStylePlain];
    self.messageListView.showsHorizontalScrollIndicator = NO;
    self.messageListView.showsVerticalScrollIndicator = NO;
    self.messageListView.dataSource = self;
    self.messageListView.delegate = self;
    self.messageListView.backgroundColor = [UIColor clearColor];
    self.messageListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.messageListView];
    
    [self.messageListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(requestSystemMessageData)];
    [self.messageListView.header beginRefreshing];

}

#pragma mark - 消息列表配置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0f;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.returnData.headerData.dataList count];

}

#pragma mark - 返回消息cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///复用标签
    static NSString *systemMessageCellName = @"systemCell";
    
    ///从复用队列中获取cell
    QSChatMessageListTableViewCell *cellSystem = [tableView dequeueReusableCellWithIdentifier:systemMessageCellName];
    
    ///判断是否需要重新创建
    if (nil == cellSystem) {
        
        cellSystem = [[QSChatMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemMessageCellName andCellType:mMessageListCellTypeSystemInfo];
        
        ///取消选择状态
        cellSystem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    ///刷新系统消息
    QSYSystemMessageListDataModel *tempModel = self.returnData.headerData.dataList[indexPath.row];
    [cellSystem updateSystemMessageTipsCellUI:[tempModel changeToSimpleSystemMessageModel]];
    
    return cellSystem;

}

#pragma mark - 进入消息详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (nil == self.returnData ||
        [self.returnData.headerData.dataList count] <= 0) {
        
        return;
        
    }
    
    QSYSystemMessageListDataModel *tempModel = self.returnData.headerData.dataList[indexPath.row];
    
    ///获取类型
    NSString *messageType = tempModel.expand.source_type;
    
    /**
     *  NOTE    :   系统通知
     *  ORDER   :   订单通知
     *  AD      :   广告
     *  SH      :   推荐二手房
     *  NH      :   推送新房
     *  RH      :   推送出租房
     */

    ///普通消息
    if ([messageType length] <= 0 || [messageType isEqualToString:@"NOTE"]) {
        
        QSYSystemMessageDetailViewController *detailVC = [[QSYSystemMessageDetailViewController alloc] init];
        detailVC.detailModel = tempModel;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
    ///进入订单详情
    if ([messageType isEqualToString:@"ORDER"]) {
        
        QSPOrderDetailBookedViewController *orderDetailPage = [[QSPOrderDetailBookedViewController alloc] init];
        orderDetailPage.orderID = tempModel.expand.message_id;
        [orderDetailPage setOrderType:mOrderWithUserTypeAppointment];
        [self.navigationController pushViewController:orderDetailPage animated:YES];
        
    }
    
    ///广告
    if ([messageType isEqualToString:@"AD"]) {
        
        QSYSystemAdvertViewController *advertVC = [[QSYSystemAdvertViewController alloc] init];
        advertVC.advertURLString = tempModel.expand.expand_2;
        advertVC.advertTitle = tempModel.title;
        [self.navigationController pushViewController:advertVC animated:YES];
        
    }
    
    ///二手房
    if ([messageType isEqualToString:@"SH"]) {
        
        QSSecondHouseDetailViewController *secondHandHouseDetailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:tempModel.expand.expand_1 andDetailID:tempModel.expand.expand_2];
        [self.navigationController pushViewController:secondHandHouseDetailVC animated:YES];
        
    }
    
    ///新房
    if ([messageType isEqualToString:@"NH"]) {
        
        NSString *newHouseInfo = tempModel.expand.expand_2;
        NSArray *infoArray = [newHouseInfo componentsSeparatedByString:@"#"];
        
        if ([infoArray count] != 2) {
            
            return;
            
        }
        
        QSNewHouseDetailViewController *newHouseDetailVC = [[QSNewHouseDetailViewController alloc] initWithTitle:tempModel.expand.expand_1 andLoupanID:infoArray[0] andLoupanBuildingID:infoArray[1] andDetailType:fFilterMainTypeNewHouse];
        [self.navigationController pushViewController:newHouseDetailVC animated:YES];
        
    }
    
    ///出租房
    if ([messageType isEqualToString:@"RH"]) {
        
        QSRentHouseDetailViewController *rentHouseDetailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:tempModel.expand.expand_1 andDetailID:tempModel.expand.expand_2];
        [self.navigationController pushViewController:rentHouseDetailVC animated:YES];
        
    }

}

#pragma mark - 请求系统消息数据
- (void)requestSystemMessageData
{
    
    [self showNoRecordTips:NO andTips:@"暂无系统消息"];
    
    ///封装参数
    NSDictionary *prarams = @{@"key" : @"",
                              @"page_num" : @"15",
                              @"now_page" : @"1"};

    [QSRequestManager requestDataWithType:rRequestTypeSystemMessageList andParams:prarams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        self.returnData = nil;
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYSystemMessageReturnData *tempModel = resultData;
            
            if ([tempModel.headerData.dataList count] > 0) {
                
                [self showNoRecordTips:NO andTips:@"暂无系统消息"];
                
                self.returnData = tempModel;
                [self.messageListView reloadData];
                [self.messageListView.header endRefreshing];
                
            } else {
            
                ///停止刷新
                [self.messageListView reloadData];
                
                [self showNoRecordTips:YES andTips:@"暂无系统消息"];
                [self.messageListView.header endRefreshing];
            
            }
            
            
        } else {
            
            ///停止刷新
            [self.messageListView reloadData];
            
            [self showNoRecordTips:YES andTips:@"暂无系统消息"];
            [self.messageListView.header endRefreshing];
        
        }
        
    }];

}

@end
