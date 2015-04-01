//
//  QSYPostMessageListReturnData.h
//  House
//
//  Created by ysmeng on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

@class QSYPostMessageListHeaderData;
@interface QSYPostMessageListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSYPostMessageListHeaderData *headerData;//!<头信息

@end

@interface QSYPostMessageListHeaderData : QSBaseModel

@property (nonatomic,retain) NSMutableArray *messageList;//!<消息列表

@end