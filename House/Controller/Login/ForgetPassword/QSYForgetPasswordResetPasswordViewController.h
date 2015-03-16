//
//  QSYForgetPasswordResetPasswordViewController.h
//  House
//
//  Created by ysmeng on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYForgetPasswordResetPasswordViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-16 11:03:17
 *
 *  @brief          根据手机和验证码，创建一个忘记密码并重置密码的页面
 *
 *  @param phone    手机号码
 *  @param verCode  验证码
 *
 *  @return         返回当前创建的重置密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPhone:(NSString *)phone andVerCode:(NSString *)verCode;

@end
