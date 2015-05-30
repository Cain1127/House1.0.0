//
//  QSYSystemAdvertViewController.m
//  House
//
//  Created by ysmeng on 15/5/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSystemAdvertViewController.h"

@interface QSYSystemAdvertViewController ()

@end

@implementation QSYSystemAdvertViewController

- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:([self.advertTitle length] > 0 ? self.advertTitle : @"活动情况")];

}

- (void)createMainShowUI
{

    UIWebView *infoView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    
    if ([self.advertURLString length] <= 0) {
        
        return;
        
    }
    
    [infoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.advertURLString]]];

}

@end
