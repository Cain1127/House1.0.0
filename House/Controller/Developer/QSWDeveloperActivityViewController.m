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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
