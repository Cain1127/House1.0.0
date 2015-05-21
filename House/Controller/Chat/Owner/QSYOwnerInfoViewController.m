//
//  QSYOwnerInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYOwnerInfoViewController.h"
#import "QSYTalkPTPViewController.h"
#import "QSYContactSettingViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSSecondHouseDetailViewController.h"

#import "QSYContactInfoView.h"
#import "QSYContactAppointmentCreditInfoView.h"
#import "QSYPopCustomView.h"
#import "QSYCallTipsPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCollectionVerticalFlowLayout.h"
#import "QSHouseListTitleCollectionViewCell.h"
#import "QSHouseCollectionViewCell.h"
#import "QSYContactDetailReturnData.h"
#import "QSYContactDetailInfoModel.h"
#import "QSSecondHandHouseListReturnData.h"
#import "QSRentHouseListReturnData.h"
#import "QSRentHouseInfoDataModel.h"

#import "QSCoreDataManager+User.h"

#import "MJRefresh.h"

@interface QSYOwnerInfoViewController () <QSCollectionVerticalFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,copy) NSString *ownerName;                         //!<业主名
@property (nonatomic,copy) NSString *ownerID;                           //!<业主ID
@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;                //!<房源类型
@property (nonatomic,strong) UICollectionView *userInfoRootView;        //!<用户信息底view
@property (nonatomic,retain) NSMutableArray *housesSource;              //!<房源列表
@property (nonatomic,retain) QSYContactDetailReturnData *contactInfo;   //!<联系人信息
@property (assign) BOOL isNeedRefresh;                                  //!<是否需要刷新

@end

@implementation QSYOwnerInfoViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-07 16:04:50
 *
 *  @brief              创建业主页面
 *
 *  @param ownerName    业主名
 *  @param ownerID      业主的ID
 *  @param houseType    房源类型：默认显示的类型
 *
 *  @return             返回当前创建的业主信息页
 *
 *  @since              1.0.0
 */
- (instancetype)initWithName:(NSString *)ownerName  andOwnerID:(NSString *)ownerID andDefaultHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存业主信息
        self.ownerID = ownerID;
        self.ownerName = ownerName;
        self.houseType = houseType;
        
        ///初始化参数
        self.housesSource = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.ownerName];
    
    ///说明
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeUserDetail];
    
    UIButton *detailButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断登录
        [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
            
            switch (flag) {
                    ///新登录
                case lLoginCheckActionTypeReLogin:
                {
                    
                    ///刷新数据
                    self.isNeedRefresh = YES;
                    
                }
                    break;
                    
                    ///已登录
                case lLoginCheckActionTypeLogined:
                {
                
                    QSYContactSettingViewController *contactSettingVC = [[QSYContactSettingViewController alloc] initWithContactID:self.ownerID andContactName:self.ownerName isFriends:self.contactInfo.contactInfo.id_ isImport:self.contactInfo.contactInfo.is_import andCallBack:^(CONTACT_SETTING_CALLBACK_ACTION_TYPE actionType, id params) {
                        
                        switch (actionType) {
                                ///添加成为联系人
                            case cContactSettingCallBackActionTypeAddContact:
                            {
                                
                                self.contactInfo.contactInfo.id_ = params;
                                [self.userInfoRootView reloadData];
                                
                                ///回调通知联系人改变
                                if (self.contactInfoChangeCallBack) {
                                    
                                    self.contactInfoChangeCallBack(YES);
                                    
                                }
                                
                            }
                                break;
                                
                                ///删除联系人
                            case cContactSettingCallBackActionTypeDeleteContact:
                            {
                                
                                self.contactInfo.contactInfo.id_ = @"0";
                                [self.userInfoRootView reloadData];
                                
                                ///回调通知联系人改变
                                if (self.contactInfoChangeCallBack) {
                                    
                                    self.contactInfoChangeCallBack(YES);
                                    
                                }
                                
                            }
                                break;
                                
                                ///设置为重点联系人
                            case cContactSettingCallBackActionTypeSetImport:
                            {
                                
                                self.contactInfo.contactInfo.is_import = @"1";
                                
                                ///回调通知联系人改变
                                if (self.contactInfoChangeCallBack) {
                                    
                                    self.contactInfoChangeCallBack(YES);
                                    
                                }
                                
                            }
                                break;
                                
                                ///设置为普通联系人
                            case cContactSettingCallBackActionTypeSetUNImport:
                            {
                                
                                self.contactInfo.contactInfo.is_import = @"0";
                                
                                ///回调通知联系人改变
                                if (self.contactInfoChangeCallBack) {
                                    
                                    self.contactInfoChangeCallBack(YES);
                                    
                                }
                                
                            }
                                break;
                                
                                ///备注联系人
                            case cContactSettingCallBackActionTypeRemarkContact:
                            {
                                
                                self.contactInfo.contactInfo.remark = APPLICATION_NSSTRING_SETTING_NIL(params);
                                [self.userInfoRootView reloadData];
                                
                                ///回调通知联系人改变
                                if (self.contactInfoChangeCallBack) {
                                    
                                    self.contactInfoChangeCallBack(YES);
                                    
                                }
                                
                            }
                                break;
                                
                            default:
                                break;
                        }
                        
                    }];
                    [self.navigationController pushViewController:contactSettingVC animated:YES];
                
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }];
    [self setNavigationBarRightView:detailButton];

}

