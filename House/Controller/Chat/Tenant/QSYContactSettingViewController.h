//
//  QSYContactSettingViewController.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYContactSettingViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-13 15:04:00
 *
 *  @brief              根据联系人的ID，创建联系人信息设置页面
 *
 *  @param contactID    联系人ID
 *  @param isFriend     是否是当前用户的联系人
 *  @param isImport     是否是重点联系人
 *
 *  @return             返回当前创建的联系人设置页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID isFriends:(BOOL)isFriend isImport:(NSString *)isImport;

@end
