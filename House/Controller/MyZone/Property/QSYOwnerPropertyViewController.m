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
#import "QSYRecommendTenantViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSSecondHouseDetailViewController.h"

#import "QSYOwnerPropertyDeleteTipsPopView.h"
#import "QSYPopCustomView.h"
#import "QSCustomHUDView.h"

#import "QSYPropertyHouseInfoTableViewCell.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSYPopCustomView.h"
#import "QSYSaleOrRentHouseTipsView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSSecondHandHouseListReturnData.h"
#import "QSRentHouseListReturnData.h"
#import "QSRentHouseInfoDataModel.h"
#import "QSRentHousesDetailReturnData.h"
#import "QSSecondHousesDetailReturnData.h"

#import "QSCoreDataManager+User.h"

#import "MJRefresh.h"

@interface QSYOwnerPropertyViewController () <UITableViewDataSource,UITableViewDelegate>

///当前的房源类型
@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;

///记录列表
@property (nonatomic,strong) UITableView *recordsListView;

///无记录提示框
@property (nonatomic,strong) UILabel *noRecordsLabel;

///当前展开的下标
@property (nonatomic,assign) int releaseIndex;

///是否重新刷新
@property (assign) BOOL isNeedRefresh;

///数据模型
@property (nonatomic,retain) QSSecondHandHouseListReturnData *secondHousesModel;
@property (nonatomic,retain) QSRentHouseListReturnData *rentModel;

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
        
        ///初始化当前的下标
        self.releaseIndex = -1;
        
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
        
        ///过滤
        if (uUserCountTypeAgency != [QSCoreDataManager getUserType] &&
            5 <= [QSCoreDataManager getUserPropertySumCount]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"最多只能发布5套物业", 1.5f, ^(){})
            return;
            
        }
        
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
    [self.view bringSubviewToFront:arrowIndicator];
    
    ///记录列表
    self.recordsListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 104.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 104.0f)];
    self.recordsListView.showsHorizontalScrollIndicator = NO;
    self.recordsListView.showsVerticalScrollIndicator = NO;
    self.recordsListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///数据源和代理
    self.recordsListView.dataSource = self;
    self.recordsListView.delegate = self;
    
    [self.view addSubview:self.recordsListView];
    [self.view sendSubviewToBack:self.recordsListView];
    
    ///头部刷新
    [self.recordsListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getReleaseHouseHeaderData)];
    
    ///开始就头部刷新
    [self.recordsListView.header beginRefreshing];
    
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

    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        return [self.secondHousesModel.secondHandHouseHeaderData.houseList count];
        
    }
    
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        return [self.rentModel.headerData.rentHouseList count];
        
    }
    
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.releaseIndex == indexPath.row) {
        
        return 165.0f + 44.0f;
        
    }
    
    return 165.0f;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///二手房
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        static NSString *secondHandHouseCell = @"secondHandHouseCell";
        QSYPropertyHouseInfoTableViewCell *cellSecondHandHouse = [tableView dequeueReusableCellWithIdentifier:secondHandHouseCell];
        if (nil == cellSecondHandHouse) {
            
            cellSecondHandHouse = [[QSYPropertyHouseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondHandHouseCell andHouseType:fFilterMainTypeSecondHouse];
            cellSecondHandHouse.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        ///刷新数据
        QSHouseInfoDataModel *tempModel = self.secondHousesModel.secondHandHouseHeaderData.houseList[indexPath.row];
        [cellSecondHandHouse updateMyPropertyHouseInfo:tempModel andHouseType:fFilterMainTypeSecondHouse andCallBack:^(PROPERTY_INFOCELL_ACTION_TYPE actionType){
        
            switch (actionType) {
                    ///显示附加功能
                case pPropertyInfocellActionTypeSetting:
                {
                
                    self.releaseIndex = (int)indexPath.row;
                    [tableView reloadData];
                
                }
                    break;
                    
                    ///关闭附加功能
                case pPropertyInfocellActionTypeCloseSetting:
                {
                
                    self.releaseIndex = -1;
                    [tableView reloadData];
                
                }
                    break;
                    
                    ///编辑
                case pPropertyInfocellActionTypeEdit:
                {
                    
                    [self getSecondHandHouseDetailInfo:tempModel.id_];
                
                };
                    break;
                    
                    ///暂停发布
                case pPropertyInfocellActionTypeDelete:
                {
                    
                    [self deleteProperty:tempModel.id_ andPropertyType:fFilterMainTypeSecondHouse];
                    
                };
                    break;
                    
                    ///推荐房客
                case pPropertyInfocellActionTypeRecommendRenant:
                {
                
                    QSYRecommendTenantViewController *recommendVC = [[QSYRecommendTenantViewController alloc] initWithRecommendType:rRecommendTenantTypeAppointedBuyHouse andPropertyType:tempModel.id_];
                    [self.navigationController pushViewController:recommendVC animated:YES];
                
                }
                    break;
                    
                    ///刷新房源
                case pPropertyInfocellActionTypeRefreshHouse:
                {
                
                    [tableView.header beginRefreshing];
                
                }
                    break;
                    
                default:
                    break;
            }
        
        }];
        
        ///刷新设置
        [cellSecondHandHouse updateEditFunctionShowStatus:(self.releaseIndex == indexPath.row)];
        
        return cellSecondHandHouse;
        
    }
    
    ///出租房
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        static NSString *rentHouseCell = @"rentHouseCell";
        QSYPropertyHouseInfoTableViewCell *cellRentHouse = [tableView dequeueReusableCellWithIdentifier:rentHouseCell];
        if (nil == cellRentHouse) {
            
            cellRentHouse = [[QSYPropertyHouseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rentHouseCell andHouseType:fFilterMainTypeSecondHouse];
            cellRentHouse.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        ///刷新数据
        QSRentHouseInfoDataModel *tempModel = self.rentModel.headerData.rentHouseList[indexPath.row];
        [cellRentHouse updateMyPropertyHouseInfo:tempModel andHouseType:fFilterMainTypeRentalHouse andCallBack:^(PROPERTY_INFOCELL_ACTION_TYPE actionType){
            
            switch (actionType) {
                    ///显示附加功能
                case pPropertyInfocellActionTypeSetting:
                {
                    
                    self.releaseIndex = (int)indexPath.row;
                    [tableView reloadData];
                    
                }
                    break;
                    
                    ///关闭附加功能
                case pPropertyInfocellActionTypeCloseSetting:
                {
                    
                    self.releaseIndex = -1;
                    [tableView reloadData];
                    
                }
                    break;
                    
                    ///编辑
                case pPropertyInfocellActionTypeEdit:
                {
                    
                    ///下载详情信息
                    [self getRentHouseDetailInfo:tempModel.id_];
                    
                }
                    break;
                    
                    ///暂停发布
                case pPropertyInfocellActionTypeDelete:
                {
                    
                    [self deleteProperty:tempModel.id_ andPropertyType:fFilterMainTypeRentalHouse];
                
                };
                    break;
                    
                    ///推荐房客
                case pPropertyInfocellActionTypeRecommendRenant:
                {
                
                    if ([tempModel.reservation_num intValue] > 0) {
                        
                        QSYRecommendTenantViewController *recommendVC = [[QSYRecommendTenantViewController alloc] initWithRecommendType:rRecommendTenantTypeAppointedRentHouse andPropertyType:tempModel.id_];
                        [self.navigationController pushViewController:recommendVC animated:YES];
                        
                    } else {
                    
                        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"暂无推荐房客", 1.0f, ^(){})
                    
                    }
                
                }
                    break;
                    
                    ///刷新房源
                case pPropertyInfocellActionTypeRefreshHouse:
                {
                
                    [tableView.header beginRefreshing];
                
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        ///刷新设置
        [cellRentHouse updateEditFunctionShowStatus:(self.releaseIndex == indexPath.row)];
        
        return cellRentHouse;
        
    }
    
    static NSString *unuseCell = @"unuseCell";
    UITableViewCell *cellUnuse = [tableView dequeueReusableCellWithIdentifier:unuseCell];
    if (nil == cellUnuse) {
        
        cellUnuse = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unuseCell];
        cellUnuse.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cellUnuse;

}

#pragma mark - 进入物业详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (self.houseType) {
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
        
            QSHouseInfoDataModel *tempModel = self.secondHousesModel.secondHandHouseHeaderData.houseList[indexPath.row];
            
            QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:([tempModel.title length] > 0 ? tempModel.title : tempModel.village_name) andDetailID:tempModel.id_ andDetailType:self.houseType];
            
            ///删除物业时回调刷新
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
                
                self.isNeedRefresh  = YES;
                
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
        
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
        
            QSRentHouseInfoDataModel *tempModel = self.rentModel.headerData.rentHouseList[indexPath.row];
            
            QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:([tempModel.title  length] > 0 ? tempModel.title : tempModel.village_name) andDetailID:tempModel.id_ andDetailType:self.houseType];
            
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
                
                self.isNeedRefresh = YES;
                
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
        
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 请求数据
- (void)getReleaseHouseHeaderData
{
    
    ///清空原数据，刷新UI
    self.secondHousesModel = nil;
    self.rentModel = nil;
    [self.recordsListView reloadData];
    
    ///根据类型请求
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        [self getOwnerReleaseSecondHandHouse];
        
    }
    
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        [self getOwnerReleaseRentHouse];
        
    }

}

