//
//  QSYContactComplaintViewController.h
//  House
//
//  Created by ysmeng on 15/4/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYContactComplaintViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-13 16:04:57
 *
 *  @brief              根据联系人的ID和姓名，显示投诉页面
 *
 *  @param contactID    联系人ID
 *  @param contactName  联系人姓名
 *
 *  @return             返回当前联系人的投诉页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID andContactName:(NSString *)contactName;

@end
