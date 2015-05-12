//
//  QSHomeViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHomeViewController.h"
#import "QSTabBarViewController.h"
#import "QSFilterViewController.h"
#import "QSHouseKeySearchViewController.h"
#import "QSCommunityDetailViewController.h"
#import "QSYSearchCommunityViewController.h"
#import "QSYReleaseSaleHouseViewController.h"
#import "QSYReleaseRentHouseViewController.h"
#import "QSYHomeRecommendSecondHouseViewController.h"
#import "QSLoginViewController.h"

#import "NSDate+Formatter.h"

#import "QSAutoScrollView.h"
#import "QSCollectedInfoView.h"
#import "QSYPopCustomView.h"
#import "QSYSaleOrRentHouseTipsView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCustomHUDView.h"
#import "QSCustomPickerView.h"
#import "QSImageView+Block.h"
#import "UIButton+Factory.h"

#import "QSYHomeReturnData.h"
#import "QSBaseConfigurationDataModel.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSFilterDataModel.h"
#import "QSCommunityDataModel.h"
#import "QSWCommunityDataModel.h"
#import "QSCommunityHouseDetailDataModel.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+Filter.h"
#import "QSCoreDataManager+Collected.h"

#import "QSRequestManager.h"

#import <objc/runtime.h>

///户型单击事件
typedef enum
{

    hHeaderHouseTypeActionOne = 4823,   //!<1房房源
    hHeaderHouseTypeActionTwo,          //!<2房房源
    hHeaderHouseTypeActionThree,        //!<3房房源
    hHeaderHouseTypeActionFour,         //!<4房房源
    hHeaderHouseTypeActionFive,         //!<5房房源

}HEADER_HOUSETYPE_ACTION;

///关联
static char OneHouseTypeDataKey;    //!<一房房源关联
static char TwoHouseTypeDataKey;    //!<一房房源关联
static char ThreeHouseTypeDataKey;  //!<一房房源关联
static char FourHouseTypeDataKey;   //!<一房房源关联
static char FiveHouseTypeDataKey;   //!<一房房源关联

@interface QSHomeViewController () <QSAutoScrollViewDelegate>

@property (nonatomic,retain) NSMutableArray *collectedDataSource;   //!<收藏的数据源
@property (nonatomic,assign) BOOL isRequestCollectedData;           //!<是否请求收藏数据

@end

@implementation QSHomeViewController

#pragma mark - 获取本地收藏数据
///返回本地收藏信息
- (NSMutableArray *)collectedDataSource
{

    if (nil == _collectedDataSource) {
        
        _collectedDataSource = [NSMutableArray arrayWithArray:[QSCoreDataManager getLocalCollectedDataSourceWithType:fFilterMainTypeCommunity]];
        
    }
    
    return _collectedDataSource;

}

#pragma mark - UI搭建
///导航栏UI创建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///中间选择城市按钮
    QSCustomPickerView *cityPickerView = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andPickerType:cCustomPickerTypeNavigationBarCity andPickerViewStyle:cCustomPickerStyleRightLocal andCurrentSelectedModel:nil andIndicaterCenterXPoint:0.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *cityKey, NSString *cityVal) {
        
        ///判断选择
        if (pPickerCallBackActionTypePicked == callBackType) {
            
            ///获取本地用户的默认城市信息
            QSBaseConfigurationDataModel *userCityModel = [QSCoreDataManager getCurrentUserCityModel];
            
            ///判断是否相同
            if ([userCityModel.key isEqualToString:cityKey]) {
                
                return;
                
            }
                        
            ///更新当前用户的城市
            QSCDBaseConfigurationDataModel *tempCityModel = [QSCoreDataManager getCityModelWithCityKey:cityKey];
            [QSCoreDataManager updateCurrentUserCity:tempCityModel];
            
            ///更新当前过滤器
            [QSCoreDataManager createFilterWithCityKey:tempCityModel.key];
            
            ///刷新统计数据
            [self requestHomeCountData];
            
            ///发送用户默认城市变更的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:nUserDefaultCityChanged object:nil];
            
        }
        
    }];
    [self setNavigationBarMiddleView:cityPickerView];
    
    ///添加右侧搜索按钮
    UIButton *searchButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeSearch] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoSearchViewController];
        
    }];
    [self setNavigationBarRightView:searchButton];

}

