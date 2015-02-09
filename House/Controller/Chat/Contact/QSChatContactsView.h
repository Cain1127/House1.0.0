//
//  QSChatContactsView.h
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-02-09 11:02:11
 *
 *  @brief  联系人列表
 *
 *  @since  1.0.0
 */
@interface QSChatContactsView : UIView

/**
 *  @author         yangshengmeng, 15-02-09 11:02:22
 *
 *  @brief          根据用户类型创建联系人列表
 *
 *  @param frame    大小和位置
 *  @param userType 用户类型
 *
 *  @return         返回当前创建的联系人列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType;

@end
