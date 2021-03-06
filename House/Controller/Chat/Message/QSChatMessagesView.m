//
//  QSChatMessagesView.m
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSChatMessagesView.h"

#import "QSChatMessageListTableViewCell.h"

#import "QSCoreDataManager+User.h"
#import "QSSocketManager.h"
#import "QSRequestManager.h"

#import "QSYPostMessageListReturnData.h"
#import "QSYPostMessageSimpleModel.h"
#import "QSYSendMessageWord.h"
#import "QSYSendMessagePicture.h"
#import "QSYSendMessageVideo.h"
#import "QSYSendMessageSystem.h"
#import "QSYSendMessageSpecial.h"
#import "QSUserSimpleDataModel.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char MessageListKey;//!<消息列表关联

@interface QSChatMessagesView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) USER_COUNT_TYPE userType;                      //!<用户类型

///消息列表的回调
@property (nonatomic,copy) void(^messageListCallBack)(MESSAGE_LIST_ACTION_TYPE actionType,id params);

@property (nonatomic,assign) int systemInfoNumber;                          //!<系统消息项
@property (nonatomic,retain) NSMutableArray *messageList;                   //!消息数据源
@property (nonatomic,retain) QSYSendMessageSystem *systemMessage;           //!<系统消息
@property (nonatomic,retain) QSYSendMessageSpecial *recommendHouseMessage;  //!<推荐房源消息

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
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType andCallBack:(void(^)(MESSAGE_LIST_ACTION_TYPE actionType,id params))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///初始化系统消息数据
        [self initSystemInfoDataSource];
        
        ///保存回调
        if (callBack) {
            
            self.messageListCallBack = callBack;
            
        }
        
        ///消息数组源
        self.messageList = [[NSMutableArray alloc] init];
        
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
    __block UITableView *messageList = [[UITableView alloc] initWithFrame:CGRectMake(gap, 0.0f, self.frame.size.width - 2.0f * gap, self.frame.size.height)];
    
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
    
    ///一开始就请求数据
    [messageList.header beginRefreshing];
    
    ///注册新消息通知
    [QSSocketManager registInstantMessageReceiveNotification:^(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE msgType,int msgNum,NSString *lastComment,id tempModel,QSUserSimpleDataModel *userInfo) {
        
        switch (msgType) {
                ///图片消息
            case qQSCustomProtocolChatMessageTypePicture:
                
                ///语音消息
            case qQSCustomProtocolChatMessageTypeVideo:
                
                ///文本消息
            case qQSCustomProtocolChatMessageTypeWord:
            {
            
                ///添加消息
                QSYSendMessageBaseModel *lastMessage = tempModel;
                int currentIndex = [self checkMessage:lastMessage.fromID];
                if (0 <= currentIndex && currentIndex < [self.messageList count]) {
                    
                    QSYPostMessageSimpleModel *newInfoModel = self.messageList[currentIndex];
                    newInfoModel.id_ = lastMessage.msgID;
                    newInfoModel.from_id = lastMessage.fromID;
                    newInfoModel.to_id = lastMessage.toID;
                    newInfoModel.not_view = [NSString stringWithFormat:@"%d",msgNum];
                    newInfoModel.content = APPLICATION_NSSTRING_SETTING(lastComment, @"");
                    newInfoModel.time = lastMessage.timeStamp;
                    newInfoModel.fromUserInfo = userInfo;
                    
                } else {
                    
                    QSYPostMessageSimpleModel *newInfoModel = [[QSYPostMessageSimpleModel alloc] init];
                    newInfoModel.id_ = lastMessage.msgID;
                    newInfoModel.from_id = lastMessage.fromID;
                    newInfoModel.to_id = lastMessage.toID;
                    newInfoModel.not_view = [NSString stringWithFormat:@"%d",msgNum];
                    newInfoModel.content = APPLICATION_NSSTRING_SETTING(lastComment, @"");
                    newInfoModel.time = lastMessage.timeStamp;
                    newInfoModel.fromUserInfo = userInfo;
                    [self.messageList addObject:newInfoModel];
                    currentIndex = 0;
                    
                }
            
            }
                break;
                
                ///系统消息
            case qQSCustomProtocolChatMessageTypeSystem:
            {
            
                QSYSendMessageSystem *systemModel = tempModel;
                systemModel.unread_count = [NSString stringWithFormat:@"%d",msgNum];
                self.systemMessage = systemModel;
            
            }
                break;
                
                ///推荐房源
            case qQSCustomProtocolChatMessageTypeSpecial:
            {
            
                QSYSendMessageSpecial *recommendModel = tempModel;
                self.recommendHouseMessage = recommendModel;
            
            }
                break;
                
            default:
                break;
        }
        
        ///刷新数据
        [messageList reloadData];
        
    }];

}

