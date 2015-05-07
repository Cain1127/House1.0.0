//
//  QSYAboutUsInfoViewController.m
//  House
//
//  Created by ysmeng on 15/5/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAboutUsInfoViewController.h"

@interface QSYAboutUsInfoViewController ()

@end

@implementation QSYAboutUsInfoViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"关于我们"];

}

- (void)createMainShowUI
{

    UIWebView *infoView = [[UIWebView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f, SIZE_DEFAULT_MAX_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    infoView.backgroundColor = [UIColor whiteColor];
    
    [infoView loadHTMLString:@"<p>关于我们：</p><p>房当家</p><p>高度的智能匹配，专属的个人定制，是数百万个人业主和房客租售房屋首选的地方。</p><p>建设一个私密沟通的平台，让业主和房客直接对话，信息透明免骚扰。</p><p>签约代办服务值得信赖，核验、签约、过户、贷款专业顾问帮助你。</p><p>新型交易模式，惠福三方。不用担心各种风险，不用再花费高额中介费，繁琐手续轻松搞定" baseURL:nil];
    
    [self.view addSubview:infoView];

}

@end
