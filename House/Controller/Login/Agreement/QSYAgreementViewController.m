//
//  QSYAgreementViewController.m
//  House
//
//  Created by ysmeng on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAgreementViewController.h"

@interface QSYAgreementViewController ()

@end

@implementation QSYAgreementViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"使用协议"];

}

- (void)createMainShowUI
{

    UITextView *agreementField = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    agreementField.showsHorizontalScrollIndicator = NO;
    agreementField.showsVerticalScrollIndicator = NO;
    agreementField.backgroundColor = [UIColor whiteColor];
    agreementField.text = @"房当家使用协议";
    agreementField.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.view addSubview:agreementField];

}

@end
