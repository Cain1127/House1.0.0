//
//  QSWDeveloperActivityDetailViewController.m
//  House
//
//  Created by 王树朋 on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperActivityDetailViewController.h"

#import "QSWDeveloperActivityDetailTableViewCell.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char TableViewKey; //!<活动列表

@interface QSWDeveloperActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *number;
@property(nonatomic,copy) NSString *image;


@end

@implementation QSWDeveloperActivityDetailViewController

-(instancetype)initWithTitle:(NSString *)title andConnet:(NSString *)content andStatus:(NSString *)status andSignUpNum:(NSString *)number andImage:(NSString *)image
{

    if (self = [super init]) {
        
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
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    objc_setAssociatedObject(self, &TableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);
    
    [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getActivityInfo)];
    
    [tableView.header beginRefreshing];

}

#pragma mark -数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 10;

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
    
    ///更新数据
    [cell updateActivityDetailModel];
    
    return  cell;


}


#pragma mark -代理方法
///头部view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 225.0f)];
    headerView.backgroundColor = [UIColor whiteColor];
    ///头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    headerImageView.center = CGPointMake(headerView.frame.size.width/2.0f, 70.0f);
    headerImageView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_100];
    
    ///头像白色背景
    UIImageView *sixImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, headerImageView.frame.size.width, headerImageView.frame.size.height)];
    sixImageView.image = [UIImage imageNamed:@"public_sixform_hollow_100x80"];
    
    [headerImageView addSubview:sixImageView];
    [headerView addSubview:headerImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 20.0f)];
    titleLabel.center = CGPointMake(SIZE_DEVICE_WIDTH/2.0f, headerImageView.frame.origin.y+headerImageView.frame.size.height+10.0f+10.0f);
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"江南水乡";
    [headerView addSubview:titleLabel];
    
    UILabel *commentLibel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height+10.0f, SIZE_DEVICE_WIDTH, 15.0f)];
    commentLibel.font = [UIFont systemFontOfSize:14.0f];
    commentLibel.textAlignment = NSTextAlignmentCenter;
    commentLibel.text = @"10月1日江南看房团";
    commentLibel.textColor = COLOR_CHARACTERS_GRAY;
    [headerView addSubview:commentLibel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, commentLibel.frame.origin.y+commentLibel.frame.size.height+10.0f, 60.0f, 20.0f)];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    statusLabel.font = [UIFont systemFontOfSize:18.0f];
    statusLabel.text = @"状态:";
    [headerView addSubview:statusLabel];
    
    UILabel *statusResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabel.frame.origin.x+statusLabel.frame.size.width, statusLabel.frame.origin.y, 60.0f, 20.0f)];
    statusResultLabel.textAlignment = NSTextAlignmentLeft;
    statusResultLabel.textColor = COLOR_CHARACTERS_YELLOW;
    statusResultLabel.font = [UIFont systemFontOfSize:18.0f];
    statusResultLabel.text = @"待看房";
    [headerView addSubview:statusResultLabel];
    
    UILabel *signUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-35.0f-125.0f, statusResultLabel.frame.origin.y+2.5f, 75.0f, 15.0f)];
    signUpLabel.text = @"报名人数:";
    signUpLabel.textAlignment = NSTextAlignmentRight;
    signUpLabel.font = [UIFont systemFontOfSize:14.0f];
    [headerView addSubview:signUpLabel];
    
    UILabel *signUpCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(signUpLabel.frame.origin.x+signUpLabel.frame.size.width, statusResultLabel.frame.origin.y, 45.0f, 20.0f)];
    signUpCountLabel.textAlignment = NSTextAlignmentCenter;
    signUpCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    signUpCountLabel.font = [UIFont systemFontOfSize:18.0f];
    signUpCountLabel.text = @"10" ;
    [headerView addSubview:signUpCountLabel];
    
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, headerView.frame.size.height-0.25f, SIZE_DEVICE_WIDTH, 0.25f)];
    bottomLineLabel.textColor = COLOR_CHARACTERS_GRAY;
    [headerView addSubview:bottomLineLabel];
    
    return headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 225.0f;

}

#pragma mark -网络返回数据
-(void)getActivityInfo
{

    UITableView *tableView = objc_getAssociatedObject(self, &TableViewKey);
    [tableView.header endRefreshing];

}
@end