- (void)createMainShowUI
{

    [super createMainShowUI];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///布局器
    CGFloat width = (SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    QSCollectionVerticalFlowLayout *defaultLayout = [[QSCollectionVerticalFlowLayout alloc] initWithItemWidth:width];
    defaultLayout.delegate = self;
    
    self.userInfoRootView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) collectionViewLayout:defaultLayout];
    self.userInfoRootView.showsHorizontalScrollIndicator = NO;
    self.userInfoRootView.showsVerticalScrollIndicator = NO;
    self.userInfoRootView.dataSource = self;
    self.userInfoRootView.delegate = self;
    self.userInfoRootView.backgroundColor = [UIColor whiteColor];
    
    [self.userInfoRootView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"headerCell"];
    [self.userInfoRootView registerClass:[QSHouseListTitleCollectionViewCell class] forCellWithReuseIdentifier:@"houseTipsCell"];
    [self.userInfoRootView registerClass:[QSHouseCollectionViewCell class] forCellWithReuseIdentifier:@"houseCell"];
    [self.view addSubview:self.userInfoRootView];
    
    ///头部刷新
    [self.userInfoRootView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getOwnerInfo)];
    [self.userInfoRootView.header beginRefreshing];
    
    ///判断是否是中介
    if (uUserCountTypeAgency == [QSCoreDataManager getUserType]) {
        
        return;
        
    }
    
    ///非中介时，添加功能按钮
    self.userInfoRootView.frame = CGRectMake(self.userInfoRootView.frame.origin.x, self.userInfoRootView.frame.origin.y, self.userInfoRootView.frame.size.width, self.userInfoRootView.frame.size.height - 44.0f - 16.0f);
    
    ///按钮风格
    CGFloat widthButton = (SIZE_DEVICE_WIDTH - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///发送消息
    buttonStyle.title = @"发送消息";
    UIButton *sendMessageButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 8.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
            
            switch (flag) {
                    ///新登录
                case lLoginCheckActionTypeReLogin:
                {
                
                    self.isNeedRefresh = YES;
                
                }
                    break;
                    
                    ///已登录
                case lLoginCheckActionTypeLogined:
                {
                
                    ///进入聊天页
                    QSYTalkPTPViewController *talkVC = [[QSYTalkPTPViewController alloc] initWithUserModel:[self.contactInfo.contactInfo contactDetailChangeToSimpleUserModel]];
                    [self.navigationController pushViewController:talkVC animated:YES];
                
                }
                default:
                    break;
            }
            
        }];
        
    }];
    [self.view addSubview:sendMessageButton];
    
    ///打电话
    buttonStyle.title = @"打电话";
    UIButton *callButton = [UIButton createBlockButtonWithFrame:CGRectMake(sendMessageButton.frame.origin.x + sendMessageButton.frame.size.width + 8.0f,sendMessageButton.frame.origin.y, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
            
            switch (flag) {
                    ///新登录
                case lLoginCheckActionTypeReLogin:
                {
                    
                    self.isNeedRefresh = YES;
                    
                }
                    break;
                    
                    ///已登录
                case lLoginCheckActionTypeLogined:
                {
                    
                    if ([self.contactInfo.contactInfo.is_order isEqualToString:@"true"]) {
                        
                        ///打电话
                        [self callContactOwner];
                        
                    } else {
                        
                        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请您先预约看房，预约成功后方可拨打业主电话", 1.0f, ^(){})
                        
                    }
                    
                }
                default:
                    break;
            }
            
        }];
        
    }];
    [self.view addSubview:callButton];

}

