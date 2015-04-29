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


/**
 *  根据传入字段创建投诉页面
 *
 *  @param indicteeId 被投诉者id（在处理投诉联系人时，此参数必须要传,在处理订单投诉时不需要传）
 *  @param sueder     投诉者，BUYER:买家投诉卖家，SALER:卖家投诉买家
 *  @param orderID    订单id（在处理订单投诉时，此参数必须要传）
 *  @param desc       投诉的附加内容
 *  @param callBack   回调
 *
 *  @return 返回当前联系人的投诉页面
 */
- (instancetype)initWithIndicteeId:(NSString *)indicteeId andSueder:(NSString *)sueder andOrderID:(NSString *)orderID WithDesc:(NSString*)desc andCallBack:(void(^)(BOOL isComplaint))callBack;

@end
