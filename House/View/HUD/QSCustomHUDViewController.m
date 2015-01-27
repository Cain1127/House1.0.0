//
//  QSCustomHUDViewController.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomHUDViewController.h"

@interface QSCustomHUDViewController ()

@property (nonatomic,copy) NSString *headerTips;    //!<加载HUD时首先显示的信息
@property (nonatomic,copy) NSString *footerTips;    //!<移聊前的显示信息
@property (nonatomic,copy) NSString *mainTips;      //!<主要显示消息

@end

@implementation QSCustomHUDViewController

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///中间转动图片
    
}

#pragma mark - ================提供外部访问接口================
/**
 *  @author yangshengmeng, 15-01-27 12:01:41
 *
 *  @brief  显示自定义的HUD
 *
 *  @return 返回当前显示的HUD
 *
 *  @since  1.0.0
 */
+ (instancetype)showCustomHUD
{

    return [self showCustomHUDWithTips:nil];

}

/**
 *  @author     yangshengmeng, 15-01-27 13:01:03
 *
 *  @brief      显示一个自定义的HUD，并且显示给定的提示信息
 *
 *  @param tips 给定的提示信息
 *
 *  @return     返回当前显示的HUD
 *
 *  @since      1.0.0
 */
+ (instancetype)showCustomHUDWithTips:(NSString *)tips
{

    return [self showCustomHUDWithTips:tips andHeaderTips:nil];

}

/**
 *  @author             yangshengmeng, 15-01-27 13:01:48
 *
 *  @brief              显示一个有前置提示信息的自定义HUD
 *
 *  @param tips         主要提示信息
 *  @param headerTips   前置提示信息
 *
 *  @return             返回当前显示的HUD
 *
 *  @since              1.0.0
 */
+ (instancetype)showCustomHUDWithTips:(NSString *)tips andHeaderTips:(NSString *)headerTips
{

    return [self showCustomHUDWithTips:tips andHeaderTips:headerTips andFooterTips:nil];

}

/**
 *  @author yangshengmeng, 15-01-27 13:01:40
 *
 *  @brief              显示一个有前置提示信息、中间主要提示信息及移聊时的提示信息HUD
 *
 *  @param tips         主要提示信息
 *  @param headerTips   前置显示信息
 *  @param footerTips   后置提示信息
 *
 *  @return             返回当前显示的HUD
 *
 *  @since              1.0.0
 */
+ (instancetype)showCustomHUDWithTips:(NSString *)tips andHeaderTips:(NSString *)headerTips andFooterTips:(NSString *)footerTips
{

    QSCustomHUDViewController *hudVC = [[QSCustomHUDViewController alloc] init];
    
    ///保存相关提示信息
    if (tips) {
        
        [hudVC setValue:tips forKey:@"mainTips"];
        
    }
    
    if (headerTips) {
        
        [hudVC setValue:tips forKey:@"headerTips"];
        
    }
    
    if (footerTips) {
        
        [hudVC setValue:tips forKey:@"footerTips"];
        
    }
    
    ///模态显示
    hudVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    hudVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:hudVC animated:YES completion:^{}];
    
    return hudVC;

}

/**
 *  @author yangshengmeng, 15-01-27 13:01:17
 *
 *  @brief  隐藏自定义HUD
 *
 *  @since  1.0.0
 */
- (void)hiddenCustomHUD
{

    

}

/**
 *  @author             yangshengmeng, 15-01-27 13:01:32
 *
 *  @brief              隐藏自定义HUD，并且移除前显示给定的信息
 *
 *  @param footerTips   移除前显示的提示信息
 *
 *  @since              1.0.0
 */
- (void)hiddenCustomHUDWithFooterTips:(NSString *)footerTips
{

    

}

@end
