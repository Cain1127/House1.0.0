//
//  QSYUserProtocolViewController.m
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYUserProtocolViewController.h"

@interface QSYUserProtocolViewController ()

@end

@implementation QSYUserProtocolViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"服务协议"];
    
}

- (void)createMainShowUI
{
    
    UITextView *agreementField = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    agreementField.showsHorizontalScrollIndicator = NO;
    agreementField.showsVerticalScrollIndicator = NO;
    agreementField.backgroundColor = [UIColor whiteColor];
    agreementField.text = @"房当家用户使用协议";
    agreementField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self.view addSubview:agreementField];
    
}

@end
