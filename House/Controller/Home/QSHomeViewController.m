//
//  QSHomeViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHomeViewController.h"
#import "QSTabBarViewController.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSHouseKeySearchViewController.h"
#import "ColorHeader.h"
#import "QSCustomHUDView.h"
#import "QSNavigationBarPickerView.h"

@interface QSHomeViewController ()

@end

@implementation QSHomeViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///中间选择城市按钮
    QSNavigationBarPickerView *cityPickerView = [[QSNavigationBarPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andPickerType:nNavigationBarPickerStyleTypeCity andPickerViewStyle:nNavigationBarPickerStyleRightLocal andPickedCallBack:^(NSString *cityKey, NSString *cityVal) {
        
        NSLog(@"====================首页城市选择====================");
        NSLog(@"当前选择城市：%@,%@",cityKey,cityVal);
        NSLog(@"====================首页城市选择====================");
        
    }];
    [self setNavigationBarMiddleView:cityPickerView];
    
    ///添加右侧搜索按钮
    UIButton *searchButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeSearch] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoSearchViewController];
        
    }];
    [self setNavigationBarRightView:searchButton];

}

-(void)createMainShowUI
{
    
    [super createMainShowUI];
    
    
    
}

#pragma mark - 进入搜索页面
- (void)gotoSearchViewController
{
    
    ///显示房源列表，并进入搜索页
    self.tabBarController.selectedIndex = 1;
    
    UIViewController *housesVC = self.tabBarController.viewControllers[1];
    
    ///判断是ViewController还是NavigationController
    if ([housesVC isKindOfClass:[UINavigationController class]]) {
        
        housesVC = ((UINavigationController *)housesVC).viewControllers[0];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([housesVC respondsToSelector:@selector(gotoSearchViewController)]) {
            
            [housesVC performSelector:@selector(gotoSearchViewController)];
            
        }
        
    });
    
}

#pragma mark -按钮点击事件


@end
