//
//  QSYMessageRecommendHouseTableViewCell.h
//  House
//
//  Created by ysmeng on 15/5/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSYSendMessageRecommendHouse;
@interface QSYMessageRecommendHouseTableViewCell : UITableViewCell

/**
 *  @author                 yangshengmeng, 15-05-08 11:05:50
 *
 *  @brief                  创建
 *
 *  @param style            cell风格
 *  @param reuseIdentifier  复用标签
 *  @param isMyMessage      消息归属者类型
 *
 *  @return                 返回当前创建的消息展现cell
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMessageType:(MESSAGE_FROM_TYPE)isMyMessage;

/**
 *  @author         yangshengmeng, 15-05-08 11:05:14
 *
 *  @brief          刷新UI
 *
 *  @param model    消息数据模型
 *
 *  @since          1.0.0
 */
- (void)updateMessageWordUI:(QSYSendMessageRecommendHouse *)model;

@end
