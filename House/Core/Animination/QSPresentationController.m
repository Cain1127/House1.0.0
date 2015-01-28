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

//@implementation QSCustomPresentationViewController
//
//#pragma mark - 通过自定义的动画弹出给定的view
///**
// *  @author     yangshengmeng, 15-01-27 22:01:32
// *
// *  @brief      通过自定义的动画展现一个view
// *
// *  @param view 需要显示的view
// *
// *  @since      1.0.0
// */
//+ (instancetype)presentedView:(UIView *)view
//{
//
//    [self presentedView:view andCustomModalType:cCustomModalPresentationDefault];
//
//}
//
///**
// *  @author                     yangshengmeng, 15-01-27 22:01:58
// *
// *  @brief                      通过给定的动画风格展现给定的view
// *
// *  @param view                 给定的view
// *  @param modalPresentation    自定义的动画类型
// *
// *  @since                      1.0.0
// */
//+ (instancetype)presentedView:(UIView *)view andCustomModalType:(CUSTOM_MODALPRESENTATION_STYLE)modalPresentation
//{
//
//    QSCustomPresentationViewController *custonShowVC = [[QSCustomPresentationViewController alloc] init];
//    
//    custonShowVC.view.frame = CGRectMake(0.0f, SIZE_DEVICE_HEIGHT, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:custonShowVC.view];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        custonShowVC.view.frame = CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
//        
//    }];
//
//    return sendMsgVC;
//
//}
//
//#pragma mark - 初始化
//- (instancetype)init
//{
//
//    if (self = [super init]) {
//        
//        self.modalPresentationStyle = UIModalPresentationCustom;
//        self.transitioningDelegate = self;
//        
//    }
//    
//    return self;
//
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//
//    if (self = [super initWithCoder:aDecoder]) {
//        
//        self.modalPresentationStyle = UIModalPresentationCustom;
//        self.transitioningDelegate = self;
//        
//    }
//    
//    return self;
//
//}
//
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        
//        self.modalPresentationStyle = UIModalPresentationCustom;
//        self.transitioningDelegate = self;
//        
//    }
//    
//    return self;
//
//}
//
//#pragma mark - 当前模态管理器
//- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
//{
//
//    if (presented == self) {
//        
//        return [[QSPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
//        
//    }
//    
//    return nil;
//
//}
//
//#pragma mark - 显示的动画
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//
//    if (presented == self) {
//        
//        return [[QSViewControllerAnimatedTransitioning alloc] initWithPresenting:YES];
//        
//    }
//    
//    return nil;
//
//}
//
//#pragma mark - 消失动画
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//
//    if (dismissed == self) {
//        
//        return [[QSViewControllerAnimatedTransitioning alloc] initWithPresenting:NO];
//        
//    }
//    
//    return nil;
//
//}
//
//@end