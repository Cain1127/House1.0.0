//
//  QSChatMessagesView.m
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSChatMessagesView.h"
#import "QSChatMessageListTableViewCell.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char MessageListKey;//!<消息列表关联

@interface QSChatMessagesView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) USER_COUNT_TYPE userType;                  //!<用户类型

@property (nonatomic,assign) int systemInfoNumber;                      //!<系统消息项
@property (nonatomic,retain) NSMutableArray *contactMessagesDataSource; //!消息数据源

@end

@implementation QSChatMessagesView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-02-09 11:02:57
 *
 *  @brief          创建一个当前用户类型的消息列表
 *
 *  @param frame    大小和位置
 *  @param userType 用户类型
 *
 *  @return         返回当前创建的消息列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType
{

    if (self = [super initWithFrame:frame]) {
        
        ///初始化系统消息数据
        [self initSystemInfoDataSource];
        
        ///初始化联系人发过来的消息
        self.contactMessagesDataSource = [[NSMutableArray alloc] init];
        
        ///UI搭建
        [self createInfoListUI];
        
    }
    
    return self;

}

#pragma mark - 根据不同的用户类型初始化系统消息项
///根据不同的用户类型初始化系统消息项
- (void)initSystemInfoDataSource
{

    if (uUserCountTypeAgency == self.userType) {
        
        self.systemInfoNumber = 1;
        return;
        
    }
    
    self.systemInfoNumber = 2;

}

#pragma mark - UI搭建
/**
 *  @author yangshengmeng, 15-02-09 13:02:18
 *
 *  @brief  UI搭建
 *
 *  @since  1.0.0
 */
- (void)createInfoListUI
{
    
    ///间隙
    CGFloat gap = SIZE_DEVICE_WIDTH > 320.0f ? 25.0f : 15.0f;

    ///消息列表
    UITableView *messageList = [[UITableView alloc] initWithFrame:CGRectMake(gap, 0.0f, self.frame.size.width - 2.0f * gap, self.frame.size.height)];
    
    ///取消滚动条
    messageList.showsHorizontalScrollIndicator = NO;
    messageList.showsVerticalScrollIndicator = NO;
    
    ///数据源
    messageList.dataSource = self;
    messageList.delegate = self;
    
    ///取消选择状态
    messageList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:messageList];
    objc_setAssociatedObject(self, &MessageListKey, messageList, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加刷新事件
    [messageList addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getMessageListHeaderData)];
    [messageList addLegendFooterWithRefreshingTarget:self  refreshingAction:@selector(getMessageListFooterData)];
    
    ///一开始就请求数据
    [messageList.header beginRefreshing];

}

#pragma mark - 数据请求
///数据请求
- (void)getMessageListHeaderData
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self endRefreshAnimination];
        
    });

}

- (void)getMessageListFooterData
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self endRefreshAnimination];
        
    });
    
}

#pragma mark - 结束刷新动画
///结束刷新动画
- (void)endRefreshAnimination
{

    UITableView *tableView = objc_getAssociatedObject(self, &MessageListKey);
    [tableView.header endRefreshing];
    [tableView.footer endRefreshing];

}

#pragma mark - 刷新数据
///刷新数据
- (void)reloadData
{

    UITableView *tableView = objc_getAssociatedObject(self, &MessageListKey);
    [tableView reloadData];

}

#pragma mark - 返回每一个消息cell内容项
///返回每一个消息cell内容项
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///系统消息放在第一栏
    if (0 == indexPath.row) {
        
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
        
        return cellSystem;
        
    }
    
    ///判断第二栏是否是推送房源
    if ((self.systemInfoNumber == 2) && (1 == indexPath.row)) {
        
        ///复用标签
        static NSString *recommendMessageCellName = @"recommendCell";
        
        ///从复用队列中获取cell
        QSChatMessageListTableViewCell *cellRecommend = [tableView dequeueReusableCellWithIdentifier:recommendMessageCellName];
        
        ///判断是否需要重新创建
        if (nil == cellRecommend) {
            
            cellRecommend = [[QSChatMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recommendMessageCellName andCellType:mMessageListCellTypeHouseRecommend];
            
            ///取消选择状态
            cellRecommend.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        return cellRecommend;
        
    }
    
    ///其他消息cell复用标签
    static NSString *normalCellName = @"normalCell";
    
    ///从复用队列中获取cell
    QSChatMessageListTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCellName];
    
    ///判断是否需要重新创建
    if (nil == cellNormal) {
        
        cellNormal = [[QSChatMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellName andCellType:mMessageListCellTypeNormal];
        
        ///取消选择状态
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cellNormal;

}

#pragma mark - 返回一共有多少条消息
///返回一共有多少条消息
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.systemInfoNumber + [self.contactMessagesDataSource count];

}

#pragma mark - 返回每一条消息显示cell的高度
///返回每一条消息显示cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0f;

}

@end
