//
//  QSYSystemMessageListDataModel.h
//  House
//
//  Created by ysmeng on 15/5/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSYSendMessageSystem;
@class QSYSystemMessageListDataExtand;
@interface QSYSystemMessageListDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;           //!<消息本身的ID
@property (nonatomic,copy) NSString *user_id;       //!<消息发送者的用户ID
@property (nonatomic,copy) NSString *to_user;       //!<消息接收者的用户ID
@property (nonatomic,copy) NSString *to_address;    //!<
@property (nonatomic,copy) NSString *content;       //!<消息内容
@property (nonatomic,copy) NSString *title;         //!<消息标题
@property (nonatomic,copy) NSString *send_time;     //!<发送时间
@property (nonatomic,copy) NSString *over_time;     //!<接收时间
@property (nonatomic,copy) NSString *result;        //!<
@property (nonatomic,copy) NSString *accpet;        //!<
@property (nonatomic,copy) NSString *status;        //!<
@property (nonatomic,copy) NSString *send_type;     //!<
@property (nonatomic,copy) NSString *notice_type;   //!<
@property (nonatomic,copy) NSString *log;           //!<
@property (nonatomic,copy) NSString *sign;          //!<

///扩展消息
@property (nonatomic,retain) QSYSystemMessageListDataExtand *expand;

///将系统消息模型转为普通的系统消息模型
- (QSYSendMessageSystem *)changeToSimpleSystemMessageModel;

@end

@interface QSYSystemMessageListDataExtand : QSBaseModel

/**
 *  ORDER   :   订单
 *  MSG     :   消息
 *  SYSTEM  :   系统
 */
@property (nonatomic,copy) NSString *source_type;   //!<消息类型

@property (nonatomic,copy) NSString *message_id;    //!<消息ID
@property (nonatomic,copy) NSString *source_user_id;//!<消息发出者的ID:-1表示系统消息
@property (nonatomic,copy) NSString *expand_1;
@property (nonatomic,copy) NSString *expand_2;

/**
 *  NOTE    :   系统通知
 *  ORDER   :   订音通知
 *  AD      :   广告
 *  SH      :   推荐二手房
 *  NH      :   推送新房
 *  RH      :   推送出租房
 */
@property (nonatomic,copy) NSString *message_type;

@end