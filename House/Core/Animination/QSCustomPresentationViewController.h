//
//  QSCustomPresentationViewController.h
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///自定义动画类型
typedef enum
{
    
    cCustomModalPresentationDefault = 0,//!<默认的动画类型
    
}CUSTOM_POPVIEW_ANIMINATION_STYLE;

///自定义的view弹出效果父viewController
@interface QSCustomPresentationViewController : UIViewController

/**
 *  @author     yangshengmeng, 15-01-27 22:01:32
 *
 *  @brief      通过自定义的动画展现一个view
 *
 *  @param view 需要显示的view
 *
 *  @since      1.0.0
 */
+ (instancetype)presentedView:(UIView *)view;

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
+ (instancetype)presentedView:(UIView *)view andCustomModalType:(CUSTOM_POPVIEW_ANIMINATION_STYLE)modalPresentation;

/**
 *  @author yangshengmeng, 15-01-28 10:01:44
 *
 *  @brief  自定义弹出框的消失事件
 *
 *  @since  1.0.0
 */
- (void)customPopviewDismiss;

@end
