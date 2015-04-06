//
//  QSYSendMessageBaseModel.h
//  House
//
//  Created by ysmeng on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSYSendMessageBaseModel : NSObject

@property (nonatomic,copy) NSString *fromID;                               //!<消息发出者的ID
@property (nonatomic,copy) NSString *toID;                                 //!<消息接收者的ID
@property (nonatomic,assign) QSCUSTOM_PROTOCOL_CHAT_SEND_TYPE sendType;    //!<消息发送的类型：群聊-单聊
@property (nonatomic,assign) QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE msgType;  //!<消息类型

@end