///主展示信息UI创建
-(void)createMainShowUI
{
    
    [super createMainShowUI];
    
    ///收藏滚动条
    __block QSAutoScrollView *colledtedView = [[QSAutoScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 44.0f) andDelegate:self andScrollDirectionType:aAutoScrollDirectionTypeTopToBottom andShowPageIndex:NO isAutoScroll:YES andShowTime:3.0f andTapCallBack:^(id params) {
        
        ///判断是否是有效收藏
        if ([@"default" isEqualToString:params]) {
            
            ///进入选择小区收藏的页面
            QSYSearchCommunityViewController *searchCommunityVC = [[QSYSearchCommunityViewController alloc] initWithPickedCallBack:^(BOOL flag, QSCommunityDataModel *communityModel) {
                
                ///已选择
                if (flag) {
                    
                    ///保存数据
                    [QSCoreDataManager saveCollectedDataWithModel:communityModel andCollectedType:fFilterMainTypeCommunity andCallBack:^(BOOL flag) {
                        
                        ///打印保存信息
                        if (flag) {
                            
                            APPLICATION_LOG_INFO(@"分享保存本地", @"成功")
                            
                        } else {
                        
                            APPLICATION_LOG_INFO(@"分享保存本地", @"失败")
                        
                        }
                        
                    }];
                    
                }
                
            }];
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:searchCommunityVC animated:YES];
            
        } else {
        
            ///模型转换
            QSCommunityHouseDetailDataModel *tempModel = params;
            QSCommunityDetailViewController *communityDetail = [[QSCommunityDetailViewController alloc] initWithTitle:tempModel.village.title andCommunityID:tempModel.village.id_ andCommendNum:@"10" andHouseType:@"second"];
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:communityDetail animated:YES];
        
        }
        
    }];
    
    ///绑定分享改变时的事件回调
    [QSCoreDataManager setCoredataChangeCallBack:cCoredataDataTypeCommunityIntention andCallBack:^(COREDATA_DATA_TYPE dataType, DATA_CHANGE_TYPE changeType,NSString *paramsID,id params) {
        
        if (changeType == dDataChangeTypeIncrease ||
            changeType == dDataChangeTypeReduce) {
            
            ///刷新数据源
            if (nil == _collectedDataSource) {
                
                _collectedDataSource = [NSMutableArray arrayWithArray:[QSCoreDataManager getLocalCollectedDataSourceWithType:fFilterMainTypeCommunity]];
                
            } else {
            
                [_collectedDataSource removeAllObjects];
                [_collectedDataSource addObjectsFromArray:[NSMutableArray arrayWithArray:[QSCoreDataManager getLocalCollectedDataSourceWithType:fFilterMainTypeCommunity]]];
            
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [colledtedView reloadAutoScrollView];
                
            });
            
        }
        
    }];
    
    [self.view addSubview:colledtedView];
    
    ///分隔线
    UILabel *collectedLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, colledtedView.frame.origin.y + colledtedView.frame.size.height - 0.25f, SIZE_DEVICE_WIDTH, 0.25f)];
    collectedLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:collectedLineLabel];
    
    ///放盘按钮的区域高度
    CGFloat bottomHeight = SIZE_DEVICE_HEIGHT >= 667.0f ? (SIZE_DEVICE_HEIGHT >= 736.0f ? 110.0f : 90.0f) : (SIZE_DEVICE_HEIGHT >= 568.0f ? 70.0f : 60.0f);
    
    ///背景图片:750 x 640
    QSImageView *headerBGImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 108.0f, SIZE_DEVICE_WIDTH, (SIZE_DEVICE_HEIGHT >= 568 ? (SIZE_DEVICE_WIDTH * 640.0f / 750.0f) : 213.0f))];
    headerBGImageView.image = [UIImage imageNamed:IMAGE_HOME_BACKGROUD];
    [self createHeaderInfoUI:headerBGImageView];
    [self.view addSubview:headerBGImageView];
    
    ///并排按钮的底view
    CGFloat heightOfHousesButton = SIZE_DEVICE_HEIGHT > 666.0f ? 80.0f : (SIZE_DEVICE_HEIGHT * 80.0f / 667.0f);
    UIView *housesButtonRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerBGImageView.frame.origin.y + headerBGImageView.frame.size.height - heightOfHousesButton / 2.0f, SIZE_DEVICE_WIDTH, heightOfHousesButton)];
    housesButtonRootView.backgroundColor = [UIColor clearColor];
    [self createHouseTypeButtonUI:housesButtonRootView];
    [self.view addSubview:housesButtonRootView];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - bottomHeight - 49.0f, SIZE_DEVICE_WIDTH, 0.5f)];
    bottomLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:bottomLineLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_GRAY;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_16];
    
    ///我要放盘
    buttonStyle.title = @"我要放盘";
    buttonStyle.imagesNormal = IMAGE_HOME_SALEHOUSE_NORMAL;
    buttonStyle.imagesHighted = IMAGE_HOME_SALEHOUSE_HIGHLIGHTED;
    UIButton *saleHouseButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 4.0f - 30.0f, bottomLineLabel.frame.origin.y + (bottomHeight - 47.0f) / 2.0f, 80.0f, 47.0f) andButtonStyle:buttonStyle andCustomButtonStyle:cCustomButtonStyleBottomTitle andTitleSize:15.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        ///登录检测
        [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
            
            ///登录后，进入发布出租/出售页面提示
            if (lLoginCheckActionTypeLogined == flag) {
                
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
            
        }];
        
    }];
    saleHouseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:saleHouseButton];
    
    ///笋盘推荐
    buttonStyle.title = @"笋盘推荐";
    buttonStyle.imagesNormal = IMAGE_HOME_COMMUNITYRECOMMAND_NORMAL;
    buttonStyle.imagesHighted = IMAGE_HOME_COMMUNITYRECOMMAND_HIGHLIGHTED;
    UIButton *recommandHouseButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH * 3.0f / 4.0f - 30.0f, saleHouseButton.frame.origin.y, saleHouseButton.frame.size.width, saleHouseButton.frame.size.height) andButtonStyle:buttonStyle andCustomButtonStyle:cCustomButtonStyleBottomTitle andTitleSize:15.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        QSYHomeRecommendSecondHouseViewController *recommendSecondHouseVC = [[QSYHomeRecommendSecondHouseViewController alloc] init];
        [self hiddenBottomTabbar:YES];
        [self.navigationController pushViewController:recommendSecondHouseVC animated:YES];
        
    }];
    recommandHouseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:recommandHouseButton];
    
    ///分隔线
    UILabel *bottomMiddelLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 0.25f, SIZE_DEVICE_HEIGHT - bottomHeight - 49.0f, 0.5f, bottomHeight)];
    bottomMiddelLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:bottomMiddelLineLabel];
    
}

