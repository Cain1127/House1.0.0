//
//  QSWDeveloperActivityDetailViewController.m
//  House
//
//  Created by 王树朋 on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperActivityDetailViewController.h"

#import "QSDeveloperActivityDetailListReturnData.h"
#import "QSDeveloperActivityDetailDataModel.h"

#import "QSWDeveloperActivityDetailTableViewCell.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char TableViewKey; //!<活动列表

@interface QSWDeveloperActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy) NSString *activityID;        //!<活动ID
@property(nonatomic,copy) NSString *title;             //!<活动主题
@property(nonatomic,copy) NSString *content;           //!<活动内容
@property(nonatomic,copy) NSString *status;            //!<活动状态
@property(nonatomic,copy) NSString *number;            //!<报名人数
@property(nonatomic,copy) NSString *image;             //!<活动图片

@property (nonatomic,retain)  QSDeveloperActivityDetailListDataModel *activityDetailListModel;                          //!<活动列表
@property (nonatomic,retain)  QSDeveloperActivityDetailDataModel *activityDetailDataModel;                          //!<活动详情基本数据

@property (nonatomic,strong) UIView *headerView;       //!<头部VIEW

@end

@implementation QSWDeveloperActivityDetailViewController

-(instancetype)initWithTitle:(NSString *)title andConnet:(NSString *)content andStatus:(NSString *)status andSignUpNum:(NSString *)number andImage:(NSString *)image andactivityID:(NSString *)activityID
{

    if (self = [super init]) {
        
        self.activityID = activityID;
        self.title = title;
        self.content = content;
        self.status = status;
        self.number = number;
        self.image = image;

    }

    return self;
}

-(void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.title ? self.title : @"活动详情"];

}

-(void)createMainShowUI
{

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f) style:UITableViewStyleGrouped];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    objc_setAssociatedObject(self, &TableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);
    
    [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getDeveloperActivityDetailInfo)];
    
    [tableView.header beginRefreshing];
    tableView.delegate = self;
    tableView.dataSource = self;

}

#pragma mark -数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.activityDetailListModel.records count];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0f;

}

#pragma mark -返回的每一行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"normalCell";
    QSWDeveloperActivityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[QSWDeveloperActivityDetailTableViewCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 80.0f)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    self.activityDetailDataModel=[[QSDeveloperActivityDetailDataModel alloc] init];
    if ( 0 < self.activityDetailListModel.records.count) {
        
        self.activityDetailDataModel = self.activityDetailListModel.records[indexPath.row];
       
    }
    ///更新数据
    [cell updateActivityDetailModel:self.activityDetailDataModel];
    return  cell;


}


#pragma mark -代理方法
///头部view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 225.0f)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    ///头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    headerImageView.center = CGPointMake(_headerView.frame.size.width/2.0f, 70.0f);
    headerImageView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_100];
    
    ///头像白色背景
    UIImageView *sixImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, headerImageView.frame.size.width, headerImageView.frame.size.height)];
    sixImageView.image = [UIImage imageNamed:@"public_sixform_hollow_100x80"];
    
    [headerImageView addSubview:sixImageView];
    [_headerView addSubview:headerImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 20.0f)];
    titleLabel.center = CGPointMake(SIZE_DEVICE_WIDTH/2.0f, headerImageView.frame.origin.y+headerImageView.frame.size.height+10.0f+10.0f);
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    [_headerView addSubview:titleLabel];
    
    UILabel *commentLibel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height+10.0f, SIZE_DEVICE_WIDTH, 15.0f)];
    commentLibel.font = [UIFont systemFontOfSize:14.0f];
    commentLibel.textAlignment = NSTextAlignmentCenter;
    commentLibel.text = self.content;
    commentLibel.textColor = COLOR_CHARACTERS_GRAY;
    [_headerView addSubview:commentLibel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, commentLibel.frame.origin.y+commentLibel.frame.size.height+10.0f, 60.0f, 20.0f)];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    statusLabel.font = [UIFont systemFontOfSize:18.0f];
    statusLabel.text = @"状态:";
    [_headerView addSubview:statusLabel];
    
    UILabel *statusResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabel.frame.origin.x+statusLabel.frame.size.width, statusLabel.frame.origin.y, 60.0f, 20.0f)];
    statusResultLabel.textAlignment = NSTextAlignmentLeft;
    statusResultLabel.textColor = COLOR_CHARACTERS_YELLOW;
    statusResultLabel.font = [UIFont systemFontOfSize:18.0f];
    statusResultLabel.text = self.status;
    [_headerView addSubview:statusResultLabel];
    
    UILabel *signUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-35.0f-125.0f, statusResultLabel.frame.origin.y+2.5f, 75.0f, 15.0f)];
    signUpLabel.text = @"报名人数:";
    signUpLabel.textAlignment = NSTextAlignmentRight;
    signUpLabel.font = [UIFont systemFontOfSize:14.0f];
    [_headerView addSubview:signUpLabel];
    
    UILabel *signUpCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(signUpLabel.frame.origin.x+signUpLabel.frame.size.width, statusResultLabel.frame.origin.y, 45.0f, 20.0f)];
    signUpCountLabel.textAlignment = NSTextAlignmentCenter;
    signUpCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    signUpCountLabel.font = [UIFont systemFontOfSize:18.0f];
    signUpCountLabel.text = self.number ;
    [_headerView addSubview:signUpCountLabel];
    
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, _headerView.frame.size.height-0.25f, SIZE_DEVICE_WIDTH, 0.25f)];
    bottomLineLabel.textColor = COLOR_CHARACTERS_GRAY;
    [_headerView addSubview:bottomLineLabel];
    
    return _headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 225.0f;

}

#pragma mark -网络返回数据
-(void)getDeveloperActivityDetailInfo
{

    UITableView *tableView = objc_getAssociatedObject(self, &TableViewKey);
    NSDictionary *params = @{
                             @"activity_id" : APPLICATION_NSSTRING_SETTING(self.activityID, @""),
                             @"page_num" : @"10",
                             @"now_page" : @"1",
                             @"key" : @""
                             };
    
    [QSRequestManager requestDataWithType:rRequestTypeDeveloperActivityDetailList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode)
     {
         
         if (rRequestResultTypeSuccess == resultStatus) {
             
             QSDeveloperActivityDetailListReturnData *returnData = resultData;
             self.activityDetailListModel = returnData.msg;
             [tableView reloadData];
             
             ///判断是否有数据
             if ([self.activityDetailListModel.records count] > 0) {
                 
                 [self showNoRecordTips:NO];
                 self.headerView.hidden = NO;
                 
             } else {
             
                 [self showNoRecordTips:YES andTips:@"暂无活动详情"];
                 self.headerView.hidden = YES;
                 
             }
             
         } else {
         
             self.activityDetailListModel = nil;
             [tableView reloadData];
             self.headerView.hidden = YES;
             [self showNoRecordTips:YES andTips:@"暂无活动详情"];
         
         }
         
         [tableView.header endRefreshing];
         
     }];

}
@end
