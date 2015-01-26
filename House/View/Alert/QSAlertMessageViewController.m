//
//  QSAlertMessageViewController.m
//  House
//
//  Created by ysmeng on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAlertMessageViewController.h"

@implementation QSAlertMessageViewController

/**
 *  @author         yangshengmeng, 15-01-26 12:01:23
 *
 *  @brief          弹出一个给定信息的提醒框，默认显示1.0秒后自动消失
 *
 *  @param message  需要显示的信息
 *
 *  @since          1.0.0
 */
+ (void)showAlertMessage:(NSString *)message
{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    ///弹出说明框
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:^{}];
    
    ///1秒后消换
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertVC dismissViewControllerAnimated:YES completion:^{}];
        
    });

}

+ (void)showAlertMessage:(NSString *)message andCallBack:(void(^)(void))callBack
{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    ///弹出说明框
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:^{}];
    
    ///1秒后消换
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (callBack) {
            
            callBack();
            
        }
        
        [alertVC dismissViewControllerAnimated:YES completion:^{}];
        
    });

}

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
+ (void)showAlertMessage:(NSString *)message andShowTime:(CGFloat)showTime
{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    ///弹出说明框
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:^{}];
    
    ///1秒后消换
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((showTime > 0.5f ? showTime : 1.0f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertVC dismissViewControllerAnimated:YES completion:^{}];
        
    });

}

+ (void)showAlertMessage:(NSString *)message andShowTime:(CGFloat)showTime andCallBack:(void(^)(void))callBack
{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    ///弹出说明框
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:^{}];
    
    ///1秒后消换
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((showTime > 0.5f ? showTime : 1.0f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (callBack) {
            
            callBack();
            
        }
        
        [alertVC dismissViewControllerAnimated:YES completion:^{}];
        
    });

}

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
+ (void)showAlertMessage:(NSString *)message andConfirmButtonTitle:(NSString *)confirmTitle andCallBack:(void(^)(UIAlertAction *action))confirmCallBack
{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    ///确认事件
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        confirmCallBack(action);
        
        [alertVC dismissViewControllerAnimated:YES completion:^{}];
        
    }];
    
    ///添加事件
    [alertVC addAction:confirmAction];
    
    ///弹出说明框
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:^{}];

}

+ (void)showAlertMessage:(NSString *)message andConfirmButtonTitle:(NSString *)confirmTitle andCancelTitle:(NSString *)cancelTitle andCallBack:(void(^)(UIAlertAction *action))confirmCallBack
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    ///确认事件
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        confirmCallBack(action);
        
        [alertVC dismissViewControllerAnimated:YES completion:^{}];
        
    }];
    
    ///确认事件
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        confirmCallBack(action);
        
        [alertVC dismissViewControllerAnimated:YES completion:^{}];
        
    }];
    
    ///添加事件
    [alertVC addAction:confirmAction];
    [alertVC addAction:cancelAction];
    
    ///弹出说明框
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:^{}];
    
}

@end