///创建统计信息展现UI
- (void)createHeaderInfoUI:(UIView *)view
{

    ///计算相关尺寸
    CGFloat ypoint = SIZE_DEVICE_HEIGHT > 480.5f ? (view.frame.size.height * 50.0f / 320.0f) : 10.0f;
    CGFloat middleGap = view.frame.size.height * 30.0f / 320.0f;
    CGFloat height = 75.0f;
    CGFloat width = (view.frame.size.width - 10.0f) / 3.0f;
    
    ///一房房源
    UITapGestureRecognizer *singleTapGestureOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseTypeSingleTapAction:)];
    singleTapGestureOne.numberOfTapsRequired = 1;
    singleTapGestureOne.numberOfTouchesRequired = 1;
    
    UIView *oneHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, ypoint, width, height)];
    UIView *oneLabel = [self createHouseTypeInfoViewUI:oneHouseTypeRootView andHouseTypeTitle:@"一房房源"];
    oneHouseTypeRootView.tag = hHeaderHouseTypeActionOne;
    [view addSubview:oneHouseTypeRootView];
    [oneHouseTypeRootView addGestureRecognizer:singleTapGestureOne];
    objc_setAssociatedObject(self, &OneHouseTypeDataKey, oneLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *oneMiddelLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(oneHouseTypeRootView.frame.origin.x + oneHouseTypeRootView.frame.size.width + 2.25f, ypoint, 0.5f, height)];
    oneMiddelLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:oneMiddelLineLabel];
    
    ///二房房源
    UITapGestureRecognizer *singleTapGestureTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseTypeSingleTapAction:)];
    singleTapGestureTwo.numberOfTapsRequired = 1;
    singleTapGestureTwo.numberOfTouchesRequired = 1;
    
    UIView *twoHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - width / 2.0f, ypoint, width, height)];
    UIView *twoLabel = [self createHouseTypeInfoViewUI:twoHouseTypeRootView andHouseTypeTitle:@"二房房源"];
    twoHouseTypeRootView.tag = hHeaderHouseTypeActionTwo;
    [view addSubview:twoHouseTypeRootView];
    [twoHouseTypeRootView addGestureRecognizer:singleTapGestureTwo];
    objc_setAssociatedObject(self, &TwoHouseTypeDataKey, twoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *twoMiddelLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f + width / 2.0f + 2.25f, ypoint, 0.5f, height)];
    twoMiddelLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:twoMiddelLineLabel];
    
    ///三房房源
    UITapGestureRecognizer *singleTapGestureThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseTypeSingleTapAction:)];
    singleTapGestureThree.numberOfTapsRequired = 1;
    singleTapGestureThree.numberOfTouchesRequired = 1;
    
    UIView *threeHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - width, ypoint, width, height)];
    UIView *threeLabel = [self createHouseTypeInfoViewUI:threeHouseTypeRootView andHouseTypeTitle:@"三房房源"];
    threeHouseTypeRootView.tag = hHeaderHouseTypeActionThree;
    [view addSubview:threeHouseTypeRootView];
    [threeHouseTypeRootView addGestureRecognizer:singleTapGestureThree];
    objc_setAssociatedObject(self, &ThreeHouseTypeDataKey, threeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///四房房源
    UITapGestureRecognizer *singleTapGestureFour = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseTypeSingleTapAction:)];
    singleTapGestureFour.numberOfTapsRequired = 1;
    singleTapGestureFour.numberOfTouchesRequired = 1;
    
    UIView *fourHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - 10.0f - width, ypoint + middleGap + height, width, height)];
    UIView *fourLabel = [self createHouseTypeInfoViewUI:fourHouseTypeRootView andHouseTypeTitle:@"四房房源"];
    fourHouseTypeRootView.tag = hHeaderHouseTypeActionFour;
    [view addSubview:fourHouseTypeRootView];
    [fourHouseTypeRootView addGestureRecognizer:singleTapGestureFour];
    objc_setAssociatedObject(self, &FourHouseTypeDataKey, fourLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *fourMiddelLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - 0.25f, fourHouseTypeRootView.frame.origin.y, 0.5f, height)];
    fourMiddelLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:fourMiddelLineLabel];
    
    ///五房房源
    UITapGestureRecognizer *singleTapGestureFive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseTypeSingleTapAction:)];
    singleTapGestureFive.numberOfTapsRequired = 1;
    singleTapGestureFive.numberOfTouchesRequired = 1;
    
    UIView *fiveHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f + 10.0f, fourHouseTypeRootView.frame.origin.y, width, height)];
    UIView *fiveLabel = [self createHouseTypeInfoViewUI:fiveHouseTypeRootView andHouseTypeTitle:@"五房房源"];
    fiveHouseTypeRootView.tag = hHeaderHouseTypeActionFive;
    [view addSubview:fiveHouseTypeRootView];
    [fiveHouseTypeRootView addGestureRecognizer:singleTapGestureFive];
    objc_setAssociatedObject(self, &FiveHouseTypeDataKey, fiveLabel, OBJC_ASSOCIATION_ASSIGN);

}

