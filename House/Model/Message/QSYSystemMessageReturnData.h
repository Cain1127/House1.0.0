//
//  QSYSystemMessageReturnData.h
//  House
//
//  Created by ysmeng on 15/4/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

@class QSYSystemMessageHeaderData;
@interface QSYSystemMessageReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSYSystemMessageHeaderData *headerData;    //!<系统消息网络数据头

@end

@interface QSYSystemMessageHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSMutableArray *dataList;                  //!<系统消息数组

@end