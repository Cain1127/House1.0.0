//
//  QSCustomPopRootView.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPopRootView.h"
#import "ASDepthModalViewController.h"
#import "QSPresentationController.h"

@interface QSCustomPopRootView ()

@end

@implementation QSCustomPopRootView

#pragma mark - 初始化
- (instancetype)init
{

    return [self initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];

}

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        ///添加点击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewTapAction:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        ///加载自定义View
        [self createCustomPopviewInfoUI];
        
    }
    
    return self;

}

///创建自定义的信息展示UI
- (void)createCustomPopviewInfoUI
{

    

}

#pragma mark - 点击灰色地区时回收
/**
 *  @author     yangshengmeng, 15-01-27 15:01:48
 *
 *  @brief      单击灰色地带时，回收
 *
 *  @param tap  单击对象
 *
 *  @since      1.0.0
 */
- (void)popViewTapAction:(UITapGestureRecognizer *)tap
{
    
    //获取当前点击点的坐标
    CGPoint tapPoint = [tap locationInView:self];
    
    ///获取录音视图区域的视图
    UIView *customView = [tap.view subviews][0];
    
    ///将当前点击点的坐标转换到子视图上
    BOOL pointISExitSubview = CGRectContainsPoint(customView.frame, tapPoint);
    
    if (pointISExitSubview) {
        
        return;
        
    }

    if (self.customPopviewTapCallBack) {
        
        self.customPopviewTapCallBack(cCustomPopviewActionTypeDefault,nil,-1);
        
    }
    
    [self hiddenCustomPopview];

}

#pragma mark - 隐藏事件
- (void)hiddenCustomPopview
{

#if 0
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0.0f, SIZE_DEVICE_HEIGHT, self.frame.size.width, self.frame.size.height);
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
#endif
    
#if 1
    
    [ASDepthModalViewController dismiss];
    
#endif

}

#pragma mark - 显示事件
- (void)showCustomPopview
{

#if 0
    ///先把frame置为全窗口
    self.frame = CGRectMake(0.0f, SIZE_DEVICE_HEIGHT, SIZE_DEVICE_HEIGHT, SIZE_DEVICE_WIDTH);
    self.alpha = 0.0f;
    
    ///加载到最顶层窗口上
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    
    ///动画显示
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
        self.alpha = 1.0f;
        
    }];
#endif
    
#if 0
    
    [ASDepthModalViewController presentView:self backgroundColor:[UIColor clearColor] options:ASDepthModalOptionTapOutsideInactive completionHandler:^{
        
    }];
    
#endif
    
#if 1
    
    [QSCustomPresentationViewController presentedView:self];
    
#endif

}

@end
