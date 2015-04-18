//
//  QSSocketManager.h
//  House
//
//  Created by ysmeng on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QSUserSimpleDataModel;
@class QSYSendMessageBaseModel;

///回调block的重定义名

///未读消息列表监听：方便列出最新的消息提醒
typedef void(^INSTANT_MESSAGE_NOTIFICATION)(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE msgType,int msgNum,NSString *lastComment,id lastMessage,QSUserSimpleDataModel *userInfo);

///当前聊天窗口的监听：打开指定用户的聊天窗口时，此回调类型生效
typedef void(^CURRENT_TALK_MESSAGE_NOTIFICATION)(BOOL flag,id messageModel);

///指定消息类型的最新数量监听：一般用来监听系统消息
typedef void(^APPOINT_MESSAGE_LASTCOUNT_NOTIFICATION)(int msgNum);

@interface QSSocketManager : NSObject

///socket单例管理器
+ (QSSocketManager *)shareSocketManager;

/**
 *  @author         yangshengmeng, 15-04-10 13:04:29
 *
 *  @brief          获取指定人员的当前内存离线消息
 *
 *  @param personID 用户ID
 *
 *  @return         返回指定用户未读消息
 *
 *  @since          1.0.0
 */
+ (NSArray *)getSpecialPersonMessage:(NSString *)personID;

/**
 *  @author             yangshengmeng, 15-04-10 13:04:30
 *
 *  @brief              获取用户，保存在数据库中的历史消息
 *
 *  @param personID     指定用户的ID
 *  @param timeStamp    当前最旧消息的时间戳
 *
 *  @return             返回最多十条历史消息，如果没有更多，则返回0条的空数组
 *
 *  @since              1.0.0
 */
+ (NSArray *)getSpecialPersonLocalMessage:(NSString *)personID andStarTimeStamp:(NSString *)timeStamp;

/**
 *  @author yangshengmeng, 15-03-31 23:03:31
 *
 *  @brief  发送上线消息
 *
 *  @since  1.0.0
 */
+ (void)sendOnLineMessage;

/**
 *  @author yangshengmeng, 15-04-18 09:04:56
 *
 *  @brief  发送下线消息
 *
 *  @since  1.0.0
 */
+ (void)sendOffLineMessage;

/**
 *  @author         yangshengmeng, 15-03-17 19:03:05
 *
 *  @brief          一对一聊天时，发送消息
 *
 *  @param msgModel 消息数据模型
 *
 *  @since          1.0.0
 */
+ (void)sendMessageToPerson:(id)msgModel andMessageType:(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE)messageType;

/**
 *  @author         yangshengmeng, 15-03-17 19:03:27
 *
 *  @brief          群发消息
 *
 *  @param msgModel 消息数据模型
 *  @param groupID  群ID
 *
 *  @since          1.0.0
 */
+ (void)sendMessageToGroup:(id)msgModel andGroupID:(NSString *)groupID;

/**
 *  @author yangshengmeng, 15-04-01 12:04:28
 *
 *  @brief  注销当前聊天的即里回调
 *
 *  @since  1.0.0
 */
+ (void)registCurrentTalkMessageNotificationWithUserID:(NSString *)userID andCallBack:(CURRENT_TALK_MESSAGE_NOTIFICATION)callBack;
+ (void)offsCurrentTalkCallBack;

/**
 *  @author yangshengmeng, 15-04-02 13:04:23
 *
 *  @brief  注册当前所有未读消息的回调通知
 *
 *  @since  1.0.0
 */
+ (void)registCurrentUnReadMessageCountNotification:(APPOINT_MESSAGE_LASTCOUNT_NOTIFICATION)callBack;
+ (void)offsCurrentUnReadMessageCountNotification;

/**
 *  @author         yangshengmeng, 15-04-02 14:04:13
 *
 *  @brief          注册当前有消息进入时的回调，返回当前消息的发送人，及发送人的未读消息数量
 *
 *  @param callBack 当有新的消息来时，回调
 *
 *  @since          1.0.0
 */
+ (void)registInstantMessageReceiveNotification:(INSTANT_MESSAGE_NOTIFICATION)callBack;
+ (void)offsInstantMessageReceiveNotification;

/**
 *  @author         yangshengmeng, 15-04-11 10:04:06
 *
 *  @brief          注册系统消息监听，当有系统消息到来时，回调当前最新系统消息及总消息数量
 *
 *  @param callBack 监听的回调
 *
 *  @since          1.0.0
 */
+ (void)registSystemMessageReceiveNotification:(APPOINT_MESSAGE_LASTCOUNT_NOTIFICATION)callBack;
+ (void)offsSystemMessageReceiveNotification;

@end
