//
//  QSYSendMessageRootModel.h
//  House
//
//  Created by ysmeng on 15/5/18.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSYSendMessageRootModel : NSObject

@property (nonatomic,copy) NSString *readTag;                               //!<是否已读：1-已读
@property (nonatomic,assign) QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE msgType;   //!<消息类型
@property (nonatomic,copy) NSString *fromID;                                //!<消息发出者的ID
@property (nonatomic,copy) NSString *toID;                                  //!<消息接收者的ID

@end
