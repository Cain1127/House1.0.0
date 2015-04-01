//
//  QSYPostMessageSimpleModel.h
//  House
//
//  Created by ysmeng on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSUserSimpleDataModel;
@interface QSYPostMessageSimpleModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;       //!<消息ID
@property (nonatomic,copy) NSString *from_id;   //!<发送者的ID
@property (nonatomic,copy) NSString *to_id;     //!<消息接收者的ID
@property (nonatomic,copy) NSString *not_view;  //!<未读取消息数量
@property (nonatomic,copy) NSString *content;   //!<最新的消息文字
@property (nonatomic,copy) NSString *time;      //!<最后消息的时间戳

@property (nonatomic,retain) QSUserSimpleDataModel *fromUserInfo;//!<消息发送者的基本信息

@end
