//
//  QSAlertMessageViewController.h
//  House
//
//  Created by ysmeng on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-01-26 13:01:46
 *
 *  @brief  自定义的弹出提醒框
 *
 *  @since  1.0.0
 */
@interface QSAlertMessageViewController : UIAlertController

/**
 *  @author         yangshengmeng, 15-01-26 12:01:23
 *
 *  @brief          弹出一个给定信息的提醒框，默认显示1.0秒后自动消失
 *
 *  @param message  需要显示的信息
 *
 *  @since          1.0.0
 */
+ (void)showAlertMessage:(NSString *)message;
+ (void)showAlertMessage:(NSString *)message andCallBack:(void(^)(void))callBack;

/**
 *  @author         yangshengmeng, 15-01-26 12:01:03
 *
 *  @brief          弹出一个显示给定时间的提醒信息框
 *
 *  @param message  显示的信息
 *  @param showTime 显示时间
 *
 *  @since          1.0.0
 */
+ (void)showAlertMessage:(NSString *)message andShowTime:(CGFloat)showTime;
+ (void)showAlertMessage:(NSString *)message andShowTime:(CGFloat)showTime andCallBack:(void(^)(void))callBack;

/**
 *  @author                 yangshengmeng, 15-01-26 12:01:57
 *
 *  @brief                  弹出一个有确认按钮的消息提示框
 *
 *  @param message          需要显示的消息
 *  @param confirmTitle     确认按钮的标题
 *  @param confirmCallBack  点击确认时的回调
 *
 *  @since                  1.0.0
 */
+ (void)showAlertMessage:(NSString *)message andConfirmButtonTitle:(NSString *)confirmTitle andCallBack:(void(^)(UIAlertAction *action))confirmCallBack;

@end
