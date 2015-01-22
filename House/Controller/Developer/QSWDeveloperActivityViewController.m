//
//  QSWDeveloperActivityViewController.m
//  House
//
//  Created by 王树朋 on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperActivityViewController.h"

@interface QSWDeveloperActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation QSWDeveloperActivityViewController

-(void)createNavigationBarUI
{
  
    [super createNavigationBarUI];
    
    ///设置导航栏标题
    [self setNavigationBarTitle:@"活动"];
}


#pragma mark -UITableView代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

///UITableView头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, 40.0f)];
    
    ///添加当前活动按钮与回调点击事件
    UIButton *currentativityButton=[UIButton createBlockButtonWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH * 0.5, 40.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        NSLog(@"当前活动事件");
    }];
    
    ///添加结束活动按钮与回调点击事件
    UIButton *overativityButton=[UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH * 0.5, 0, SIZE_DEVICE_WIDTH * 0.5, 40.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        NSLog(@"结束活动事件");
    }];
    
    [view addSubview:currentativityButton];
    
    [view addSubview:overativityButton];
    
    return view;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