///创建房源信息UI
- (UIView *)createHouseTypeInfoViewUI:(UIView *)view andHouseTypeTitle:(NSString *)title
{

    ///标题
    UILabel *titleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, 15.0f)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    titleLabel.text = title;
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:titleLabel];
    
    ///统计数量
    UILabel *dataLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.size.height + 10.0f, view.frame.size.width, 30.0f)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.font = [UIFont systemFontOfSize:FONT_BODY_25];
    dataLabel.text = @"0";
    dataLabel.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:dataLabel];
    
    ///单位
    UILabel *subTitleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height - 15.0f, view.frame.size.width, 15.0f)];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    subTitleLabel.text = @"套";
    subTitleLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:subTitleLabel];
    
    return dataLabel;

}

///新房、二手房和出租房三个按钮的UI
- (void)createHouseTypeButtonUI:(UIView *)view
{

    ///按钮的宽度
    CGFloat height = view.frame.size.height;
    CGFloat width = height * 140.0f / 160.0f;
    
    ///每个图片的间隙
    CGFloat gap = (view.frame.size.width - 3.0f * width) / 4.0f;
    
    ///新房
    UIImageView *newHouse = [QSImageView createBlockImageViewWithFrame:CGRectMake(gap, 0.0f, width, height) andSingleTapCallBack:^{
        
        [self newHouseButtonAction];
        
    }];
    newHouse.image = [UIImage imageNamed:IMAGE_HOME_NEWHOUSEBUTTON_NORMAL];
    newHouse.highlightedImage = [UIImage imageNamed:IMAGE_HOME_NEWHOUSEBUTTON_HIGHLIGHTED];
    [view addSubview:newHouse];
    
    ///说明信息
    UILabel *newTipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 20.0f)];
    newTipsLabel.text = @"新房";
    newTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    newTipsLabel.font = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_16 : FONT_BODY_12)];
    newTipsLabel.textAlignment = NSTextAlignmentCenter;
    newTipsLabel.center = CGPointMake(newHouse.frame.size.width / 2.0f, newHouse.frame.size.height / 2.0f + 12.0f);
    [newHouse addSubview:newTipsLabel];
    
    ///二手房
    UIImageView *secondHandHouse = [QSImageView createBlockImageViewWithFrame:CGRectMake(view.frame.size.width / 2.0f - width / 2.0f, 0.0f, width, height) andSingleTapCallBack:^{
        
        [self secondHandHouseButtonAction];
        
    }];
    secondHandHouse.image = [UIImage imageNamed:IMAGE_HOME_SECONDEHOUSEBUTTON_NORMAL];
    secondHandHouse.highlightedImage = [UIImage imageNamed:IMAGE_HOME_SECONDEHOUSEBUTTON_HIGHLIGHTED];
    [view addSubview:secondHandHouse];
    
    ///说明信息
    UILabel *secondTipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 20.0f)];
    secondTipsLabel.text = @"二手房";
    secondTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    secondTipsLabel.font = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_16 : FONT_BODY_12)];
    secondTipsLabel.textAlignment = NSTextAlignmentCenter;
    secondTipsLabel.center = CGPointMake(secondHandHouse.frame.size.width / 2.0f, secondHandHouse.frame.size.height / 2.0f + 12.0f);
    [secondHandHouse addSubview:secondTipsLabel];
    
    ///出租房
    UIImageView *renantHouse = [QSImageView createBlockImageViewWithFrame:CGRectMake(secondHandHouse.frame.size.width + secondHandHouse.frame.origin.x + gap, 0.0f, width, height) andSingleTapCallBack:^{
        
        [self rentalHouseButtonAction];
        
    }];
    renantHouse.image = [UIImage imageNamed:IMAGE_HOME_RENANTHOUSEBUTTON_NORMAL];
    renantHouse.highlightedImage = [UIImage imageNamed:IMAGE_HOME_RENANTHOUSEBUTTON_HIGHLIGHTED];
    [view addSubview:renantHouse];
    
    ///说明信息
    UILabel *renantTipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 20.0f)];
    renantTipsLabel.text = @"租房";
    renantTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    renantTipsLabel.font = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_16 : FONT_BODY_12)];
    renantTipsLabel.textAlignment = NSTextAlignmentCenter;
    renantTipsLabel.center = CGPointMake(renantHouse.frame.size.width / 2.0f, renantHouse.frame.size.height / 2.0f + 12.0f);
    [renantHouse addSubview:renantTipsLabel];

}

