//
//  QSPTransactionOrderListPendingView.m
//  House
//
//  Created by CoolTea on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPTransactionOrderListPendingView.h"
#import "QSPTransationOrderListsTableViewCell.h"
#import "MJRefresh.h"
#import <objc/runtime.h>
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSPOrderDetailBookedViewController.h"
#import "QSCoreDataManager+User.h"

///关联
static char PendingListTableViewKey;    //!<待成交列表关联
static char PendingListNoDataViewKey;   //!<待成交列表无数据关联

@interface QSPTransactionOrderListPendingView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *pendingListDataSource;     //!待成交列表数据源

@property (nonatomic,strong) NSNumber       *loadNextPage;              //!下一页数据页码

@end

@implementation QSPTransactionOrderListPendingView
@synthesize parentViewController;

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        ///初始化
        self.pendingListDataSource  = [NSMutableArray arrayWithCapacity:0];
        
        ///UI搭建
        [self createPendingListUI];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建

- (void)createPendingListUI
{
    
    ///订单记录列表
    UITableView *pendingListTableView = [[UITableView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, 0.0f, MY_ZONE_ORDER_LIST_CELL_WIDTH, self.frame.size.height)];
    
    ///取消滚动条
    pendingListTableView.showsHorizontalScrollIndicator = NO;
    pendingListTableView.showsVerticalScrollIndicator = NO;
    
    ///数据源
    pendingListTableView.dataSource = self;
    pendingListTableView.delegate = self;
    
    ///取消选择状态
    pendingListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:pendingListTableView];
    
    objc_setAssociatedObject(self, &PendingListTableViewKey, pendingListTableView, OBJC_ASSOCIATION_ASSIGN);
    
    ///没有数据时显示
    UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, pendingListTableView.frame.size.width, 0)];
    
    UIImageView *nodataImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_ZONE_TRANSATION_NODATA_CION]];
    [nodataImgView setFrame:CGRectMake((noDataView.frame.size.width-75.0f)/2.0f, 0, 75.f, 85.f)];
    [noDataView addSubview:nodataImgView];
    
    QSLabel *nodataTipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, nodataImgView.frame.origin.y+nodataImgView.frame.size.height, noDataView.frame.size.width, 30)];
    [nodataTipLabel setTextAlignment:NSTextAlignmentCenter];
    [nodataTipLabel setText:TITLE_MYZONE_TRANSATION_PENDING_ORDER_NODATA_TIP];
    objc_setAssociatedObject(self, &PendingListNoDataViewKey, noDataView, OBJC_ASSOCIATION_ASSIGN);
    [noDataView addSubview:nodataTipLabel];
    
    ///按钮的宽度
    CGFloat width = (noDataView.frame.size.width - 35.0f * 2.0f - 8.0f) / 2.0f;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_18];
    buttonStyle.title = @"看看二手房";
    
    ///出售物业按钮
    UIButton *secondHandHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(35.0f, nodataTipLabel.frame.origin.y + nodataTipLabel.frame.size.height + 12.0f, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"secondHandHouseButton");
        
    }];
    [noDataView addSubview:secondHandHouseButton];
    
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_18];
    buttonStyle.title = @"看看出租房";
    
    ///出租物业
    UIButton *renantHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(secondHandHouseButton.frame.origin.x + secondHandHouseButton.frame.size.width + 8.0f, secondHandHouseButton.frame.origin.y, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"renantHouseButton");
        
    }];
    [noDataView addSubview:renantHouseButton];
    
    CGFloat noDataViewHeight = secondHandHouseButton.frame.origin.y+secondHandHouseButton.frame.size.height;
    [noDataView setFrame:CGRectMake(noDataView.frame.origin.x, (pendingListTableView.frame.size.height-noDataViewHeight)/2, noDataView.frame.size.width, noDataViewHeight)];
    
    [pendingListTableView addSubview:noDataView];
    
    [noDataView setHidden:YES];
    
    ///添加刷新事件
    [pendingListTableView addHeaderWithTarget:self action:@selector(getPendingListHeaderData)];
    [pendingListTableView addFooterWithTarget:self  action:@selector(getPendingListFooterData)];
    
    ///一开始就请求数据
    [pendingListTableView headerBeginRefreshing];
    
}

#pragma mark - 数据请求
///数据请求
- (void)getPendingListHeaderData
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.loadNextPage = [NSNumber numberWithInt:0];
        
        [self getOrderListData];
        //        [self endRefreshAnimination];
        //        [self reloadData];
        
    });
    
}

- (void)getPendingListFooterData
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self getOrderListData];
        
    });
    
}

#pragma mark - 结束刷新动画
///结束刷新动画
- (void)endRefreshAnimination
{
    
    UITableView *tableView = objc_getAssociatedObject(self, &PendingListTableViewKey);
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];
    
}

