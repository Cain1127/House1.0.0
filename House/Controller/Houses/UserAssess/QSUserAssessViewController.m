//
//  QSUserAssessViewController.m
//  House
//
//  Created by 王树朋 on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserAssessViewController.h"
#import "DeviceSizeHeader.h"
#import "QSUserAssessCell.h"

#import "QSCommentListReturnData.h"
#import "QSCommentListDataModel.h"

#import "QSHouseCommentDataModel.h"

#import "MJRefresh.h"
#include <objc/runtime.h>

static char AssessTableKey;   //!<评论内容关联key

#define SIZE_DEFAULT_MARGIN_TAP (SIZE_DEVICE_WIDTH > 320.0f ? 30.0f : 20.0f)

@interface QSUserAssessViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSArray *dataSource;                         //!<数据源
@property (nonatomic,retain) QSCommentListDataModel *commentDataModel;    //!<模型数据
@property (nonatomic,copy) NSString *type ;                                //!<房源类型
@property (nonatomic,assign) int be_id;                                    //!<被评论的ID，如果是房源就填房源ID

@end

@implementation QSUserAssessViewController

-(instancetype)initWithType:(NSString *)type andID:(int )be_id
{

    if (self=[super init]) {
        
        self.type=type;
        self.be_id=be_id;
    }

    return self;
}

-(void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:@"用户评价"];

}

-(void)createMainShowUI
{
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_TAP, 15.0f, SIZE_DEVICE_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_TAP, SIZE_DEVICE_HEIGHT-64.0f)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    objc_setAssociatedObject(self, &AssessTableKey, tableView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加刷新
    [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getCommentListInfo)];
    
    ///一开始就头部刷新
    [tableView.header beginRefreshing];
}

#pragma mark - 显示信息UI:网络请求成功后才显示UI
///显示信息UI:网络请求成功后才显示UI
- (void)showInfoUI:(BOOL)flag
{
    
    UITableView *rootView = objc_getAssociatedObject(self, &AssessTableKey);
    
    if (flag) {
        
        rootView.hidden = NO;
        
    } else {
        
        rootView.hidden = YES;
        
    }
    
}

#pragma mark - 数据源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 40.0f+2.0f*SIZE_DEFAULT_MARGIN_TAP;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count ? self.dataSource.count : 10;
    //return 10;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"normalInfoCell";
    
    QSUserAssessCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[QSUserAssessCell alloc] init];
        
    }
    
    ///获取模型
    QSCommentListDataModel *tempModel = self.dataSource[indexPath.row];
    
    [cell updateAssessCellInfo:tempModel];
    
    ///取消选择样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)getCommentListInfo
{

    
    NSString *nbe_id = [NSString stringWithFormat:@"%d",self.be_id];
    ///封装参数
    NSDictionary *params = @{@"key" :@"",
                             @"page_num" : @"10",
                             @"now_page" : @"1",
                             @"order" : @"",
                             @"type " : self.type,
                             @"be_id" : nbe_id
                             };
    
    
    ///进行请求
    [QSRequestManager requestDataWithType:rRequestCommentListDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        UITableView *tableView = objc_getAssociatedObject(self, &AssessTableKey);

        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSCommentListReturnData *tempModel = resultData;
            
            self.dataSource = [[NSArray alloc] init];
            ///保存数据模型
            self.dataSource = tempModel.msgInfo.commentList;
            
            ///创建详情UI
            [tableView reloadData];
            [tableView.header endRefreshing];
            ///1秒后停止动画，并显示界面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self showInfoUI:YES];
                
                
            });
            
        } else {
            
            [tableView.header endRefreshing];
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"获取评论信息失败",1.0f,^(){
                
                ///推回上一页
                //[self.navigationController popViewControllerAnimated:YES];
                
            })
            
        }
        
    }];



}

@end