#pragma mark - 点击户型统计
- (void)houseTypeSingleTapAction:(UITapGestureRecognizer *)tap
{

    int tempTag = tap.view.tag;
    switch (tempTag) {
            ///一房房源
        case hHeaderHouseTypeActionOne:
        {
        
            ///获取本地过滤
            QSFilterDataModel *filterModel = [QSCoreDataManager getLocalFilterWithType:fFilterMainTypeSecondHouse];
            
            ///设置过滤器为有效状态
            filterModel.filter_status = @"2";
            
            ///清空过滤条件
            [filterModel clearFilterInfo];
            
            ///设置户型
            filterModel.house_type_key = @"1";
            filterModel.house_type_val = @"一室";
            
            ///保存过滤器
            [QSCoreDataManager updateFilterWithType:fFilterMainTypeSecondHouse andFilterDataModel:filterModel andUpdateCallBack:^(BOOL isSuccess) {
                
                ///发送过滤器改动通知
                [[NSNotificationCenter defaultCenter] postNotificationName:nHouseMapListFilterInfoChanggeActionNotification object:filterModel.filter_id];
                
                ///显示房源
                self.tabBarController.selectedIndex = 1;
                
            }];
            
            return;
        
        }
            
            ///两房房源
        case hHeaderHouseTypeActionTwo:
        {
        
            ///获取本地过滤
            QSFilterDataModel *filterModel = [QSCoreDataManager getLocalFilterWithType:fFilterMainTypeSecondHouse];
            
            ///设置过滤器为有效状态
            filterModel.filter_status = @"2";
            
            ///清空过滤条件
            [filterModel clearFilterInfo];
            
            ///设置户型
            filterModel.house_type_key = @"2";
            filterModel.house_type_val = @"二室";
            
            ///保存过滤器
            [QSCoreDataManager updateFilterWithType:fFilterMainTypeSecondHouse andFilterDataModel:filterModel andUpdateCallBack:^(BOOL isSuccess) {
                
                ///发送过滤器改动通知
                [[NSNotificationCenter defaultCenter] postNotificationName:nHouseMapListFilterInfoChanggeActionNotification object:filterModel.filter_id];
                
                ///显示房源
                self.tabBarController.selectedIndex = 1;
                
            }];
            
            return;
        
        }
            
            ///三房房源
        case hHeaderHouseTypeActionThree:
        {
        
            ///获取本地过滤
            QSFilterDataModel *filterModel = [QSCoreDataManager getLocalFilterWithType:fFilterMainTypeSecondHouse];
            
            ///设置过滤器为有效状态
            filterModel.filter_status = @"2";
            
            ///清空过滤条件
            [filterModel clearFilterInfo];
            
            ///设置户型
            filterModel.house_type_key = @"3";
            filterModel.house_type_val = @"三室";
            
            ///保存过滤器
            [QSCoreDataManager updateFilterWithType:fFilterMainTypeSecondHouse andFilterDataModel:filterModel andUpdateCallBack:^(BOOL isSuccess) {
                
                ///发送过滤器改动通知
                [[NSNotificationCenter defaultCenter] postNotificationName:nHouseMapListFilterInfoChanggeActionNotification object:filterModel.filter_id];
                
                ///显示房源
                self.tabBarController.selectedIndex = 1;
                
            }];
            
            return;
        
        }
            
            ///四房房源
        case hHeaderHouseTypeActionFour:
        {
        
            ///获取本地过滤
            QSFilterDataModel *filterModel = [QSCoreDataManager getLocalFilterWithType:fFilterMainTypeSecondHouse];
            
            ///设置过滤器为有效状态
            filterModel.filter_status = @"2";
            
            ///清空过滤条件
            [filterModel clearFilterInfo];
            
            ///设置户型
            filterModel.house_type_key = @"4";
            filterModel.house_type_val = @"四室";
            
            ///保存过滤器
            [QSCoreDataManager updateFilterWithType:fFilterMainTypeSecondHouse andFilterDataModel:filterModel andUpdateCallBack:^(BOOL isSuccess) {
                
                ///发送过滤器改动通知
                [[NSNotificationCenter defaultCenter] postNotificationName:nHouseMapListFilterInfoChanggeActionNotification object:filterModel.filter_id];
                
                ///显示房源
                self.tabBarController.selectedIndex = 1;
                
            }];
            
            return;
        
        }
            
            ///五房房源
        case hHeaderHouseTypeActionFive:
        {
        
            ///获取本地过滤
            QSFilterDataModel *filterModel = [QSCoreDataManager getLocalFilterWithType:fFilterMainTypeSecondHouse];
            
            ///设置过滤器为有效状态
            filterModel.filter_status = @"2";
            
            ///清空过滤条件
            [filterModel clearFilterInfo];
            
            ///设置户型
            filterModel.house_type_key = @"5";
            filterModel.house_type_val = @"五室";
            
            ///保存过滤器
            [QSCoreDataManager updateFilterWithType:fFilterMainTypeSecondHouse andFilterDataModel:filterModel andUpdateCallBack:^(BOOL isSuccess) {
                
                ///发送过滤器改动通知
                [[NSNotificationCenter defaultCenter] postNotificationName:nHouseMapListFilterInfoChanggeActionNotification object:filterModel.filter_id];
                
                ///显示房源
                self.tabBarController.selectedIndex = 1;
                
            }];
            
            return;
        
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 收藏滚动页相关配置
///返回一共有多少个收藏项，如果没有收藏，则返回一个默认的添加收藏的view
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView
{

    if ([self.collectedDataSource count] > 0) {
        
        return (int)[self.collectedDataSource count];
        
    }
    
    return 1;

}

///返回当前的滚动view
- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    if ([self.collectedDataSource count] > 0) {
        
        QSCommunityHouseDetailDataModel *model = self.collectedDataSource[index];
        QSCollectedInfoView *defaultView = [[QSCollectedInfoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, autoScrollView.frame.size.width, autoScrollView.frame.size.height) andViewType:cCollectedInfoViewTypeAcivity];
        [defaultView updateCollectedInfoViewUI:model];
        
        return defaultView;
        
    } else {
    
        QSCollectedInfoView *defaultView = [[QSCollectedInfoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, autoScrollView.frame.size.width, autoScrollView.frame.size.height) andViewType:cCollectedInfoViewTypeDefault];
        
        return defaultView;
    
    }

}

///返回当前页点击时的回调参数
- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    if ([self.collectedDataSource count] > 0) {
        
        return self.collectedDataSource[index];
        
    } else {
    
        return @"default";
        
    }

}

#pragma mark - 进入搜索页面
///进入搜索页
- (void)gotoSearchViewController
{
    
    ///显示房源列表，并进入搜索页
    self.tabBarController.selectedIndex = 1;
    
    UIViewController *housesVC = self.tabBarController.viewControllers[1];
    
    ///判断是ViewController还是NavigationController
    if ([housesVC isKindOfClass:[UINavigationController class]]) {
        
        housesVC = ((UINavigationController *)housesVC).viewControllers[0];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([housesVC respondsToSelector:@selector(gotoSearchViewController)]) {
            
            [housesVC performSelector:@selector(gotoSearchViewController)];
            
        }
        
    });
    
}

