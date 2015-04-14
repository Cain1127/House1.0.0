//
//  QSWDeveloperActivityViewController.m
//  House
//
//  Created by 王树朋 on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperActivityViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSWDeveloperActivityTableViewCell.h"

#import <objc/runtime.h>

///关联
static char OnlineActivityViewKey; //!<在线活动关联列表
static char OverActivityViewKey;   //!<活动结束关联列表

@interface QSWDeveloperActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation QSWDeveloperActivityViewController

-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"活动"];

}

-(void)createMainShowUI
{
    ///列表指针
    __block UITableView *onlineActivityView;
    __block UITableView *overActivityView;
    
    ///指示三角指针
    __block UIImageView *arrowIndicator;
    
    ///导航按钮指针
    __block UIButton *onlineButton;
    __block UIButton *overButton;
    
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClear];
                                            
    buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:18.0f];
    buttonStyle.title = @"当前活动";
    
    onlineButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH/2.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        NSLog(@"点击当前活动");
        
        if (button.selected) {
            return ;
        }
        
        
    }];
    [self.view addSubview:onlineButton];
    
    buttonStyle.title = @"结束活动";
    overButton = [UIButton createBlockButtonWithFrame:CGRectMake(onlineButton.frame.origin.x+onlineButton.frame.size.width, onlineButton.frame.origin.y, onlineButton.frame.size.width, onlineButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        NSLog(@"点击结束活动");
        if (button.selected) {
            return ;
        }
        
        
    }];
    [self.view addSubview:overButton];
    
    onlineActivityView = [[UITableView alloc] initWithFrame:CGRectMake(35.0f, onlineButton.frame.origin.y+onlineButton.frame.size.height, SIZE_DEVICE_WIDTH-70.0f, SIZE_DEVICE_HEIGHT-64.0f-40.0f)];
    onlineActivityView.delegate = self;
    onlineActivityView.dataSource = self;
    
    [self.view addSubview:onlineActivityView];
    objc_setAssociatedObject(self, &OnlineActivityViewKey, onlineActivityView, OBJC_ASSOCIATION_ASSIGN);
    
}

#pragma mark -数据源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0f;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 20;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"normalInfoCell";
    QSWDeveloperActivityTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[QSWDeveloperActivityTableViewCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH-70.0f, 80.0f)];
        
    }

    ///更新数据
    [cell updateDeveloperActivityModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
