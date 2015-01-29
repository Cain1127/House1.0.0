//
//  QSGuideHeaderViewController.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideHeaderViewController.h"

@interface QSGuideHeaderViewController ()

@end

@implementation QSGuideHeaderViewController

#pragma mark - UI搭建
- (void)createMainShowUI
{

    ///背景图片
    QSImageView *backgoundImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT * (458.0f / 667.0f))];
    backgoundImageView.image = [UIImage imageNamed:IMAGE_GUIDE_HEADER_BACKGROUD];
    [self createCustomGuideHeaderSubviewsUI:backgoundImageView];
    [self.view addSubview:backgoundImageView];
    
    ///底部控制放置区
    UIView *footerRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, backgoundImageView.frame.size.height + backgoundImageView.frame.origin.y, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - backgoundImageView.frame.size.height)];
    footerRootView.backgroundColor = [UIColor clearColor];
    [self createCustomGuideFooterUI:footerRootView];
    [self.view addSubview:footerRootView];

}

#pragma mark - 指引页顶部子view创建
/**
 *  @author             yangshengmeng, 15-01-20 14:01:28
 *
 *  @brief              在指定的视图中添加顶部相关的子view
 *
 *  @param headerView   顶部视图的底view
 *
 *  @since              1.0.0
 */
- (void)createCustomGuideHeaderSubviewsUI:(UIView *)headerView
{
    
    
    
}

#pragma mark - 指引页底部子view创建
/**
 *  @author     yangshengmeng, 15-01-20 14:01:51
 *
 *  @brief      在给定的视图上添加底部相关控件
 *
 *  @param view 底部控制
 *
 *  @since      1.0.0
 */
- (void)createCustomGuideFooterUI:(UIView *)view
{
    
    
    
}

@end