#pragma mark - 点击新房
///点击新房
- (void)newHouseButtonAction
{
    
    ///发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:nHomeNewHouseActionNotification object:@"1"];
    
    ///进入新房列表
    self.tabBarController.selectedIndex = 1;
    
}

#pragma mark - 二手房按钮点击
///二手房按钮点击
- (void)secondHandHouseButtonAction
{

    QSFilterDataModel *filterModel = [QSCoreDataManager getLocalFilterWithType:fFilterMainTypeSecondHouse];
    
    ///获取过滤器是否已配置标识
    FILTER_STATUS_TYPE filterStatus = [filterModel.filter_status intValue];
    
    ///判断当前过滤器的状态
    if (fFilterStatusTypeWorking == filterStatus) {
        
        ///发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:nHomeSecondHandHouseActionNotification object:@"3"];
        
        ///进入二手房列表
        self.tabBarController.selectedIndex = 1;
        
    } else {
        
        ///弹出二手房设置过滤的页面
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeHomeSecondHouse];
        [self hiddenBottomTabbar:YES];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }

}

#pragma mark - 出租房按钮点击
///出租房按钮点击
- (void)rentalHouseButtonAction
{

    QSFilterDataModel *filterModel = [QSCoreDataManager getLocalFilterWithType:fFilterMainTypeRentalHouse];
    
    ///获取过滤器是否已配置标识
    FILTER_STATUS_TYPE filterStatus = [filterModel.filter_status intValue];
    
    ///判断当前过滤器的状态
    if (fFilterStatusTypeWorking == filterStatus) {
        
        ///发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:nHomeRentHouseActionNotification object:@"2"];
        
        ///进入出租房列表
        self.tabBarController.selectedIndex = 1;
        
    } else {
        
        ///弹出出租房设置过滤的页面
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeHomeRentHouse];
        filterVC.resetFilterCallBack = ^(BOOL flag){
        
            ///出租房过滤设置成功
            if (flag) {
                
                ///发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:nHomeRentHouseActionNotification object:@"2"];
                
                ///进入出租房列表
                self.tabBarController.selectedIndex = 1;
                
            }
        
        };
        [self hiddenBottomTabbar:YES];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }

}