#pragma mark - 布局器相关设置
///头信息的高度
- (CGFloat)heightForCustomVerticalFlowLayoutHeader
{

    return 204.0f;

}

- (CGFloat)widthForCustomVerticalFlowLayoutItem
{
    
    return (SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;

}

///垂直方向间隙
- (CGFloat)gapVerticalForCustomVerticalFlowItem
{

    return SIZE_DEFAULT_MARGIN_LEFT_RIGHT;

}

- (CGFloat)customVerticalFlowLayout:(QSCollectionVerticalFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (0 == indexPath.row) {
        
        return 80.0f;
        
    }
    
    CGFloat width = (SIZE_DEVICE_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f) / 2.0f;
    CGFloat height = 139.5f + width * 247.0f / 330.0f;
    
    return height;

}

///cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 1 + ([self.housesSource count] > 0 ? [self.housesSource count] + 1 : 0);

}

#pragma mark - 返回cell信息
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    ///头信息
    if (0 == indexPath.row) {
        
        ///复用标识
        static NSString *headerCellIndentify = @"headerCell";
        UICollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:headerCellIndentify forIndexPath:indexPath];
        
        ///头信息
        QSYContactInfoView *infoRootView = (QSYContactInfoView *)[headerCell.contentView viewWithTag:450];
        if (nil == infoRootView) {
            
            infoRootView = [[QSYContactInfoView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 80.0f)];
            infoRootView.tag = 450;
            [headerCell.contentView addSubview:infoRootView];
            
        }
        
        ///刷新数据
        __weak QSYContactInfoView *contactInfoWeakView = infoRootView;
        infoRootView.contactInfoCallBack = ^(UIButton *button){
        
            [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                
                switch (flag) {
                        ///已登录
                    case lLoginCheckActionTypeLogined:
                    {
                    
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [contactInfoWeakView addContact:button];
                            
                        });
                    
                    }
                        break;
                        
                        ///新登录
                    case lLoginCheckActionTypeReLogin:
                    {
                    
                        ///刷新数据
                        self.isNeedRefresh = YES;
                    
                    }
                        
                    default:
                        break;
                }
                
            }];
        
        };
        [infoRootView updateContactInfoUI:self.contactInfo.contactInfo];
        
        ///预约回复信息
        QSYContactAppointmentCreditInfoView *replyRootView = (QSYContactAppointmentCreditInfoView *)[headerCell.contentView viewWithTag:451];
        if (nil == replyRootView) {
            
            replyRootView = [[QSYContactAppointmentCreditInfoView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, infoRootView.frame.origin.y + infoRootView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 80.0f) andHouseType:uUserCountTypeOwner];
            replyRootView.tag = 451;
            [headerCell.contentView addSubview:replyRootView];
            
        }
        
        ///刷新数据
        [replyRootView updateContactInfoUI:self.contactInfo.contactInfo];
        
        ///按钮
        __block UIButton *saleHouseButton = (UIButton *)[headerCell.contentView viewWithTag:452];
        __block UIButton *rentHouseButton = (UIButton *)[headerCell.contentView viewWithTag:453];
        __block QSImageView *arrowIndicator = (QSImageView *)[headerCell.contentView viewWithTag:454];
        
        ///出售物业按钮
        if (nil == saleHouseButton) {
            
            QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
            buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
            buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_16];
            buttonStyle.title = @"出售物业";
            
            saleHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, replyRootView.frame.origin.y + replyRootView.frame.size.height, SIZE_DEVICE_WIDTH / 2.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
                
                if (button.selected) {
                    
                    return;
                    
                }
                
                button.selected = YES;
                rentHouseButton.selected = NO;
                
                ///重置房源类型
                self.houseType = fFilterMainTypeSecondHouse;
                [self.userInfoRootView.header beginRefreshing];
                
                ///移动指示三角
                [UIView animateWithDuration:0.3f animations:^{
                    
                    arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
                    
                } completion:^(BOOL finished) {
                    
                    
                    
                }];
                
            }];
            saleHouseButton.tag = 452;
            saleHouseButton.selected = (self.houseType == fFilterMainTypeSecondHouse);
            [headerCell.contentView addSubview:saleHouseButton];
            
        }
        
        ///出租物业按钮
        if (nil == rentHouseButton) {
            
            QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
            buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
            buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_16];
            buttonStyle.title = @"出租物业";
            
            rentHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(saleHouseButton.frame.origin.x + saleHouseButton.frame.size.width, saleHouseButton.frame.origin.y, saleHouseButton.frame.size.width, saleHouseButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
                
                if (button.selected) {
                    
                    return;
                    
                }
                
                button.selected = YES;
                saleHouseButton.selected = NO;
                
                ///重置房源类型
                self.houseType = fFilterMainTypeRentalHouse;
                [self.userInfoRootView.header beginRefreshing];
                
                ///移动指示三角
                [UIView animateWithDuration:0.3f animations:^{
                    
                    arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
                    
                } completion:^(BOOL finished) {
                    
                    
                    
                }];
                
            }];
            rentHouseButton.tag = 453;
            rentHouseButton.selected = (self.houseType == fFilterMainTypeRentalHouse);
            [headerCell.contentView addSubview:rentHouseButton];
            
        }
        
        ///指示三角
        if (nil == arrowIndicator) {
            
            arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(saleHouseButton.frame.origin.x + saleHouseButton.frame.size.width / 2.0f - 7.5f, saleHouseButton.frame.origin.y + saleHouseButton.frame.size.height - 5.0f, 15.0f, 5.0f)];
            arrowIndicator.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
            arrowIndicator.tag = 454;
            [headerCell.contentView addSubview:arrowIndicator];
            
        }
        
        return headerCell;
        
    }
    
    ///判断是否标题栏
    if (1 == indexPath.row) {
        
        ///复用标识
        static NSString *titleCellIndentify = @"houseTipsCell";
        
        ///从复用队列中获取cell
        QSHouseListTitleCollectionViewCell *cellTitle = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellIndentify forIndexPath:indexPath];
        
        ///更新数据
        NSString *titleString = (self.houseType == fFilterMainTypeRentalHouse ? @"套出租房信息" : @"套二手房信息");
        [cellTitle updateTitleInfoWithTitle:[NSString stringWithFormat:@"%d",(int)[self.housesSource count]] andSubTitle:titleString];
        
        return cellTitle;
        
    }
    
    ///复用标识
    static NSString *houseCellIndentify = @"houseCell";
    
    ///从复用队列中获取房子信息的cell
    QSHouseCollectionViewCell *cellHouse = [collectionView dequeueReusableCellWithReuseIdentifier:houseCellIndentify forIndexPath:indexPath];
    
    ///刷新数据
    [cellHouse updateHouseInfoCellUIWithDataModel:self.housesSource[indexPath.row - 2] andListType:self.houseType];
    
    return cellHouse;

}

