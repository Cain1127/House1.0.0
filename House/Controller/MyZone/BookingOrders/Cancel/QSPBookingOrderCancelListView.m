//
//  QSPBookingOrderCancelListView.m
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPBookingOrderCancelListView.h"
#import "QSPBookingOrderListsTableViewCell.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char CancelListTableViewKey;       //!<已取消列表关联
static char CancelListNoDataViewKey;      //!<已取消列表无数据关联

@interface QSPBookingOrderCancelListView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) USER_COUNT_TYPE userType;                  //!<用户类型

@property (nonatomic,retain) NSMutableArray *cancelListDataSource; //!待看房列表数据源

@end

@implementation QSPBookingOrderCancelListView

@synthesize parentViewController;

- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType
{
    
    if (self = [super initWithFrame:frame]) {
        
        ///初始化
        self.cancelListDataSource = [NSMutableArray arrayWithCapacity:0];
        
        ///UI搭建
        [self createBookingListUI];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建

- (void)createBookingListUI
{
    
    ///订单记录列表
    UITableView *cancelListTableView = [[UITableView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, 0.0f, MY_ZONE_ORDER_LIST_CELL_WIDTH, self.frame.size.height)];
    
    ///取消滚动条
    cancelListTableView.showsHorizontalScrollIndicator = NO;
    cancelListTableView.showsVerticalScrollIndicator = NO;
    
    ///数据源
    cancelListTableView.dataSource = self;
    cancelListTableView.delegate = self;
    
    ///取消选择状态
    cancelListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:cancelListTableView];
    
    objc_setAssociatedObject(self, &CancelListTableViewKey, cancelListTableView, OBJC_ASSOCIATION_ASSIGN);
    
    ///没有数据时显示
    UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, cancelListTableView.frame.size.width, 0)];
    
    UIImageView *nodataImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_ZONE_COMMUNITY_NODATA_CION]];
    [nodataImgView setFrame:CGRectMake((noDataView.frame.size.width-75.0f)/2.0f, 0, 75.f, 85.f)];
    [noDataView addSubview:nodataImgView];
    
    QSLabel *nodataTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, nodataImgView.frame.origin.y+nodataImgView.frame.size.height, noDataView.frame.size.width, 30)];
    [nodataTipLabel setTextAlignment:NSTextAlignmentCenter];
    [nodataTipLabel setText:TITLE_MYZONE_CANCEL_ORDER_NODATA_TIP];
    objc_setAssociatedObject(self, &CancelListNoDataViewKey, noDataView, OBJC_ASSOCIATION_ASSIGN);
    [noDataView addSubview:nodataTipLabel];
    
    CGFloat noDataViewHeight = nodataTipLabel.frame.origin.y+nodataTipLabel.frame.size.height;
    [noDataView setFrame:CGRectMake(noDataView.frame.origin.x, (cancelListTableView.frame.size.height-noDataViewHeight)/2, noDataView.frame.size.width, noDataViewHeight)];
    
    [cancelListTableView addSubview:noDataView];
    [noDataView setHidden:YES];
    
    ///添加刷新事件
    [cancelListTableView addHeaderWithTarget:self action:@selector(getBookingListHeaderData)];
    [cancelListTableView addFooterWithTarget:self  action:@selector(getBookingListFooterData)];
    
    ///一开始就请求数据
    [cancelListTableView headerBeginRefreshing];
    
}

#pragma mark - 数据请求
///数据请求
- (void)getBookingListHeaderData
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        [self endRefreshAnimination];
        
    });
    
}

- (void)getBookingListFooterData
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self endRefreshAnimination];
        
    });
    
}

#pragma mark - 结束刷新动画
///结束刷新动画
- (void)endRefreshAnimination
{
    
    UITableView *tableView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
    
    [self reloadData];
}

#pragma mark - 刷新数据
///刷新数据
- (void)reloadData
{
    
    UITableView *tableView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    [tableView reloadData];
    
    //没有数据时
    if ([_cancelListDataSource count]==0) {
        UIView *nodataView = objc_getAssociatedObject(self, &CancelListNoDataViewKey);
        if (nodataView) {
            [nodataView setHidden:NO];
        }
    }
    
}

#pragma mark - 返回每一个订单记录cell内容项
///返回每一个订单记录cell内容项
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///复用标签
    static NSString *BookingOrderListsTableViewCellName = @"BookingOrderListsTableViewCell";
    
    ///从复用队列中获取cell
    QSPBookingOrderListsTableViewCell *cellSystem = [tableView dequeueReusableCellWithIdentifier:BookingOrderListsTableViewCellName];
    
    ///判断是否需要重新创建
    if (nil == cellSystem) {
        
        cellSystem = [[QSPBookingOrderListsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BookingOrderListsTableViewCellName];
        
        ///取消选择状态
        cellSystem.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellSystem setParentViewController:parentViewController];
        
    }
    
    [cellSystem updateCellWith:[_cancelListDataSource objectAtIndex:indexPath.row]];
    
    return cellSystem;
    
}

#pragma mark - 返回一共有多少条订单记录
///返回一共有多少条订单记录
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_cancelListDataSource count];
    
}

#pragma mark - 返回每一条订单记录显示cell的高度
///返回每一条订单记录显示cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return MY_ZONE_ORDER_LIST_CELL_HEIGHT;
    
}

#pragma mark - 响应点击订单操作
///响应点击订单操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cancelList didSelectRowAtIndexPath:%d",indexPath.row);
}

@end