#pragma mark - 刷新数据
///刷新UI
- (void)updateHouseCountData:(QSYHomeReturnData *)model
{
    
    ///一房房源
    [self updateOneHouseTypeData:model.headerData.house_shi_1];
    
    ///二房房源
    [self updateTwoHouseTypeData:model.headerData.house_shi_2];
    
    ///三房房源
    [self updateThreeHouseTypeData:model.headerData.house_shi_3];
    
    ///四房房源
    [self updateFourHouseTypeData:model.headerData.house_shi_4];
    
    ///五房房源
    [self updateFiveHouseTypeData:model.headerData.house_shi_5];
    
}

#pragma mark - 更新数据
///更新一房房源数据
- (void)updateOneHouseTypeData:(NSString *)count
{

    UILabel *dataLabel = objc_getAssociatedObject(self, &OneHouseTypeDataKey);
    if (dataLabel && count) {
        
        dataLabel.text = count;
        
    }

}

///更新二房房源数据
- (void)updateTwoHouseTypeData:(NSString *)count
{
    
    UILabel *dataLabel = objc_getAssociatedObject(self, &TwoHouseTypeDataKey);
    if (dataLabel && count) {
        
        dataLabel.text = count;
        
    }
    
}

///更新三房房源数据
- (void)updateThreeHouseTypeData:(NSString *)count
{
    
    UILabel *dataLabel = objc_getAssociatedObject(self, &ThreeHouseTypeDataKey);
    if (dataLabel && count) {
        
        dataLabel.text = count;
        
    }
    
}

