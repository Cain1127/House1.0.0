//
//  QSCustomPresentationViewController.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPresentationViewController.h"

#import <objc/runtime.h>

///本弹框的关联
static char QSCustomPopviewPresentationVCKey;//!<自定义弹框的关联key

@interface QSCustomPresentationViewController ()

@end

@implementation QSCustomPresentationViewController

#pragma mark - 通过自定义的动画弹出给定的view
/**
 *  @author     yangshengmeng, 15-01-27 22:01:32
 *
 *  @brief      通过自定义的动画展现一个view
 *
 *  @param view 需要显示的view
 *
 *  @since      1.0.0
 */
+ (instancetype)presentedView:(UIView *)view
{
    
    return [self presentedView:view andCustomModalType:cCustomModalPresentationDefault];
    
}

/**
 *  @author                     yangshengmeng, 15-01-27 22:01:58
 *
 *  @brief                      通过给定的动画风格展现给定的view
 *
 *  @param view                 给定的view
 *  @param modalPresentation    自定义的动画类型
 *
 *  @since                      1.0.0
 */
+ (instancetype)presentedView:(UIView *)view andCustomModalType:(CUSTOM_POPVIEW_ANIMINATION_STYLE)modalPresentation
{
    
    QSCustomPresentationViewController *custonShowVC = [[QSCustomPresentationViewController alloc] init];
    view.alpha = 0.0f;
    [custonShowVC.view addSubview:view];
    
    custonShowVC.view.frame = CGRectMake(0.0f, SIZE_DEVICE_HEIGHT, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:custonShowVC.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        custonShowVC.view.frame = CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
        view.alpha = 1.0f;
        
    }];
    
    ///关联
    objc_setAssociatedObject(view, &QSCustomPopviewPresentationVCKey, custonShowVC, OBJC_ASSOCIATION_ASSIGN);
    
    return custonShowVC;
    
}

/**
 *  @author yangshengmeng, 15-01-28 10:01:44
 *
 *  @brief  自定义弹出框的消失事件
 *
 *  @since  1.0.0
 */
- (void)customPopviewDismiss
{

    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(0.0f, SIZE_DEVICE_HEIGHT, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
        self.view.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        
    }];

}

@end
