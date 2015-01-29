//
//  QSPresentationController.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPresentationController.h"
#import "QSViewControllerAnimatedTransitioning.h"

@interface QSPresentationController ()

@property (nonatomic,retain) UIView *defaultBackgroudView;  //!<默认的背景view
@property (nonatomic,retain) UIView *showView;              //!<需要动画显示的view

@end

@implementation QSPresentationController

///动画将要开始时
- (void)presentationTransitionWillBegin
{

    // 添加半透明背景 View 到我们的视图结构中
    self.defaultBackgroudView.frame = self.containerView.bounds;
    self.defaultBackgroudView.alpha = 0.0;
    
    [self.containerView addSubview:self.defaultBackgroudView];
    [self.containerView addSubview:self.showView];
    
    // 与过渡效果一起执行背景 View 的淡入效果
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        self.defaultBackgroudView.alpha = 1.0f;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        
        
    }];

}

///动画已结束
- (void)presentationTransitionDidEnd:(BOOL)completed
{

    if (!completed) {
        
        [self.defaultBackgroudView removeFromSuperview];
        
    }

}

///移除已结束
- (void)dismissalTransitionWillBegin
{

    // 与过渡效果一起执行背景 View 的淡出效果
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        self.defaultBackgroudView.alpha = 0.0f;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        
        
    }];

}

///已完成移除
- (void)dismissalTransitionDidEnd:(BOOL)completed
{

    if (completed) {
        
        [self.defaultBackgroudView removeFromSuperview];
        
    }

}

///需要显示的view动画
- (CGRect)frameOfPresentedViewInContainerView
{

    CGRect frame = self.containerView.bounds;
    return CGRectInset(frame, frame.size.width, frame.size.height);

}

@end