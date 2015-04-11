//
//  QSCoreDataManager+Message.h
//  House
//
//  Created by ysmeng on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"

@interface QSCoreDataManager (Message)

/**
 *  @author             yangshengmeng, 15-04-10 15:04:55
 *
 *  @brief              查询指定用户的历史消息
 *
 *  @param personID     指定用户ID
 *  @param timeStamp    开始的时间戳
 *
 *  @return             返回查询结果
 *
 *  @since              1.0.0
 */
+ (NSArray *)getPersonLocalMessage:(NSString *)personID andStarTimeStamp:(NSString *)timeStamp;

/**
 *  @author             yangshengmeng, 15-04-10 14:04:02
 *
 *  @brief              将消息保存到本地
 *
 *  @param messageModel 消息的数据模型
 *  @param msgType      消息类型
 *
 *  @since              1.0.0
 */
+ (void)saveMessageData:(id)messageModel andMessageType:(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE)msgType andCallBack:(void(^)(BOOL isSave))callBack;

@end