///更新四房房源数据
- (void)updateFourHouseTypeData:(NSString *)count
{
    
    UILabel *dataLabel = objc_getAssociatedObject(self, &FourHouseTypeDataKey);
    if (dataLabel && count) {
        
        dataLabel.text = count;
        
    }
    
}

///更新五房房源数据
- (void)updateFiveHouseTypeData:(NSString *)count
{
    
    UILabel *dataLabel = objc_getAssociatedObject(self, &FiveHouseTypeDataKey);
    if (dataLabel && count) {
        
        dataLabel.text = count;
        
    }
    
}

#pragma mark - 请求数据
///请求数据
- (void)requestHomeCountData
{

    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    ///获取城市信息
    NSString *cityID = [QSCoreDataManager getCurrentUserCityKey];
    NSDictionary *params = @{@"cityid" : cityID ? cityID : @""};
    
    ///请求数据
    [QSRequestManager requestDataWithType:rRequestTypeHomeCountData andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYHomeReturnData *tempModel = resultData;
            
            ///刷新UI
            [self updateHouseCountData:tempModel];
            
            [hud hiddenCustomHUDWithFooterTips:@"加载成功" andDelayTime:1.0f];
                        
        } else {
        
            ///显示提示信息
            [hud hiddenCustomHUDWithFooterTips:@"您的网络不给力哦" andDelayTime:1.0f];
        
        }
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self hiddenBottomTabbar:NO];
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///请求数据
        [self requestHomeCountData];
        
    });
    
}

@end
