//
//  QSYTalkPTPViewController.h
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSUserSimpleDataModel;
@interface QSYTalkPTPViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-03-31 15:03:25
 *
 *  @brief              根据聊天对像，创建聊天窗口
 *
 *  @param userModel    对方用户信息数据模型
 *
 *  @return             返回当前聊天窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithUserModel:(QSUserSimpleDataModel *)userModel;

@end
