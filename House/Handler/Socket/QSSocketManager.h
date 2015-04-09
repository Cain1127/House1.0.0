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
@interface QSSocketManager : NSObject

/**
 *  @author yangshengmeng, 15-03-31 23:03:31
 *
 *  @brief  发送上线消息
 *
 *  @since  1.0.0
 */
+ (void)sendOnLineMessage;

/**
 *  @author         yangshengmeng, 15-03-17 19:03:05
 *
 *  @brief          一对一聊天时，发送消息
 *
 *  @param msgModel 消息数据模型
 *
 *  @since          1.0.0
 */
+ (void)sendMessageToPerson:(id)msgModel andMessageType:(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE)messageType andCallBack:(void(^)(BOOL flag,id model))callBack;

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
+ (void)sendMessageToGroup:(id)msgModel andGroupID:(NSString *)groupID andCallBack:(void(^)(BOOL flag,id model))callBack;

/**
 *  @author yangshengmeng, 15-04-01 12:04:28
 *
 *  @brief  注销当前聊天的即里回调
 *
 *  @since  1.0.0
 */
+ (void)offsCurrentTalkCallBack;

/**
 *  @author yangshengmeng, 15-04-02 13:04:23
 *
 *  @brief  注册当前所有未读消息的回调通知
 *
 *  @since  1.0.0
 */
+ (void)registCurrentUnReadMessageCountNotification:(void(^)(int msgNum))callBack;
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
+ (void)registInstantMessageReceiveNotification:(void(^)(int msgNum,NSString *lastComment,QSYSendMessageBaseModel *lastMessage,QSUserSimpleDataModel *userInfo))callBack;
+ (void)offsInstantMessageReceiveNotification;

@end
