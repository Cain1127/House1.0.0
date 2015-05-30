//
//  QSYSystemMessageDetailViewController.h
//  House
//
//  Created by ysmeng on 15/5/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSYSystemMessageListDataModel;
@interface QSYSystemMessageDetailViewController : QSTurnBackViewController

///系统消息详情
@property (nonatomic,retain) QSYSystemMessageListDataModel *detailModel;

@end
