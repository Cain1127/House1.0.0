//
//  QSCustomPopRootView.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPopRootView.h"
#import "QSCustomPresentationViewController.h"

#import <objc/runtime.h>

///关联
static char CustomPresentationVCKey;//!<弹框使用的对象

@interface QSCustomPopRootView ()

@property (nonatomic,retain) QSCustomPresentationViewController *customPresantationVC;//!<弹框使用的对象

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
        self.backgroundColor = COLOR_CHARACTERS_BLACKH;
        
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

    [self.customPresantationVC customPopviewDismiss];
    
}

#pragma mark - 显示事件
- (void)showCustomPopview
{
    
    self.customPresantationVC = [QSCustomPresentationViewController presentedView:self];

}

@end
