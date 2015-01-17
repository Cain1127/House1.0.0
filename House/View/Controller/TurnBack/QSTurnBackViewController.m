//
//  QSTurnBackViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSTabBarViewController.h"

@interface QSTurnBackViewController ()<UINavigationControllerDelegate>

@property (nonatomic,assign) int turnBackStepCount;             //!<返回的步距

@end

@implementation QSTurnBackViewController

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        ///初始化时的返回步距只为0
        self.turnBackStepCount = 0;
        
        ///初始化push的时候，不隐藏tabbar
        self.hiddenCustomTabbarWhenPush = NO;
        
    }
    
    return self;

}

#pragma mark - 在导航栏添加返回按钮
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///导航栏设置按钮
    UIButton *turnBackButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeLeft andButtonType:nNavigationBarButtonTypeTurnBack] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoTurnBackAction];
        
    }];
    [self setNavigationBarLeftView:turnBackButton];

}

#pragma mark - 返回事件
- (void)gotoTurnBackAction
{
    
    ///判断是否需要重新显示tabbar
    if (self.hiddenCustomTabbarWhenPush) {
        
        QSTabBarViewController *tabbarController = (QSTabBarViewController *)self.tabBarController;
        [tabbarController hiddenBottomTabbar:NO];
        
    }

    ///如果设置了步距，则必须跳转到对应的页面中
    if (self.turnBackStepCount > 1) {
        
        int sumVCCount = (int)[self.navigationController.viewControllers count];
        int turnBackIndex = (sumVCCount - self.turnBackStepCount - 1) > 0 ? (sumVCCount - self.turnBackStepCount - 1) : 0;
        UIViewController *tempViewController = self.navigationController.viewControllers[turnBackIndex];
        [self.navigationController popToViewController:tempViewController animated:YES];
        
    } else {
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }

}

#pragma mark - 设置返回事件的步距
/**
 *  @author             yangshengmeng, 15-01-17 23:01:53
 *
 *  @brief              设置返回时，跳转到当前相差stepCount个的页面，如若超过rootView，则直接显示rootView
 *
 *  @param stepCount    跳转的步距
 *
 *  @since              1.0.0
 */
- (void)setTurnBackDistanceStep:(int)stepCount
{

    self.turnBackStepCount = stepCount;

}

@end
