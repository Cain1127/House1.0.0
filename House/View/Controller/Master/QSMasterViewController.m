//
//  QSMasterViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMasterViewController.h"

#import <objc/runtime.h>

///关联
static char NavigationBarKey;//!<导航栏的关联key

@interface QSMasterViewController ()

@end

@implementation QSMasterViewController

#pragma mark - 重写导航栏：添加导航栏
///导航栏UI
- (void)createNavigationBarUI
{

    ///创建自定义导航栏
    QSNavigationBar *navigationBar = [[QSNavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 64.0f)];
    [self.view addSubview:navigationBar];
    objc_setAssociatedObject(self, &NavigationBarKey, navigationBar, OBJC_ASSOCIATION_ASSIGN);

}

#pragma mark - 导航栏设置
/**
 *  @author             yangshengmeng, 15-01-17 14:01:16
 *
 *  @brief              通过图片的名字，设置导航栏背景图片
 *
 *  @param imageName    背景图片名字
 *
 *  @since              1.0.0
 */
- (void)setNavigationBarBackgroudImageWithImageName:(NSString *)imageName
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarBackgroudImageWithImageName:imageName];
        
    });

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:57
 *
 *  @brief          通过图片设置导航栏背景图片
 *
 *  @param image    图片
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarBackgroudImageWithImage:(UIImage *)image
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarBackgroudImageWithImage:image];
        
    });

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:24
 *
 *  @brief          设置导航栏中间标题
 *
 *  @param title    标题
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarTitle:(NSString *)title
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarTitle:title];
        
    });

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:42
 *
 *  @brief          添加一个自定义的中间视图
 *
 *  @param view     中间视图
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarMiddleView:(UIView *)view
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarMiddleView:view];
        
    });

}

/**
 *  @author     yangshengmeng, 15-01-17 14:01:04
 *
 *  @brief      设置导航栏右侧视图
 *
 *  @param view 右侧显示视图
 *
 *  @since      1.0.0
 */
- (void)setNavigationBarRightView:(UIView *)view
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarRightView:view];
        
    });

}

/**
 *  @author     yangshengmeng, 15-01-17 14:01:33
 *
 *  @brief      设置左侧显示视图
 *
 *  @param view 左侧视图
 *
 *  @since      1.0.0
 */
- (void)setNavigationBarLeftView:(UIView *)view
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSNavigationBar *navigationBar = objc_getAssociatedObject(self, &NavigationBarKey);
        [navigationBar setNavigationBarLeftView:view];
        
    });

}

@end
