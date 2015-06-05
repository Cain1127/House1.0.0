//
//  QSWDeveloperBuildingsViewController.m
//  House
//
//  Created by 王树朋 on 15/4/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperBuildingsViewController.h"

#import "QSNewHouseListReturnData.h"
#import "QSNewHouseInfoDataModel.h"

#import "QSWDeveloperBuildingsTableViewCell.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

#define SIZE_MARGIN_LEFT_RIGHT ([[UIScreen mainScreen] bounds].size.width >= 375.0f ? 35.0f : 25.0f)


static char TableViewKey;   //!<楼盘列表

@interface QSWDeveloperBuildingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSArray *houseListArray;       //!<楼盘列表
@property (nonatomic,retain) QSNewHouseInfoDataModel *houseModel;  //!<楼盘数据

@end

@implementation QSWDeveloperBuildingsViewController

-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"我的楼盘"];
    
}

-(void)createMainShowUI
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    objc_setAssociatedObject(self, &TableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);
    
    [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getBuildingsInfo)];
    [tableView.header beginRefreshing];
    
}

#pragma mark -数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.houseListArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 225.0f;
    
}

#pragma mark -返回的第一行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"normalCell";
    QSWDeveloperBuildingsTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        
        cell = [[QSWDeveloperBuildingsTableViewCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 225.0f)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    self.houseModel = self.houseListArray[indexPath.row];
    
    [cell updateDeveloperBulidingsModel:self.houseModel andCallBack:^(DEVELOPER_BUILDINGS_BUTTON_ACTION_TYPE actionType) {
        switch (actionType) {
            case dDeveloperBuildingsActionTypeHeaderImage:
                
                NSLog(@"跳转楼盘详情");
                
                break;
                
            case dDeveloperBuildingsActionTypeSignUp:
                
                NSLog(@"活动报名");
                
                break;
                
            case dDeveloperBuildingsActionTypeStopPublish:
                
                NSLog(@"停止发布");
                
                break;
                
            default:
                break;
        }
        
    }
     ];
    
    return cell;
}

#pragma mark -网络请求
-(void)getBuildingsInfo
{
    
    UITableView *tableView = objc_getAssociatedObject(self, &TableViewKey);
    
    
    [QSRequestManager requestDataWithType:rRequestTypeNewHouse andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSNewHouseListReturnData *returnData = resultData;
            QSNewHouseListHeaderData *headerList = returnData.headerData;
            self.houseListArray = headerList.houseList;
            
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [tableView reloadData];
            
            [tableView.header endRefreshing];
            
        });
    }
     
     ];
    
}


@end
