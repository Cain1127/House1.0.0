//
//  QSYContactsListReturnData.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

@class QSYContactsListHeaderData;
@interface QSYContactsListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSYContactsListHeaderData *headerData;//!<头信息

@end

@interface QSYContactsListHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSMutableArray *contactsList;          //!<消息列表

@end