#pragma mark - 进入详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row <= 1) {
        
        return;
        
    }
    
    ///根据不同的类型，进入不同的详情页
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        ///获取房子模型
        QSRentHouseInfoDataModel *houseInfoModel = self.housesSource[indexPath.row - 2];
        
        ///进入详情页面
        QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:([houseInfoModel.title  length] > 0 ? houseInfoModel.title : houseInfoModel.village_name) andDetailID:houseInfoModel.id_ andDetailType:self.houseType];
        
        detailVC.deletePropertyCallBack = ^(BOOL isDelete){
        
            self.isNeedRefresh = YES;
        
        };
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        ///获取房子模型
        QSHouseInfoDataModel *houseInfoModel = self.housesSource[indexPath.row - 2];
        
        ///进入详情页面
        QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:([houseInfoModel.title length] > 0 ? houseInfoModel.title : houseInfoModel.village_name) andDetailID:houseInfoModel.id_ andDetailType:self.houseType];
        
        detailVC.deletePropertyCallBack = ^(BOOL isDelete){
        
            self.isNeedRefresh = YES;
        
        };
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }

}

#pragma mark - 获取业主信息
- (void)getOwnerInfo
{

    ///参数
    NSDictionary *userInfoParams = @{@"linkman_id" : APPLICATION_NSSTRING_SETTING(self.ownerID, @"65")};
    
    ///先请求联系人信息
    [QSRequestManager requestDataWithType:rRequestTypeChatContactInfo andParams:userInfoParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///获取成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSYContactDetailReturnData *tempModel = resultData;
            self.contactInfo = tempModel;
            
            ///刷新数据
            [self.userInfoRootView reloadData];
            
            ///请求发布房源数据
            [self getOwnerReleaseHouse];
            
        } else {
            
            [self.userInfoRootView.header endRefreshing];
            
            NSString *tipsString = @"获取联系人信息失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(tipsString, 1.5f, ^(){
                
                [self.navigationController popViewControllerAnimated:YES];
                
            })
            
        }
        
    }];

}

