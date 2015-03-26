//
//  QSBlockAlertView.m
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockAlertView.h"

@interface QSBlockAlertView () <UIAlertViewDelegate>

///按钮事件的回调
@property (nonatomic,copy) void(^blockAlertViewCallBack)(int buttonIndex);

@end

@implementation QSBlockAlertView

#pragma mark - 初始化
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
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle andCallBack:(void(^)(int buttonIndex))callBack otherButtonTitles:(NSString *)otherButtonTitles, ...
{

    if (self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]) {
        
        ///保存回调
        if (callBack) {
            
            self.blockAlertViewCallBack = callBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - 按钮事件回调
///按钮事件回调
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (self.blockAlertViewCallBack) {
        
        self.blockAlertViewCallBack((int)buttonIndex);
        
    }

}

@end
