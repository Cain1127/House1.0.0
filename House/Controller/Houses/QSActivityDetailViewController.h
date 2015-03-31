//
//  QSActivityDetailViewController.h
//  House
//
//  Created by 王树朋 on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"
#import "QSActivityDataModel.h"

@interface QSActivityDetailViewController : QSTurnBackViewController

/*!
 *  @author wangshupeng, 15-03-31 10:03:01
 *
 *  @brief  活动详情界面
 *
 *  @param activityID 活动ID
 *
 *  @return 活动详情
 *
 *  @since 1.0.0
 */
-(instancetype)initWithactivityID:(NSString*)activityID;

@end