#pragma mark - 判断原消息记录中是否已存在消息
- (int)checkMessage:(NSString *)userID
{

    for (int i = 0;i < [self.messageList count];i++) {
        
        QSYPostMessageSimpleModel *obj = self.messageList[i];
        if ([userID isEqualToString:obj.from_id]) {
            
            return i;
            
        }
        
    }
    
    return -1;

}

#pragma mark - 进入消息列
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    int messageCount = (int)[self.messageList count];
    if (indexPath.row < messageCount) {
        
        ///进入指定联系人的聊天窗口
        if (self.messageListCallBack) {
            
            QSYPostMessageSimpleModel *tempModel = self.messageList[indexPath.row];
            
            ///删除列表中的记录
            tempModel.not_view = @"0";
            
            ///刷新列表
            [tableView reloadData];
            
            self.messageListCallBack(mMessageListActionTypeGotoTalk,tempModel);
            
        }
        
    }
    
    if (indexPath.row == messageCount) {
        
        ///进入房当前团队消息列表
        if (self.messageListCallBack) {
            
            ///更新系统消息的数据
            self.systemMessage.unread_count = @"0";
            [tableView reloadData];
            self.messageListCallBack(mMessageListActionTypeGotoSystemMessage,nil);
            
        }
        
    }
    
    if (indexPath.row == messageCount + 1) {
        
        ///进入推荐房源列表
        if (self.messageListCallBack) {
            
            self.recommendHouseMessage.unread_count = @"0";
            [tableView reloadData];
            self.messageListCallBack(mMessageListActionTypeGotoRecommendHouse,nil);
            
        }
        
    }

}

#pragma mark - 数据请求
///数据请求
- (void)getMessageListHeaderData
{

    ///判断登录状态
    if (![QSCoreDataManager isLogin]) {
        
        [self endRefreshAnimination];
        return;
        
    }
    
    ///参数封装
    NSDictionary *params = @{@"order" : @"",
                             @"page_num" : @"9999",
                             @"now_page" : @"1"};
    
    ///请求离线消息
    [QSRequestManager requestDataWithType:rRequestTypeChatMessageList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///获取成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///清空信息
            [self.messageList removeAllObjects];
            QSYPostMessageListReturnData *tempModel = resultData;
            
            if ([tempModel.headerData.messageList count] > 0) {
        
                [self.messageList addObjectsFromArray:tempModel.headerData.messageList];
                
            }
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ///刷新数据
            [self reloadData];
            
            ///结束刷新
            [self endRefreshAnimination];
            
        });
        
    }];

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
    
    if (indexPath.row < [self.messageList count]) {
        
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
        
        ///刷新数据
        if ([self.messageList count] > indexPath.row) {
            
            [cellNormal updateNormalMessageTipsCellUI:self.messageList[indexPath.row]];
            
        }
        
        return cellNormal;
        
    }

    ///系统消息放在第一栏
    if ([self.messageList count] == indexPath.row) {
        
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
        [cellSystem updateSystemMessageTipsCellUI:self.systemMessage];
        
        return cellSystem;
        
    }
    
    ///判断第二栏是否是推送房源
    if ((self.systemInfoNumber == 2) && ([self.messageList count] + 1 == indexPath.row)) {
        
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
        
        ///刷新推荐房源消息
        [cellRecommend updateRecommendMessageTipsCellUI:self.recommendHouseMessage];
        
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

    return self.systemInfoNumber + [self.messageList count];

}

#pragma mark - 返回每一条消息显示cell的高度
///返回每一条消息显示cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0f;

}

@end
