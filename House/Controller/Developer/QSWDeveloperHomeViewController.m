//
//  QSWDeveloperHomeViewController.m
//  House
//
//  Created by 王树朋 on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperHomeViewController.h"
#import "QSGuideViewController.h"

@interface QSWDeveloperHomeViewController ()

@end

@implementation QSWDeveloperHomeViewController

///添加导航栏
-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    self.navigationItem.title=@"开发商名称";

}

///添加中间view
-(void)createMainShowUI
{
    
    [super createMainShowUI];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -按钮事件
- (IBAction)settingButton:(id)sender {
}


- (IBAction)messageButton:(id)sender {
}
- (IBAction)salingButton:(id)sender {
}

- (IBAction)activeButton:(id)sender {
}
@end
