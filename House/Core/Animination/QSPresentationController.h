//
//  QSPresentationController.h
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///自定义动画类型
typedef enum
{

    cCustomModalPresentationDefault = 0,//!<默认的动画类型

}CUSTOM_MODALPRESENTATION_STYLE;

/**
 *  @author yangshengmeng, 15-01-27 21:01:59
 *
 *  @brief  自定义动画切换VC容器
 *
 *  @since  1.0.0
 */
@interface QSPresentationController : UIPresentationController

@end

@interface QSCustomPresentationViewController : UIViewController <UIViewControllerTransitioningDelegate>

/**
 *  @author     yangshengmeng, 15-01-27 22:01:32
 *
 *  @brief      通过自定义的动画展现一个view
 *
 *  @param view 需要显示的view
 *
 *  @since      1.0.0
 */
+ (void)presentedView:(UIView *)view;

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
+ (void)presentedView:(UIView *)view andCustomModalType:(CUSTOM_MODALPRESENTATION_STYLE)modalPresentation;

@end