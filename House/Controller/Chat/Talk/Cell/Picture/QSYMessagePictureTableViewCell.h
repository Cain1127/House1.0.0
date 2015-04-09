//
//  QSYMessagePictureTableViewCell.h
//  House
//
//  Created by ysmeng on 15/4/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSYSendMessagePicture;
@interface QSYMessagePictureTableViewCell : UITableViewCell

/**
 *  @author                 yangshengmeng, 15-04-06 13:04:23
 *
 *  @brief                  创建图片聊天显示框
 *
 *  @param style            风格
 *  @param reuseIdentifier  复用标签
 *  @param isMyMessage      消息是当前用户的还是其他人发送过来的
 *
 *  @return                 返回当前创建的文字聊天信息展示框
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMessageType:(MESSAGE_FROM_TYPE)isMyMessage;

/**
 *  @author         yangshengmeng, 15-04-06 14:04:18
 *
 *  @brief          刷新UI
 *
 *  @param model    消息数据模型
 *
 *  @since          1.0.0
 */
- (void)updateMessageWordUI:(QSYSendMessagePicture *)model;

@end
