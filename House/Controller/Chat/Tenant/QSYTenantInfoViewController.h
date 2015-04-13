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
 *  @author yangshengmeng, 15-04-13 17:04:45
 *
 *  @brief  在联系人详情页面中，可能发生联系的关系变化，变化时通过以下block回调
 *
 *  @since  1.0.0
 */
@property (nonatomic,copy) void(^contactInfoChangeCallBack)(BOOL isChange);

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
