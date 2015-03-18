//
//  QSYAskSaleAndRentViewController.m
//  House
//
//  Created by ysmeng on 15/3/18.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskSaleAndRentViewController.h"
#import "QSFilterViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYAskSaleAndRentViewController ()

@end

@implementation QSYAskSaleAndRentViewController

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"求租求购"];

}

- (void)createMainShowUI
{

    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, SIZE_DEVICE_HEIGHT / 2.0f - 60.0f, SIZE_DEVICE_WIDTH - 60.0f, 60.0f)];
    tipsLabel.text = @"暂无求租求购记录\n马上发布吧！";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    tipsLabel.numberOfLines = 2;
    [self.view addSubview:tipsLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///求购按钮
    buttonStyle.title = @"求购";
    UIButton *askSaleButton = [UIButton createBlockButtonWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 15.0f, (SIZE_DEFAULT_MAX_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入求购过滤设置页面
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeMyZoneAskSecondHouse];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }];
    [self.view addSubview:askSaleButton];
    
    ///求租按钮
    buttonStyle.title = @"求租";
    UIButton *askRentButton = [UIButton createBlockButtonWithFrame:CGRectMake(askSaleButton.frame.origin.x + askSaleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, askSaleButton.frame.origin.y, askSaleButton.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入求购过滤设置页面
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeMyZoneAskRentHouse];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }];
    [self.view addSubview:askRentButton];

}

@end