///请求二手房数据
- (void)getOwnerReleaseSecondHandHouse
{
    
    ///封装参数
    NSString *userID = [QSCoreDataManager getUserID];
    NSDictionary *params = @{@"data_user_id" : APPLICATION_NSSTRING_SETTING(userID, @"")};
    
    ///请求
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSSecondHandHouseListReturnData *tempModel = resultData;
            if ([tempModel.secondHandHouseHeaderData.houseList count] > 0) {
                
                self.secondHousesModel = tempModel;
                
            }
            
            ///结束刷新
            [self.recordsListView reloadData];
            [self.recordsListView.header endRefreshing];
            
        } else {
            
            [self.recordsListView reloadData];
            [self.recordsListView.header endRefreshing];
            
        }
        
    }];
    
}

///请求出租房数据
- (void)getOwnerReleaseRentHouse
{
    
    ///封装参数
    NSString *userID = [QSCoreDataManager getUserID];
    NSDictionary *params = @{@"data_user_id" : APPLICATION_NSSTRING_SETTING(userID, @"")};
    
    ///请求
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSRentHouseListReturnData *tempModel = resultData;
            if ([tempModel.headerData.rentHouseList count] > 0) {
                
                self.rentModel = tempModel;
                
            }
            
            ///结束刷新
            [self.recordsListView reloadData];
            [self.recordsListView.header endRefreshing];
            
        } else {
            
            [self.recordsListView reloadData];
            [self.recordsListView.header endRefreshing];
            
        }
        
    }];
    
}

