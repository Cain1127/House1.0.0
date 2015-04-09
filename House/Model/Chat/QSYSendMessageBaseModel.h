//
//  QSYSendMessageBaseModel.h
//  House
//
//  Created by ysmeng on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSYSendMessageBaseModel : NSObject

@property (nonatomic,copy) NSString *deviceUUID;                            //!<设备的UUID

@property (nonatomic,copy) NSString *msgID;                                 //!<消息自身的ID
@property (nonatomic,copy) NSString *fromID;                                //!<消息发出者的ID
@property (nonatomic,copy) NSString *toID;                                  //!<消息接收者的ID

@property (nonatomic,assign) CGFloat showWidth;                             //!<显示的宽度
@property (nonatomic,assign) CGFloat showHeight;                            //!<显示的高度

@property (nonatomic,copy) NSString *timeStamp;                             //!<时间戳

@property (nonatomic,copy) NSString *f_name;                                //!<消息发送者的名字
@property (nonatomic,copy) NSString *f_user_type;                           //!<消息发送者的账号类型
@property (nonatomic,copy) NSString *f_leve;                                //!<消息发送者的VIP水平
@property (nonatomic,copy) NSString *f_avatar;                              //!<消息发送者的头像地址

@property (nonatomic,copy) NSString *t_name;                                //!<消息接收者的名字
@property (nonatomic,copy) NSString *t_user_type;                           //!<消息接收者的账号类型
@property (nonatomic,copy) NSString *t_leve;                                //!<消息接收者的VIP水平
@property (nonatomic,copy) NSString *t_avatar;                              //!<消息接收者的头像地址

@property (nonatomic,copy) NSString *unread_count;                          //!<未读消息的数量

@property (nonatomic,assign) QSCUSTOM_PROTOCOL_CHAT_SEND_TYPE sendType;     //!<消息发送的类型：群聊-单聊
@property (nonatomic,assign) QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE msgType;   //!<消息类型

@end