#pragma mark - 刷新数据
///刷新数据
- (void)reloadData
{
    
    UITableView *tableView = objc_getAssociatedObject(self, &PendingListTableViewKey);
    [tableView reloadData];
    
    //没有数据时
    if ([_pendingListDataSource count]==0) {
        UIView *nodataView = objc_getAssociatedObject(self, &PendingListNoDataViewKey);
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
    static NSString *PendingOrderListsTableViewCellName = @"PendingOrderListsTableViewCell";
    
    ///从复用队列中获取cell
    QSPTransationOrderListsTableViewCell *cellSystem = [tableView dequeueReusableCellWithIdentifier:PendingOrderListsTableViewCellName];
    
    ///判断是否需要重新创建
    if (nil == cellSystem) {
        
        cellSystem = [[QSPTransationOrderListsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PendingOrderListsTableViewCellName];
        
        ///取消选择状态
        cellSystem.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellSystem setParentViewController:parentViewController];
        
    }
    
    [cellSystem updateCellWith:[_pendingListDataSource objectAtIndex:indexPath.row]];
    
    return cellSystem;
    
}

#pragma mark - 返回一共有多少条订单记录
///返回一共有多少条订单记录
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_pendingListDataSource count];
    
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
    
    if (self.parentViewController&&[self.parentViewController isKindOfClass:[UIViewController class]]) {
        
        QSPOrderDetailBookedViewController *bookedVc = [[QSPOrderDetailBookedViewController alloc] init];
        if ([self.pendingListDataSource count]>indexPath.row) {
            QSOrderListItemData *orderItem = [self.pendingListDataSource objectAtIndex:indexPath.row];
            [bookedVc setOrderData:orderItem];
        }
        [self.parentViewController.navigationController pushViewController:bookedVc animated:YES];
    }
    
}

#pragma mark - 响应点击订单操作
///响应点击订单操作
- (void)getOrderListData
{
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    //        请求参数
    //        必选	类型及范围	说明
    //        key	true	string	要模糊搜索的字符
    //        user_id	true	int	用户id
    //        page_num	true	int	每页的数量,默认为10
    //        now_page	true	int	当前获取第几页的数据，默认为1
    //        order	true	string	以什么排序，默认为空
    //        order_status	true	string	获取什么状态下的订单，具体看配置项:ORDERSTATUS 如果是多个状态下的订单用逗号隔开，eg:500201,500202
    //        list_type	true	enum	只能传递 BUYER 或者 SALER 两个值中的一个，BUYER表示买家列表(房客)，SALER表示卖家的列表(业主)
    //        order_list_type	true	string(6)	顶单列表类型,具体看配置项:ORDERLISTTYPE, 500401:待成交，500402:已看房, 500403:已成交,500404:已取消
    
    if (!self.loadNextPage) {
        
        self.loadNextPage = [NSNumber numberWithInt:0];
        
    }
    
    [tempParam setObject:@"" forKey:@"key"];
    //TODO:获取用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    [tempParam setObject:(userID ? userID : @"1") forKey:@"user_id"];
    [tempParam setObject:@"20" forKey:@"page_num"];
    [tempParam setObject:[self.loadNextPage isEqualToValue:[NSNumber numberWithInt:0]]?@"1":self.loadNextPage forKey:@"now_page"];
    [tempParam setObject:@"" forKey:@"order"];
    [tempParam setObject:@"" forKey:@"order_status"];
    [tempParam setObject:@"BUYER" forKey:@"list_type"];
    [tempParam setObject:@"500501" forKey:@"order_list_type"];
    
    [QSRequestManager requestDataWithType:rRequestTypeTransationOrderListData andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///转换模型
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSOrderListReturnData *headerModel = resultData;
            
            if (headerModel&&[headerModel isKindOfClass:[QSOrderListReturnData class]]) {
                
                NSNumber *nextPage = headerModel.orderListHeaderData.next_page;
                
                if (nextPage&&[self.loadNextPage isEqualToValue:nextPage]) {
                    //没有更多了
                    TIPS_ALERT_MESSAGE_ANDTURNBACK(@"没有更多订单记录了", 1.0f, ^(){})
                    
                }else{
                    
                    if ([self.loadNextPage isEqualToValue:[NSNumber numberWithInt:0]]) {
                        
                        [self.pendingListDataSource removeAllObjects];
                        
                    }
                    
                    [self.pendingListDataSource addObjectsFromArray:[NSMutableArray arrayWithArray:headerModel.orderListHeaderData.orderList]];
                    
                    self.loadNextPage = nextPage;
                    
                    [self reloadData];
                    
                }
                
            }
        }else{
            
            QSHeaderDataModel *headerModel = resultData;
            if (headerModel&&[headerModel isKindOfClass:[QSHeaderDataModel class]]) {
                NSLog(@"%@ Error:%@",headerModel.code,headerModel.info);
            }
            
        }
        
        [self endRefreshAnimination];
        
    }];
    
}

@end
