//
//  QSViewControllerAnimatedTransitioning.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSViewControllerAnimatedTransitioning.h"

@interface QSViewControllerAnimatedTransitioning ()

@property (nonatomic,assign) BOOL isPresenting;//!<当前是否是呈现状态

@end

@implementation QSViewControllerAnimatedTransitioning

#pragma mark - 初始化
- (instancetype)initWithPresenting:(BOOL)isPresenting
{

    if (self = [super init]) {
        
        self.isPresenting = isPresenting;
        
    }
    
    return self;

}

///动画时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{

    return 0.3f;

}

///动画前视图的位置
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{

    if (self.isPresenting) {
        
        ///添加
        [self animatePresentationWithTransitionContext:transitionContext];
        
    } else {
    
        ///移除
        [self animateDismissalWithTransitionContext:transitionContext];
    
    }

}

///添加
- (void)animatePresentationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{

    ///将要显示的view
    UIViewController *presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    ///当前显示的view
    UIView *containerView = [transitionContext containerView];
    
    ///设定被呈现的 view 一开始的位置，在屏幕下方
    presentedControllerView.frame = [transitionContext finalFrameForViewController:presentedController];
    presentedControllerView.frame = CGRectMake(presentedControllerView.frame.origin.x, containerView.frame.size.height, presentedControllerView.frame.size.width, presentedControllerView.frame.size.height);
    [containerView addSubview:presentedControllerView];
        
    // 添加一个动画，让被呈现的 view 移动到最终位置，我们使用0.6的damping值让动画有一种duang-duang的感觉……
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        presentedControllerView.center = CGPointMake(containerView.bounds.size.width / 2.0f, containerView.bounds.size.height / 2.0f);
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:finished];
        
    }];

}

///移除
- (void)animateDismissalWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    ///当前显示的view
    UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    ///之前显示的view
    UIView *containerView = [transitionContext containerView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        presentedControllerView.frame = CGRectMake(presentedControllerView.frame.origin.x, containerView.frame.size.height, presentedControllerView.frame.size.width, presentedControllerView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:finished];
        
    }];
    
}

@end