#pragma mark - 弹出发布物业提示框
- (void)popReleaseHouseTipsView
{
    
    ///判断当前是否已发布物业：不能超过5套物业
    USER_COUNT_TYPE userType = [QSCoreDataManager getUserType];
    int sumProperty = [QSCoreDataManager getUserPropertySumCount];
    if ((uUserCountTypeAgency != userType) && sumProperty >= 5) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"最多只能发布5套物业", 1.5f, ^(){})
        return;
        
    }

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

#pragma mark - 删除物业
- (void)deleteProperty:(NSString *)propertyID andPropertyType:(FILTER_MAIN_TYPE)houseType
{

    __block QSYPopCustomView *popView;
    
    QSYOwnerPropertyDeleteTipsPopView *tipsView = [[QSYOwnerPropertyDeleteTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 150.0f, SIZE_DEVICE_WIDTH, 150.0f) andCallBack:^(PROPERTY_DELETE_ACTION_TYPE actionType) {
        
        [popView hiddenCustomPopview];
        
        switch (actionType) {
                
                ///确认删除
            case pPropertyDeleteActionTypeConfirm:
            {
                
                ///显示HUD
                QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在删除"];
            
                ///封装参数
                NSDictionary *params = @{@"id_" : APPLICATION_NSSTRING_SETTING(propertyID, @"")};
                
                ///根据类型生成请求
                REQUEST_TYPE requestType = (fFilterMainTypeRentalHouse == houseType) ? rRequestTypeMyZoneDeleteRentHouseProperty : (fFilterMainTypeSecondHouse == houseType ? rRequestTypeMyZoneDeleteSaleHouseProperty : rRequestTypeMyZoneDeleteRentHouseProperty);
                
                [QSRequestManager requestDataWithType:requestType andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
                    
                    if (rRequestResultTypeSuccess == resultStatus) {
                        
                        [hud hiddenCustomHUDWithFooterTips:@"删除成功" andDelayTime:1.5f andCallBack:^(BOOL flag){
                        
                            ///刷新数据
                            [self.recordsListView.header beginRefreshing];
                        
                        }];
                        
                    } else {
                    
                        NSString *tipsString = @"删除失败";
                        if (resultData) {
                            
                            tipsString = [resultData valueForKey:@"info"];
                            
                        }
                        [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
                    
                    }
                    
                }];
            
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:tipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
        
    }];

}

#pragma mark - 下载物业详情信息
- (void)getRentHouseDetailInfo:(NSString *)detailID
{
    
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在获取物业详细信息"];
    
    ///封装参数
    NSDictionary *params = @{@"id_" : detailID ? detailID : @""};
    
    ///进行请求
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouseDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"获取成功" andDelayTime:2.0f andCallBack:^(BOOL flag) {
                
                ///转换模型
                QSRentHousesDetailReturnData *tempModel = resultData;
                
                QSYReleaseRentHouseViewController *updatePropertyVC = [[QSYReleaseRentHouseViewController alloc] initWithRentHouseModel:[tempModel.detailInfo changeToReleaseDataModel]];
                [self.navigationController pushViewController:updatePropertyVC animated:YES];
                
            }];
            
        } else {
            
            NSString *tipsString = @"获取出租房详情信息失败，请稍后再试";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:2.0f];
            
        }
        
    }];

}

- (void)getSecondHandHouseDetailInfo:(NSString *)detailID
{
    
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在获取物业详细信息"];
    
    ///封装参数
    NSDictionary *params = @{@"id_" : detailID ? detailID : @""};
    
    ///进行请求
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"获取成功" andDelayTime:2.0f andCallBack:^(BOOL flag) {
                
                ///转换模型
                QSSecondHousesDetailReturnData *tempModel = resultData;
                
                QSYReleaseSaleHouseViewController *updatePropertyVC = [[QSYReleaseSaleHouseViewController alloc] initWithSaleModel:[tempModel.detailInfo changeToReleaseDataModel]];
                [self.navigationController pushViewController:updatePropertyVC animated:YES];
                
            }];
            
        } else {
            
            NSString *tipsString = @"获取二手房详情信息失败，请稍后再试";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:2.0f];
            
        }
        
    }];
    
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

#pragma mark - 是否刷新
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

    if (self.isNeedRefresh) {
        
        self.isNeedRefresh = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.recordsListView.header beginRefreshing];
            
        });
        
    }

}

@end
