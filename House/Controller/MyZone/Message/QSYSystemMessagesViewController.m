//
//  QSYSystemMessagesViewController.m
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSystemMessagesViewController.h"

#import "QSChatMessageListTableViewCell.h"

#import "QSYSystemMessageReturnData.h"

#import "MJRefresh.h"

@interface QSYSystemMessagesViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *messageListView;          //!<消息列表
@property (nonatomic,retain) QSYSystemMessageReturnData *returnData;//!<服务端返回数据

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
    [cellSystem updateSystemMessageTipsCellUI:nil];
    
    return cellSystem;

}

#pragma mark - 请求系统消息数据
- (void)requestSystemMessageData
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self showNoRecordTips:YES andTips:@"暂无系统消息"];
        [self.messageListView.header endRefreshing];
        
    });

}

@end
