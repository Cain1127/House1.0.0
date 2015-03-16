//
//  QSYRegistSetPasswordViewController.h
//  House
//
//  Created by ysmeng on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYRegistSetPasswordViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-14 10:03:42
 *
 *  @brief          创建注册设置密码的页面
 *
 *  @param phone    注册的手机
 *  @param verCode  所发送的手机验证码
 *  @param callBack 注册后的回调
 *
 *  @return         返回当前创建的注册设置密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithRegistPhone:(NSString *)phone andVercode:(NSString *)verCode andRegistCallBack:(void(^)(BOOL flag,NSString *count,NSString *psw))callBack;

@end
