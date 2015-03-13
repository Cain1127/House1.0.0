//
//  QSYRegistViewController.h
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

/**
 *  @author yangshengmeng, 15-03-13 18:03:33
 *
 *  @brief  注册页面
 *
 *  @since  1.0.0
 */
@interface QSYRegistViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-13 18:03:27
 *
 *  @brief          根据注册的回调，创建注页面
 *
 *  @param callBack 注册后回调block
 *
 *  @return         返回当前创建的注册页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithRegistCallBack:(void(^)(BOOL flag,NSString *count,NSString *psw))callBack;

@end
