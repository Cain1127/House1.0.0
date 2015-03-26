//
//  QSBlockAlertView.h
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSBlockAlertView : UIAlertView

/**
 *  @author                     yangshengmeng, 15-03-26 11:03:18
 *
 *  @brief                      创建一个自带按钮事件
 *
 *  @param title                提示的标题
 *  @param message              提示的信息
 *  @param cancelButtonTitle    取消按钮的标题
 *  @param callBack             点击按钮时的回调
 *  @param otherButtonTitles    其他按钮
 *
 *  @return                     返回当前创建的block回调alertView
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle andCallBack:(void(^)(int buttonIndex))callBack otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
