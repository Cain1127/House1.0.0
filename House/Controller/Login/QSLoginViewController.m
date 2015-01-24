//
//  QSLoginViewController.m
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSLoginViewController.h"
#import "QSCoreDataManager+User.h"
#import "UITextField+CustomField.h"

@interface QSLoginViewController ()

@end

@implementation QSLoginViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///设置标题
    [self setNavigationBarTitle:@"登录"];

}

- (void)createMainShowUI
{
    
    ///底view方便弹出键盘时，向上滚动
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    rootView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rootView];

    ///手机
    UITextField *phoneField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andPlaceHolder:@"输入您的用户名" andLeftTipsInfo:@"手机号：" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    [rootView addSubview:phoneField];
    
    ///密码
    
    
    ///验证码
    
    
    ///登录
    
    
    ///普通用户注册
    
    
    ///忘记密码

}

@end
