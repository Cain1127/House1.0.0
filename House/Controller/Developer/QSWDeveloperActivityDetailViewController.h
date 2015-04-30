//
//  QSWDeveloperActivityDetailViewController.h
//  House
//
//  Created by 王树朋 on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSWDeveloperActivityDetailViewController : QSTurnBackViewController

/*!
 *  @author wangshupeng, 15-04-15 15:04:17
 *
 *  @brief  开发商活动详情页信息
 *
 *  @param title 活动主题
 *
 *  @return 活动详情内容
 *
 *  @since 1.0.0
 */
-(instancetype)initWithTitle:(NSString *)title andConnet:(NSString *)content andStatus:(NSString *)status andSignUpNum:(NSString *)number andImage:(NSString *)image andactivityID:(NSString *)activityID;


@end
