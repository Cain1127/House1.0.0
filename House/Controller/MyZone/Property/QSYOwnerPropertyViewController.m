//
//  QSYOwnerPropertyViewController.m
//  House
//
//  Created by ysmeng on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYOwnerPropertyViewController.h"
#import "QSYReleaseSaleHouseViewController.h"
#import "QSYReleaseRentHouseViewController.h"

#import "QSYPropertyHouseInfoTableViewCell.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSYPopCustomView.h"
#import "QSYSaleOrRentHouseTipsView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "MJRefresh.h"

@interface QSYOwnerPropertyViewController () <UITableViewDataSource,UITableViewDelegate>

///当前的房源类型
@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;

///记录列表
@property (nonatomic,strong) UITableView *recordsListView;

///无记录提示框
@property (nonatomic,strong) UILabel *noRecordsLabel;

@end

@implementation QSYOwnerPropertyViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-02 22:04:10
 *
 *  @brief              创建物业管理页
 *
 *  @param houseType    当前默认的房源类型：通过此类型，将会显示对应类型的列表
 *
 *  @return             返回当前创建的物业管理页
 *
 *  @since              1.0.0
 */
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存默认类型
        self.houseType = houseType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"我的物业"];
    
    ///增加物业按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeAdd];
    
    UIButton *addButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///弹出发布物业咨询页面
        [self popReleaseHouseTipsView];
        
    }];
    [self setNavigationBarRightView:addButton];

}

- (void)createMainShowUI
{
    
    [super createMainShowUI];
    [self createNoRecordsTipsView];
    
    ///按钮指针
    __block UIButton *secondHandHouseButton;
    __block UIButton *rentHouseButton;
    
    ///指示三角指针
    __block UIImageView *arrowIndicator;
    
    ///尺寸
    CGFloat widthButton = SIZE_DEVICE_WIDTH / 2.0f;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_16];
    
    ///二手房源
    buttonStyle.title = @"出售物业";
    secondHandHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        rentHouseButton.selected = NO;
        
        ///更换房源类型
        self.houseType = fFilterMainTypeSecondHouse;
        
        ///刷新数据
        [self.recordsListView.header beginRefreshing];
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            
            
        }];
        
    }];
    [self.view addSubview:secondHandHouseButton];
    
    ///出租房房源
    buttonStyle.title = @"出租物业";
    rentHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(secondHandHouseButton.frame.origin.x + secondHandHouseButton.frame.size.width, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        secondHandHouseButton.selected = NO;
        
        ///更换房源类型
        self.houseType = fFilterMainTypeRentalHouse;
        
        ///刷新数据
        [self.recordsListView.header beginRefreshing];
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            
            
        }];
        
    }];
    [self.view addSubview:rentHouseButton];
    
    ///根据房源类型，设置默认选择的按钮
    CGFloat arrowXPoint = secondHandHouseButton.frame.size.width / 2.0f - 7.5f;
    if (self.houseType == fFilterMainTypeRentalHouse) {
        
        rentHouseButton.selected = YES;
        arrowXPoint = rentHouseButton.frame.origin.x + rentHouseButton.frame.size.width / 2.0f - 7.5f;
        
    }
    
    if (self.houseType == fFilterMainTypeSecondHouse) {
        
        secondHandHouseButton.selected = YES;
        arrowXPoint = secondHandHouseButton.frame.origin.x + secondHandHouseButton.frame.size.width / 2.0f - 7.5f;
        
    }
    
    ///指示三角
    arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(arrowXPoint, secondHandHouseButton.frame.origin.y + secondHandHouseButton.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowIndicator];
    
    ///记录列表
    self.recordsListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 104.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 104.0f)];
    self.recordsListView.showsHorizontalScrollIndicator = NO;
    self.recordsListView.showsVerticalScrollIndicator = NO;
    self.recordsListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///数据源和代理
    self.recordsListView.dataSource = self;
    self.recordsListView.delegate = self;
    
    [self.view addSubview:self.recordsListView];
    
    ///头部刷新
    [self.recordsListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getReleaseHouseHeaderData)];
    [self.recordsListView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getReleaseHouseMoreData)];
    
    ///开始就头部刷新
    [self.recordsListView.header beginRefreshing];
    self.recordsListView.footer.hidden = YES;
    
}

#pragma mark - 无发布记录提示view
- (void)createNoRecordsTipsView
{

    self.noRecordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT / 2.0f - 30.0f, SIZE_DEFAULT_MAX_WIDTH, 60.0f)];
    self.noRecordsLabel.numberOfLines = 2;
    self.noRecordsLabel.text = @"暂无发售房源，\n马上发布一个吧！";
    self.noRecordsLabel.textAlignment = NSTextAlignmentCenter;
    self.noRecordsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    self.noRecordsLabel.hidden = YES;
    [self.view addSubview:self.noRecordsLabel];

}

#pragma mark - 列表设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *normalCell = @"normalCell";
    UITableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cellNormal;

}

#pragma mark - 请求数据
- (void)getReleaseHouseHeaderData
{
    
    self.noRecordsLabel.hidden = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.recordsListView.header endRefreshing];
        self.noRecordsLabel.hidden = NO;
        
    });

}

- (void)getReleaseHouseMoreData
{

    

}

#pragma mark - 弹出发布物业提示框
- (void)popReleaseHouseTipsView
{

    ///弹出窗口的指针
    __block QSYPopCustomView *popView = nil;
    
    ///提示选择窗口
    QSYSaleOrRentHouseTipsView *saleTipsView = [[QSYSaleOrRentHouseTipsView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 134.0f) andCallBack:^(SALE_RENT_HOUSE_TIPS_ACTION_TYPE actionType) {
        
        ///加收弹出窗口
        [popView hiddenCustomPopview];
        
        ///进入发布物业的窗口
        if (sSaleRentHouseTipsActionTypeSale == actionType) {
            
            ///进入发布物业过滤窗口
            QSYReleaseSaleHouseViewController *releaseRentHouseVC = [[QSYReleaseSaleHouseViewController alloc] init];
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
            
        }
        
        ///进入发布出租物业添加窗口
        if (sSaleRentHouseTipsActionTypeRent == actionType) {
            
            ///进入发布出租物业添加窗口
            QSYReleaseRentHouseViewController *releaseRentHouseVC = [[QSYReleaseRentHouseViewController alloc] init];
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:releaseRentHouseVC animated:YES];
            
        }
        
    }];
    
    ///弹出窗口
    popView = [QSYPopCustomView popCustomView:saleTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];

}

#pragma mark - 刷新物业列表
/**
 *  @author yangshengmeng, 15-04-04 15:04:19
 *
 *  @brief  刷新物业列表
 *
 *  @since  1.0.0
 */
- (void)updateMyPropertyData
{

    [self.recordsListView.header beginRefreshing];

}

@end
