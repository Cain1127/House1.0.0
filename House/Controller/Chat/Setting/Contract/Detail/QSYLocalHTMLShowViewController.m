//
//  QSYLocalHTMLShowViewController.m
//  House
//
//  Created by ysmeng on 15/5/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYLocalHTMLShowViewController.h"

@interface QSYLocalHTMLShowViewController ()

@property (nonatomic,copy) NSString *tempTitle;         //!<标题信息
@property (nonatomic,copy) NSString *htmlFileName;      //!<html文件名

@end

@implementation QSYLocalHTMLShowViewController

#pragma mark - 初始化
- (instancetype)initWithTitle:(NSString *)title andLocalHTMLFileName:(NSString *)fileName
{

    if (self = [super init]) {
        
        ///保存参数
        self.tempTitle = APPLICATION_NSSTRING_SETTING(title, @"说明");
        self.htmlFileName = fileName;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.tempTitle];

}

- (void)createMainShowUI
{

    ///如果文件名为空，则不创建
    if ([self.htmlFileName length] <= 0) {
        
        return;
        
    }
    
    ///查找文件
    NSString *filePath = [[NSBundle mainBundle]pathForResource:self.htmlFileName ofType:@"html"];
    if ([filePath length] <= 0) {
        
        return;
        
    }
    
    UIWebView *infoView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    infoView.backgroundColor = [UIColor whiteColor];
    [infoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]];
    [self.view addSubview:infoView];

}

@end
