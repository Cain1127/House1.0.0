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

#import "MJRefresh.h"
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
        
        button.selected = YES;
        overButton.selected = NO;
        
        onlineActivityView = [[UITableView alloc] initWithFrame:CGRectMake(-SIZE_DEVICE_WIDTH, 104.0f, SIZE_DEVICE_WIDTH-70.0f, SIZE_DEVICE_HEIGHT-104.0f)];
        onlineActivityView.delegate = self;
        onlineActivityView.dataSource = self;
        onlineActivityView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:onlineActivityView];
        onlineActivityView.showsVerticalScrollIndicator = NO;
        onlineActivityView.showsHorizontalScrollIndicator = NO;
        
        [UITableView animateWithDuration:0.3 animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x+button.frame.size.width/2.0f-7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            overActivityView.frame = CGRectMake(SIZE_DEVICE_WIDTH, overActivityView.frame.origin.y, overActivityView.frame.size.width, overActivityView.frame.size.height);
            
            onlineActivityView.frame = CGRectMake(35.0f, onlineActivityView.frame.origin.y, onlineActivityView.frame.size.width, onlineActivityView.frame.size.height);
            
            
        } completion:^(BOOL finished) {
            
            [overActivityView removeFromSuperview];
            overActivityView = nil;
            
        }];
        
        
    }];
    onlineButton.selected =YES;
    [self.view addSubview:onlineButton];
    
    buttonStyle.title = @"结束活动";
    overButton = [UIButton createBlockButtonWithFrame:CGRectMake(onlineButton.frame.origin.x+onlineButton.frame.size.width, onlineButton.frame.origin.y, onlineButton.frame.size.width, onlineButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        NSLog(@"点击结束活动");
        if (button.selected) {
            
            return ;
            
        }
        button.selected = YES;
        onlineButton.selected = NO;
        
        overActivityView = [[UITableView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, 104.0f, SIZE_DEVICE_WIDTH-70.0f, SIZE_DEVICE_HEIGHT-104.0f)];
        overActivityView.backgroundColor = [UIColor whiteColor];
        overActivityView.delegate = self;
        overActivityView.dataSource = self;
        overActivityView.showsHorizontalScrollIndicator = NO;
        overActivityView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:overActivityView];
        objc_setAssociatedObject(self, &OverActivityViewKey, overActivityView, OBJC_ASSOCIATION_ASSIGN);
        
        [UITableView animateWithDuration:0.3 animations:^{
            arrowIndicator.frame = CGRectMake(button.frame.origin.x+button.frame.size.width/2.0f-7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
            onlineActivityView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, onlineActivityView.frame.origin.y, onlineActivityView.frame.size.width, onlineActivityView.frame.size.height);
            
            overActivityView.frame = CGRectMake(35.0f, overActivityView.frame.origin.y, overActivityView.frame.size.width, overActivityView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [onlineActivityView removeFromSuperview];
            onlineActivityView = nil;
            
        }];
        
        
        
    }];
    [self.view addSubview:overButton];
    
    onlineActivityView = [[UITableView alloc] initWithFrame:CGRectMake(35.0f, onlineButton.frame.origin.y+onlineButton.frame.size.height, SIZE_DEVICE_WIDTH-70.0f, SIZE_DEVICE_HEIGHT-64.0f-40.0f)];
    onlineActivityView.delegate = self;
    onlineActivityView.dataSource = self;
    onlineActivityView.showsHorizontalScrollIndicator = NO;
    onlineActivityView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:onlineActivityView];
    objc_setAssociatedObject(self, &OnlineActivityViewKey, onlineActivityView, OBJC_ASSOCIATION_ASSIGN);
    [onlineActivityView  addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getOnlineInfo)];
    
    [onlineActivityView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getOnlineMoreInfo)];
    onlineActivityView.footer.hidden = YES;
    
    [onlineActivityView.header beginRefreshing];
    
    
    
    ///指示三角
    arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(onlineButton.frame.origin.x+onlineButton.frame.size.width / 2.0f - 7.5f, onlineButton.frame.origin.y + onlineButton.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowIndicator];
    
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

#pragma mark -返回列表的每一行
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

#pragma mark -点击每行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{



}

#pragma mark -网络数据请求
///当前活动数据请求
-(void)getOnlineInfo
{

    UITableView *onlineView = objc_getAssociatedObject(self, &OnlineActivityViewKey);
    [onlineView.header endRefreshing];

}
///脚部刷新
-(void)getOnlineMoreInfo
{

    UITableView *onlineView = objc_getAssociatedObject(self, &OnlineActivityViewKey);
    [onlineView.footer endRefreshing];
}
@end
