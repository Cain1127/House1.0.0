//
//  QSYRecommendTenantViewController.m
//  House
//
//  Created by ysmeng on 15/4/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRecommendTenantViewController.h"

#import "QSYRecommendTenantTableViewCell.h"

#import "QSYRecommendTenantListReturnData.h"

#import "MJRefresh.h"

@interface QSYRecommendTenantViewController () <UITableViewDataSource,UITableViewDelegate>

@property (assign) RECOMMEND_TENANT_TYPE recommendType;                     //!<推荐类型
@property (nonatomic,copy) NSString *propertyID;                            //!<物业ID
@property (nonatomic,strong) UITableView *tenantListView;                   //!<列表
@property (nonatomic,retain) QSYRecommendTenantListReturnData *returnData;  //!<服务端返回的数据

@end

@implementation QSYRecommendTenantViewController

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-04-15 15:04:13
 *
 *  @brief                  创建推荐房源列表
 *
 *  @param recommendType    推荐类型
 *  @param propertyID       指定物业的推荐房客时，必须传指定物业ID
 *
 *  @return                 返回当前创建的推荐房客列表
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithRecommendType:(RECOMMEND_TENANT_TYPE)recommendType andPropertyType:(NSString *)propertyID
{

    if (self = [super init]) {
        
        ///保存参数
        self.recommendType = recommendType;
        self.propertyID = propertyID;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"推荐房客"];
    
}

- (void)createMainShowUI
{

    self.tenantListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) style:UITableViewStyleGrouped];
    self.tenantListView.showsHorizontalScrollIndicator = NO;
    self.tenantListView.showsVerticalScrollIndicator = NO;
    self.tenantListView.backgroundColor = [UIColor clearColor];
    
    self.tenantListView.dataSource = self;
    self.tenantListView.delegate = self;
    
    self.tenantListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tenantListView];
    [self.tenantListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(requestRecommendTenantsHeaderData)];
    [self.tenantListView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestRecommendTenantsFooterData)];
    self.tenantListView.footer.hidden = YES;
    [self.tenantListView.header beginRefreshing];

}

#pragma mark - 每一位推荐房客信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *tenantInfoCell = @"tenantInfoCell";
    QSYRecommendTenantTableViewCell *cellTenantInfo = [tableView dequeueReusableCellWithIdentifier:tenantInfoCell];
    if (nil == cellTenantInfo) {
        
        cellTenantInfo = [[QSYRecommendTenantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tenantInfoCell];
        cellTenantInfo.selectionStyle = UITableViewCellSelectionStyleNone;
        cellTenantInfo.backgroundColor = [UIColor clearColor];
        
    }
    
    ///刷新数据
    [cellTenantInfo updateRecommendTenantInfoCellUI:nil andCallBack:^(RECOMMEND_TENANT_CELL_ACTION_TYPE actionType, id params) {
        
        switch (actionType) {
                ///进入聊天
            case rRecommendTenantCellActionTypeTalk:
                
                break;
                
            default:
                break;
        }
        
    }];
    
    return cellTenantInfo;

}

#pragma mark - 列表设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.returnData.headerData.dataList count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 420.0f;

}


#pragma mark - 请求数据
- (void)requestRecommendTenantsHeaderData
{

    ///封装参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"10" forKey:@"page_num"];
    [params setObject:@"1" forKey:@"now_page"];
    [params setObject:@"" forKey:@"key"];
    [params setObject:[self getPostRecommendType] forKey:@"referrals_type"];
    
    if ([self.propertyID length] > 0) {
        
        [params setObject:@"" forKey:@"source_id"];
        
    }
    
    ///请求
    [QSRequestManager requestDataWithType:rRequestTypeMyZoneRecommendTenantList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///重置数据源
        self.returnData = nil;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            self.returnData = resultData;
            
        }
        
        [self.tenantListView reloadData];
        
        ///如果已无更多数据，则显示脚刷新提示
        if ([self.returnData.headerData.dataList count] > 0) {
            
            [self showNoRecordTips:NO];
            self.tenantListView.footer.hidden = NO;
            
            if ([self.returnData.headerData.per_page intValue] ==
                [self.returnData.headerData.next_page intValue]) {
                
                [self.tenantListView.footer noticeNoMoreData];
                
            }
            
        } else {
        
            [self showNoRecordTips:YES andTips:@"暂无推荐房客"];
        
        }
        
        ///结束刷新
        [self.tenantListView.header endRefreshing];
        
    }];

}

- (void)requestRecommendTenantsFooterData
{
    
    if ([self.returnData.headerData.per_page intValue] ==
        [self.returnData.headerData.next_page intValue]) {
        
        [self.tenantListView.footer noticeNoMoreData];
        
    }

    ///封装参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"10" forKey:@"page_num"];
    [params setObject:@"1" forKey:self.returnData.headerData.next_page];
    [params setObject:@"" forKey:@"key"];
    [params setObject:[self getPostRecommendType] forKey:@"referrals_type"];
    
    if ([self.propertyID length] > 0) {
        
        [params setObject:@"" forKey:@"source_id"];
        
    }
    
    ///请求
    [QSRequestManager requestDataWithType:rRequestTypeMyZoneRecommendTenantList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///重置数据源
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYRecommendTenantListReturnData *tempModel = resultData;
            if ([tempModel.headerData.dataList count] > 0) {
                
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.returnData.headerData.dataList];
                self.returnData = resultData;
                [tempArray addObjectsFromArray:self.returnData.headerData.dataList];
                self.returnData.headerData.dataList = tempArray;
                
            }
            
        }
        
        [self.tenantListView reloadData];
        
        ///如果已无更多数据，则显示脚刷新提示
        if ([self.returnData.headerData.dataList count] > 0) {
            
            self.tenantListView.footer.hidden = NO;
            if ([self.returnData.headerData.per_page intValue] ==
                [self.returnData.headerData.next_page intValue]) {
                
                [self.tenantListView.footer noticeNoMoreData];
                
            }
            
        }
        
        ///结束刷新
        [self.tenantListView.header endRefreshing];
        
    }];

}

#pragma mark - 根据推荐列表类型，返回请求类型
- (NSString *)getPostRecommendType
{

    switch (self.recommendType) {
            ///所有
        case rRecommendTenantTypeAll:
            
            return @"ALL";
            
            break;
            
            ///求租的推荐房客
        case rRecommendTenantTypeAppointedRentHouse:
            
            return @"RENT";
            
            break;
            
            ///求购的推荐房客
        case rRecommendTenantTypeAppointedBuyHouse:
            
            return @"APARTMENT";
            
            break;
            
        default:
            break;
    }
    
    return @"APARTMENT";

}

@end
