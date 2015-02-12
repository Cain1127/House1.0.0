//
//  QSHouseDetailViewController.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseDetailViewController.h"
#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char RootTableViewKey;//!<底view的关联key

@interface QSHouseDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *title;                 //!<标题
@property (nonatomic,copy) NSString *detailID;              //!<详情的ID
@property (nonatomic,assign) FILTER_MAIN_TYPE detailType;   //!<详情的类型

@end

@implementation QSHouseDetailViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-02-12 12:02:39
 *
 *  @brief              根据标题、ID创建详情页面，可以是房子详情，或者小区详情
 *
 *  @param title        标题
 *  @param detailID     详情的ID
 *  @param detailType   详情的类型：房子/小区等
 *
 *  @return             返回当前创建的详情页指针
 *
 *  @since              1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andDetailID:(NSString *)detailID andDetailType:(FILTER_MAIN_TYPE)detailType
{

    if (self = [super init]) {
        
        ///保存相关参数
        self.title = title;
        self.detailID = detailID;
        self.detailType = detailType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///重写导航栏，添加标题信息
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:(self.title ? self.title : @"详情")];

}

///主展示信息
- (void)createMainShowUI
{

    ///所有信息放在一个TabelView上
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) style:UITableViewStyleGrouped];
    
    ///取消滚动条
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    
    ///透明背影
    tableView.backgroundColor = [UIColor clearColor];
    
    ///取消分隔状态
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///设置数据源和代理
    tableView.dataSource = self;
    tableView.delegate = self;
    
    ///添加头部刷新
    [tableView addHeaderWithTarget:self action:@selector(getDetailInfo)];
    [tableView headerBeginRefreshing];
    
    [self.view addSubview:tableView];
    objc_setAssociatedObject(self, &RootTableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);

}

#pragma mark - 结束刷新动画
///结束刷新动画
- (void)endRefreshAnimination
{

    UITableView *tableView = objc_getAssociatedObject(self, &RootTableViewKey);
    [tableView headerEndRefreshing];

}

#pragma mark - 请求详情信息
/**
 *  @author yangshengmeng, 15-02-12 14:02:44
 *
 *  @brief  请求详情信息
 *
 *  @since  1.0.0
 */
- (void)getDetailInfo
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self endRefreshAnimination];
        
    });

}

#pragma mark - 返回有多少个区
///返回有多少个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

#pragma mark - 返回有多少行
///返回有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;

}

#pragma mark - 返回行高
///返回行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44.0f;

}

#pragma mark - 返回每一行的cell
///返回每一行的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *normalCell = @"normalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
    
    if (nil == cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        
    }
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;

}

#pragma mark - 是否显示活动
///活动栏的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 44.0f;

}

///活动信息view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    static NSString *headerViewName = @"headerView";
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewName];
    
    if (nil == headerView) {
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 44.0f)];
        
    }
    
    headerView.backgroundColor = [UIColor orangeColor];
    
    return headerView;

}

@end
