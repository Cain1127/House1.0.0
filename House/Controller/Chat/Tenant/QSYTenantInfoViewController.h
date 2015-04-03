//
//  QSYTenantInfoViewController.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYTenantInfoViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-03 16:04:30
 *
 *  @brief              创建普通房客的信息页
 *
 *  @param tenantName   房客名
 *  @param tenantID     房客的ID
 *
 *  @return             返回当前房客的信息页
 *
 *  @since              1.0.0
 */
- (instancetype)initWithName:(NSString *)tenantName andAgentID:(NSString *)tenantID;

@end
