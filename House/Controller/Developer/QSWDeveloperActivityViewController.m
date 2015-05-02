//
//  QSWDeveloperActivityViewController.m
//  House
//
//  Created by 王树朋 on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperActivityViewController.h"
#import "QSWDeveloperActivityDetailViewController.h"

#import "QSDeveloperActivityListReturnData.h"
#import "QSDeveloperActivityDataModel.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSWDeveloperActivityTableViewCell.h"

#import "MJRefresh.h"
#import <objc/runtime.h>

///关联
static char OnlineActivityViewKey; //!<在线活动关联列表
static char OverActivityViewKey;   //!<活动结束关联列表

@interface QSWDeveloperActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)  QSDeveloperActivityListDataModel *activityListModel; //!<活动列表
@property (nonatomic,retain)  QSDeveloperActivityDataModel *activityDataModel;     //!<活动基本数据
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
        onlineActivityView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        objc_setAssociatedObject(self, &OnlineActivityViewKey, onlineActivityView, OBJC_ASSOCIATION_ASSIGN);

        [onlineActivityView  addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getOnlineInfo)];
        
        [onlineActivityView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getOnlineMoreInfo)];
        onlineActivityView.footer.hidden = YES;
        
        [onlineActivityView.header beginRefreshing];
        
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
        
        if (button.selected) {
            
            return;
            
        }
        button.selected = YES;
        onlineButton.selected = NO;
        
        overActivityView = [[UITableView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, 104.0f, SIZE_DEVICE_WIDTH-70.0f, SIZE_DEVICE_HEIGHT-104.0f)];
        overActivityView.backgroundColor = [UIColor whiteColor];
        overActivityView.delegate = self;
        overActivityView.dataSource = self;
        overActivityView.showsHorizontalScrollIndicator = NO;
        overActivityView.showsVerticalScrollIndicator = NO;
        overActivityView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:overActivityView];
        objc_setAssociatedObject(self, &OverActivityViewKey, overActivityView, OBJC_ASSOCIATION_ASSIGN);
        
        [overActivityView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getOverInfo)];
        [overActivityView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getOverMoreInfo)];
        overActivityView.footer.hidden = YES;
        
        [overActivityView.header beginRefreshing];
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
    onlineActivityView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:onlineActivityView];
    objc_setAssociatedObject(self, &OnlineActivityViewKey, onlineActivityView, OBJC_ASSOCIATION_ASSIGN);
    [onlineActivityView  addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getOnlineInfo)];
    
    [onlineActivityView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getOnlineMoreInfo)];
//    onlineActivityView.footer.hidden = YES;
    
    [onlineActivityView.header beginRefreshing];
    [onlineActivityView.footer beginRefreshing];
    
    
    
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

    return [self.activityListModel.records count];

}

#pragma mark -返回列表的每一行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"normalInfoCell";
    QSWDeveloperActivityTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[QSWDeveloperActivityTableViewCell alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT+10.0f, 0.0f, SIZE_DEVICE_WIDTH-SIZE_DEFAULT_MARGIN_LEFT_RIGHT-20.0f, 80.0f)];
        
    }

    self.activityDataModel = [[QSDeveloperActivityDataModel alloc] init];
    if (0<self.activityListModel.records.count) {
        
        self.activityDataModel = self.activityListModel.records[indexPath.row];
        
    }
    ///更新数据
    [cell updateDeveloperActivityModel:self.activityDataModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -点击每行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    QSWDeveloperActivityDetailViewController *VC =[[QSWDeveloperActivityDetailViewController alloc] initWithTitle:self.activityDataModel.title andConnet:self.activityDataModel.content andStatus:self.activityDataModel.status andSignUpNum:self.activityDataModel.apply_num andImage:self.activityDataModel.attach_thumb andactivityID:self.activityDataModel.id_];
    
    [self.navigationController pushViewController:VC animated:YES];

}

#pragma mark -网络数据头部刷新请求
///当前活动数据请求
-(void)getOnlineInfo
{

    UITableView *onlineView = objc_getAssociatedObject(self, &OnlineActivityViewKey);
    
    NSDictionary *params = @{@"page_num":@"10",
                             @"now_page":@"1",
                             @"status":@"501001",
                             @"key":@""
                             };
    
    [QSRequestManager requestDataWithType:rRequestTypeDeveloperActivityList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode)
    {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSDeveloperActivityListReturnData *returnData = resultData;
            self.activityListModel = returnData.msg;
            
            [onlineView reloadData];
            
            ///判断是否有数据
            if ([self.activityListModel.records count] > 0) {
                
                [self showNoRecordTips:NO];
                onlineView.footer.hidden = NO;
                if ([returnData.msg.per_page isEqualToString:returnData.msg.next_page]) {
                    
                    [onlineView.footer noticeNoMoreData];
                    
                } else {
                    
                    [onlineView.footer resetNoMoreData];
                    
                }
                
            } else {
                
                [self showNoRecordTips:YES andTips:@"暂无活动"];
                onlineView.footer.hidden = YES;
                
            }
            
            ///判断是否显示脚部刷新
            
        } else {
            
            self.activityListModel = nil;
            [onlineView reloadData];
            [self showNoRecordTips:YES andTips:@"暂无活动"];
            onlineView.footer.hidden = YES;
            
        }
        [onlineView.header endRefreshing];
        
    }];

}

