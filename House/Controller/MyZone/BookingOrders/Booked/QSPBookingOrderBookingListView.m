//
//  QSPBookingOrderBookingListView.m
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPBookingOrderBookingListView.h"
#import "QSPBookingOrderListsTableViewCell.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char BookingListTableViewKey;    //!<待看房列表关联
static char BookingListNoDataViewKey;   //!<待看房列表无数据关联

@interface QSPBookingOrderBookingListView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) USER_COUNT_TYPE userType;                  //!<用户类型

@property (nonatomic,retain) NSMutableArray *bookingListDataSource; //!待看房列表数据源

@end

@implementation QSPBookingOrderBookingListView

- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType
{
    
    if (self = [super initWithFrame:frame]) {
        
        ///初始化
        self.bookingListDataSource = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
        
        ///UI搭建
        [self createBookingListUI];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建

- (void)createBookingListUI
{
    
    ///间隙
    CGFloat gap = SIZE_DEVICE_WIDTH > 320.0f ? 25.0f : 15.0f;
    
    ///订单记录列表
    UITableView *bookingListTableView = [[UITableView alloc] initWithFrame:CGRectMake(gap, 0.0f, self.frame.size.width - 2.0f * gap, self.frame.size.height)];
    
    ///取消滚动条
    bookingListTableView.showsHorizontalScrollIndicator = NO;
    bookingListTableView.showsVerticalScrollIndicator = NO;
    
    ///数据源
    bookingListTableView.dataSource = self;
    bookingListTableView.delegate = self;
    
    ///取消选择状态
    bookingListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:bookingListTableView];
    
    objc_setAssociatedObject(self, &BookingListTableViewKey, bookingListTableView, OBJC_ASSOCIATION_ASSIGN);
    
    ///没有数据时显示
    UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, bookingListTableView.frame.size.width, 0)];
    
    UIImageView *nodataImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_ZONE_COMMUNITY_NODATA_CION]];
    [nodataImgView setFrame:CGRectMake((noDataView.frame.size.width-(150.f/750.f * SIZE_DEVICE_WIDTH))/2, 0, 150.f/750.f * SIZE_DEVICE_WIDTH, 170.f/1332.f*SIZE_DEVICE_HEIGHT)];
    [noDataView addSubview:nodataImgView];
    
    QSLabel *nodataTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, nodataImgView.frame.origin.y+nodataImgView.frame.size.height, noDataView.frame.size.width, 30)];
    [nodataTipLabel setTextAlignment:NSTextAlignmentCenter];
    [nodataTipLabel setText:TITLE_MYZONE_BOOKING_ORDER_NODATA_TIP];
    objc_setAssociatedObject(self, &BookingListNoDataViewKey, noDataView, OBJC_ASSOCIATION_ASSIGN);
    [noDataView addSubview:nodataTipLabel];
    
    [noDataView setFrame:CGRectMake(noDataView.frame.origin.x, noDataView.frame.origin.y, noDataView.frame.size.width, nodataTipLabel.frame.origin.y+nodataTipLabel.frame.size.height)];
    
    [bookingListTableView addSubview:noDataView];
    [bookingListTableView setBackgroundColor:[UIColor yellowColor]];
    [noDataView setHidden:YES];
    
    ///添加刷新事件
    [bookingListTableView addHeaderWithTarget:self action:@selector(getBookingListHeaderData)];
    [bookingListTableView addFooterWithTarget:self  action:@selector(getBookingListFooterData)];
    
    ///一开始就请求数据
    [bookingListTableView headerBeginRefreshing];
    
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
    
    UITableView *tableView = objc_getAssociatedObject(self, &BookingListTableViewKey);
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
    
    [self reloadData];
}

#pragma mark - 刷新数据
///刷新数据
- (void)reloadData
{
    
    UITableView *tableView = objc_getAssociatedObject(self, &BookingListTableViewKey);
    [tableView reloadData];
    
    //没有数据时
    UIView *nodataView = objc_getAssociatedObject(self, &BookingListNoDataViewKey);
    [nodataView setHidden:NO];
    
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
        
    }
    
    [cellSystem.textLabel setText:[_bookingListDataSource objectAtIndex:indexPath.row]];
    
    return cellSystem;
    
}

#pragma mark - 返回一共有多少条订单记录
///返回一共有多少条订单记录
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_bookingListDataSource count];
    
}

#pragma mark - 返回每一条订单记录显示cell的高度
///返回每一条订单记录显示cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 115.0f;
    
}

@end
