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

#pragma mark -添加导航栏
-(void)createNavigationBarUI
{
  
    [super createNavigationBarUI];
    
    ///设置导航栏标题
    [self setNavigationBarTitle:@"活动"];
    
}

#pragma mark -添加中间视图
-(void)createMainShowUI
{
    
    [super createMainShowUI];
  
}


#pragma mark -UITableView代理方法
///返回一组数据
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 1;
    
}

///返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}

///返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

#pragma mark -返回每一行的活动
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *indentifier=@"cellidentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }

    return cell;
}

///UITableView头部事件
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

///每行的点击事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