///请求当前用户发布的所有物业信息
- (void)getOwnerReleaseHouse
{
    
    ///清空原数据，刷新UI
    [self.housesSource removeAllObjects];
    [self.userInfoRootView reloadData];

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
    NSDictionary *params = @{@"data_user_id" : APPLICATION_NSSTRING_SETTING(self.ownerID, @"")};
    
    ///请求
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSSecondHandHouseListReturnData *tempModel = resultData;
            if ([tempModel.secondHandHouseHeaderData.houseList count] > 0) {
                
                [self.housesSource addObjectsFromArray:tempModel.secondHandHouseHeaderData.houseList];
                
            }
            
            ///结束刷新
            [self.userInfoRootView reloadData];
            [self.userInfoRootView.header endRefreshing];
            
        } else {
            
            [self.userInfoRootView reloadData];
            [self.userInfoRootView.header endRefreshing];
            
        }
        
    }];

}

///请求出租房数据
- (void)getOwnerReleaseRentHouse
{

    ///封装参数
    NSDictionary *params = @{@"data_user_id" : APPLICATION_NSSTRING_SETTING(self.ownerID, @"")};
    
    ///请求
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSRentHouseListReturnData *tempModel = resultData;
            if ([tempModel.headerData.rentHouseList count] > 0) {
                
                [self.housesSource addObjectsFromArray:tempModel.headerData.rentHouseList];
                
            }
            
            ///结束刷新
            [self.userInfoRootView reloadData];
            [self.userInfoRootView.header endRefreshing];
            
        } else {
        
            [self.userInfoRootView reloadData];
            [self.userInfoRootView.header endRefreshing];
            
        }
        
    }];

}

#pragma mark - 联系业主事件
- (void)callContactOwner
{
    
    ///弹出框
    __block QSYPopCustomView *popView;
    
    QSYCallTipsPopView *callTipsView = [[QSYCallTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 130.0f, SIZE_DEVICE_WIDTH, 130.0f) andName:self.contactInfo.contactInfo.username andPhone:self.contactInfo.contactInfo.mobile andCallBack:^(CALL_TIPS_CALLBACK_ACTION_TYPE actionType) {
        
        ///回收弹框
        [popView hiddenCustomPopview];
        
        ///确认打电话
        if (cCallTipsCallBackActionTypeConfirm == actionType) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.contactInfo.contactInfo.mobile]]];
            
        }
        
    }];
    
    popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:callTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
        
    }];
    
}

#pragma mark - 将要显示时判断是否刷新
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (self.isNeedRefresh) {
        
        self.isNeedRefresh = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.userInfoRootView.header beginRefreshing];
            
        });
        
    }

}

@end
