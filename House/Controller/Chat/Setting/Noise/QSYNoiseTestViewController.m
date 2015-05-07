//
//  QSYNoiseTestViewController.m
//  House
//
//  Created by ysmeng on 15/5/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYNoiseTestViewController.h"

@interface QSYNoiseTestViewController ()

@end

@implementation QSYNoiseTestViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"噪音检测"];

}

- (void)createMainShowUI
{

    ///logo
    QSImageView *logoImageView = [[QSImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 160.0f) / 2.0f, 84.0f, 160.0f, 160.0f)];
    logoImageView.image = [UIImage imageNamed:IMAGE_PUBLIC_APPLOGO_320];
    [self.view addSubview:logoImageView];
    
    ///六角
    QSImageView *sixHollowImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, logoImageView.frame.size.width, logoImageView.frame.size.height)];
    sixHollowImageView.image = [UIImage imageNamed:IMAGE_PUBLIC_APPLOGO_HOLLOW_320];
    [logoImageView addSubview:sixHollowImageView];
    
    ///说明
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, logoImageView.frame.origin.y + logoImageView.frame.size.height + 20.0f, SIZE_DEVICE_WIDTH - 60.0f, 30.0f)];
    tipsLabel.text = @"敬请期待";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    [self.view addSubview:tipsLabel];

}

@end
