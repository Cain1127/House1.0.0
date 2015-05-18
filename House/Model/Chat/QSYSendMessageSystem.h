//
//  QSYSendMessageSystem.h
//  House
//
//  Created by ysmeng on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSYSendMessageSystem : NSObject

/*
 *  required string title = 1;
 *  required string desc  = 2;
 *  required string time  = 3;
 *  required string mid   = 4;
 *  required string type  = 5;
 *  required string url   = 6;
 */

@property (nonatomic,copy) NSString *fromID;                                //!<消息发出者的ID
@property (nonatomic,copy) NSString *readTag;                               //!<是否已读：1-已读
@property (nonatomic,copy) NSString *timeStamp;                             //!<时间戳
@property (nonatomic,copy) NSString *title;                                 //!<标题
@property (nonatomic,copy) NSString *desc;                                  //!<信息内容
@property (nonatomic,copy) NSString *f_name;                                //!<保存的是系统消息跳转url
@property (nonatomic,copy) NSString *f_avatar;                              //!<保存的是系统消息类型
@property (nonatomic,copy) NSString *unread_count;                          //!<未读消息的数量
@property (nonatomic,assign) QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE msgType;   //!<消息类型

@property (nonatomic,copy) NSString *exp_1;
@property (nonatomic,copy) NSString *exp_2;
@property (nonatomic,copy) NSString *exp_3;
@property (nonatomic,copy) NSString *exp_4;
@property (nonatomic,copy) NSString *exp_5;

@end
