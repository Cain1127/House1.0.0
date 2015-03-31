//
//  QSSignUpViewController.h
//  House
//
//  Created by 王树朋 on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSSignUpViewController : QSTurnBackViewController

/*!
 *  @author wangshupeng, 15-03-31 10:03:32
 *
 *  @brief  有活动的报名流程
 *
 *  @param activityID 活动ID
 *  @param title      活动标题
 *  @param number     已报名人数
 *  @param endTime    报名截止日期
 *
 *  @return 报名流程
 *
 *  @since 1.0.0
 */
-(instancetype)initWithactivityID:(NSString*)activityID andTitle:(NSString *)title andNumber:(NSString *)number andEndTime:(NSString *)endTime;

/*!
 *  @author wangshupeng, 15-03-31 13:03:35
 *
 *  @brief 没有活动的报名
 *
 *  @param houseTitle 新房名称
 *
 *  @return 报名登记
 *
 *  @since 1.0.0
 */
-(instancetype)initWithtitle:(NSString *)houseTitle;
@end
