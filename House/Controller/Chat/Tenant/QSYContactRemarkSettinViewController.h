//
//  QSYContactRemarkSettinViewController.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYContactRemarkSettinViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-13 16:04:24
 *
 *  @brief              根据联系人的ID创建备注联系人信息的页面
 *
 *  @param contactID    联系人ID
 *
 *  @return             返回当前创建的联系人备注页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID;

@end