///结束活动数据请求
-(void)getOverInfo
{
    
    UITableView *overView = objc_getAssociatedObject(self, &OverActivityViewKey);
    overView.footer.hidden = YES;
    
    NSDictionary *params = @{@"page_num":@"10",
                             @"now_page":@"1",
                             @"status":@"501002",
                             @"key":@""
                             };
    
    [QSRequestManager requestDataWithType:rRequestTypeDeveloperActivityList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode)
     {
         
         if (rRequestResultTypeSuccess == resultStatus) {
             
             QSDeveloperActivityListReturnData *returnData = resultData;
             self.activityListModel = returnData.msg;
             [overView reloadData];
             
             ///判断是否有数据
             if ([self.activityListModel.records count] > 0) {
                 
                 [self showNoRecordTips:NO];
                 overView.footer.hidden = NO;
                 if ([returnData.msg.per_page isEqualToString:returnData.msg.next_page]) {
                     
                     [overView.footer noticeNoMoreData];
                     
                 } else {
                 
                     [overView.footer resetNoMoreData];
                 
                 }
                 
             } else {
                 
                 [self showNoRecordTips:YES andTips:@"暂无活动"];
                 overView.footer.hidden = YES;
                 
             }
             
             ///判断是否显示脚部刷新
             
         } else {
             
             self.activityListModel = nil;
             [overView reloadData];
             [self showNoRecordTips:YES andTips:@"暂无活动"];
             overView.footer.hidden = YES;
             
         }
         [overView.header endRefreshing];
         
     }];
    
}

#pragma mark -网络数据脚部刷新请求
///当前活动脚部刷新
-(void)getOnlineMoreInfo
{

    UITableView *onlineView = objc_getAssociatedObject(self, &OnlineActivityViewKey);
    
    ///判断是否最大页码
    if ([self.activityListModel.per_page intValue] == [self.activityListModel.next_page intValue]) {
        
        ///结束刷新动画
        onlineView.footer.hidden = NO;
        [onlineView.footer noticeNoMoreData];
        [onlineView.footer endRefreshing];
        return;
        
    }
    NSDictionary *params = @{@"page_num":@"10",
                             @"status":@"501001",
                             @"key":@""
                             };
    [params setValue:self.activityListModel.next_page forKey:@"now_page"];
    
    [QSRequestManager requestDataWithType:rRequestTypeDeveloperActivityList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode)
     {
         
         if (rRequestResultTypeSuccess == resultStatus) {
             
             QSDeveloperActivityListReturnData *returnData = resultData;
             
             ///判断是否需要刷新数据
             if ([returnData.msg.records count] > 0) {
                 
                 NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.activityListModel.records];
                 self.activityListModel = returnData.msg;
                 
                 ///将新数据添加到原数据之中
                 [tempArray addObjectsFromArray:returnData.msg.records];
                 
                 self.activityListModel.records = [NSArray arrayWithArray:tempArray];
                 
                 ///刷新数据
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     
                     ///刷新数据
                     [onlineView reloadData];
                     
                 });
                 
             }
             
             ///脚部刷新设置
             onlineView.footer.hidden = NO;
             if ([returnData.msg.per_page isEqualToString:returnData.msg.next_page]) {
                 
                 [onlineView.footer noticeNoMoreData];
                 
             } else {
                 
                 [onlineView.footer resetNoMoreData];
                 
             }
             
             [onlineView.footer endRefreshing];
             
         } else {
         
             [onlineView.footer endRefreshing];
         
         }
         
     }];

}

///结束活动脚部刷新
-(void)getOverMoreInfo
{
    
    UITableView *overView = objc_getAssociatedObject(self, &OverActivityViewKey);
    
    ///判断是否最大页码
    if ([self.activityListModel.per_page intValue] == [self.activityListModel.next_page intValue]) {
        
        ///结束刷新动画
        overView.footer.hidden = NO;
        [overView.footer noticeNoMoreData];
        [overView.footer endRefreshing];
        return;
        
    }
    NSDictionary *params = @{@"page_num":@"10",
                             @"status":@"501002",
                             @"key":@""
                             };
    [params setValue:self.activityListModel.next_page forKey:@"now_page"];
    [QSRequestManager requestDataWithType:rRequestTypeDeveloperActivityList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode)
     {
         
         if (rRequestResultTypeSuccess == resultStatus) {
             
             QSDeveloperActivityListReturnData *returnData = resultData;
             
             ///判断是否需要刷新数据
             if ([returnData.msg.records count] > 0) {
                 
                 NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.activityListModel.records];
                 self.activityListModel = returnData.msg;
                 
                 ///将新数据添加到原数据之中
                 [tempArray addObjectsFromArray:returnData.msg.records];
                 
                 self.activityListModel.records = [NSArray arrayWithArray:tempArray];
                 
                 ///刷新数据
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     
                     ///刷新数据
                     [overView reloadData];
                     
                 });
                 
             }
             
             ///脚部刷新设置
             overView.footer.hidden = NO;
             if ([returnData.msg.per_page isEqualToString:returnData.msg.next_page]) {
                 
                 [overView.footer noticeNoMoreData];
                 
             } else {
                 
                 [overView.footer resetNoMoreData];
                 
             }
             
             [overView.footer endRefreshing];
             
         } else {
             
             [overView.footer endRefreshing];
             
         }
         
     }];

}
@end
