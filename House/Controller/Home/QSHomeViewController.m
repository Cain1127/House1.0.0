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

#import "NSDate+Formatter.h"

#import "QSAutoScrollView.h"
#import "QSCollectedInfoView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCustomHUDView.h"
#import "QSCustomPickerView.h"
#import "QSImageView+Block.h"
#import "UIButton+Factory.h"

#import "QSBaseConfigurationDataModel.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSCollectedCommunityDataModel.h"
#import "QSFilterDataModel.h"
#import "QSCommunityDataModel.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+Filter.h"
#import "QSCoreDataManager+Collected.h"

#import <objc/runtime.h>

///关联
static char OneHouseTypeDataKey;    //!<一房房源关联
static char TwoHouseTypeDataKey;    //!<一房房源关联
static char ThreeHouseTypeDataKey;  //!<一房房源关联
static char FourHouseTypeDataKey;   //!<一房房源关联
static char FiveHouseTypeDataKey;   //!<一房房源关联

@interface QSHomeViewController () <QSAutoScrollViewDelegate>

@property (nonatomic,retain) NSMutableArray *collectedDataSource;//!<收藏的数据源

@end

@implementation QSHomeViewController

#pragma mark - 初始化
///初始化：获取本地收藏列表
- (instancetype)init
{

    if (self = [super init]) {
        
        ///获取本地的收藏列表
        [self collectedDataSource];
        
    }
    
    return self;

}

///返回本地收藏信息
- (NSMutableArray *)collectedDataSource
{

    if (nil == _collectedDataSource) {
        
        _collectedDataSource = [NSMutableArray arrayWithArray:[QSCoreDataManager getLocalCollectedDataSource]];
        
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
            [self loadStatisticsData];
            
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
    __block QSAutoScrollView *colledtedView = [[QSAutoScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 44.0f) andDelegate:self andScrollDirectionType:aAutoScrollDirectionTypeRightToLeft andShowPageIndex:NO andShowTime:3.0f andTapCallBack:^(id params) {
        
        ///判断是否是有效收藏
        if ([@"default" isEqualToString:params]) {
            
            ///进入选择小区收藏的页面
            QSYSearchCommunityViewController *searchCommunityVC = [[QSYSearchCommunityViewController alloc] initWithPickedCallBack:^(BOOL flag, QSCommunityDataModel *communityModel) {
                
                ///已选择
                if (flag) {
                    
                    ///转换模型
                    QSCollectedCommunityDataModel *tempModel = [[QSCollectedCommunityDataModel alloc] init];
                    
                    tempModel.collected_id = communityModel.id_;
                    tempModel.collected_time = [NSDate currentDateTimeStamp];
                    tempModel.collected_type = [NSString stringWithFormat:@"%d",fFilterMainTypeCommunity];
                    tempModel.collectid_title = communityModel.title;
                    tempModel.collected_status = @"0";
                    tempModel.collected_old_price = communityModel.price_avg;
                    tempModel.collected_new_price = communityModel.tj_last_month_price_avg;
                    
                    ///添加数据源
                    [self.collectedDataSource addObject:tempModel];
                    
                    ///刷新数据
                    [colledtedView reloadAutoScrollView];
                    
                }
                
            }];
            [self.navigationController pushViewController:searchCommunityVC animated:YES];
            
        } else {
        
            ///模型转换
            QSCollectedCommunityDataModel *model = params;
            QSCommunityDetailViewController *communityDetail = [[QSCommunityDetailViewController alloc] initWithTitle:model.collectid_title andCommunityID:model.collected_id andCommendNum:@"10" andHouseType:@"second"];
            communityDetail.hiddenCustomTabbarWhenPush = YES;
            [self hiddenBottomTabbar:YES];
            [self.navigationController pushViewController:communityDetail animated:YES];
        
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
        
        
        
    }];
    saleHouseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:saleHouseButton];
    
    ///笋盘推荐
    buttonStyle.title = @"笋盘推荐";
    buttonStyle.imagesNormal = IMAGE_HOME_COMMUNITYRECOMMAND_NORMAL;
    buttonStyle.imagesHighted = IMAGE_HOME_COMMUNITYRECOMMAND_HIGHLIGHTED;
    UIButton *recommandHouseButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH * 3.0f / 4.0f - 30.0f, saleHouseButton.frame.origin.y, saleHouseButton.frame.size.width, saleHouseButton.frame.size.height) andButtonStyle:buttonStyle andCustomButtonStyle:cCustomButtonStyleBottomTitle andTitleSize:15.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        
        
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
    UIView *oneHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, ypoint, width, height)];
    [self createHouseTypeInfoViewUI:oneHouseTypeRootView andHouseTypeTitle:@"一房房源" andDataKey:OneHouseTypeDataKey];
    [view addSubview:oneHouseTypeRootView];
    
    ///分隔线
    UILabel *oneMiddelLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(oneHouseTypeRootView.frame.origin.x + oneHouseTypeRootView.frame.size.width + 2.25f, ypoint, 0.5f, height)];
    oneMiddelLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:oneMiddelLineLabel];
    
    ///二房房源
    UIView *twoHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - width / 2.0f, ypoint, width, height)];
    [self createHouseTypeInfoViewUI:twoHouseTypeRootView andHouseTypeTitle:@"二房房源" andDataKey:TwoHouseTypeDataKey];
    [view addSubview:twoHouseTypeRootView];
    
    UILabel *twoMiddelLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f + width / 2.0f + 2.25f, ypoint, 0.5f, height)];
    twoMiddelLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:twoMiddelLineLabel];
    
    ///三房房源
    UIView *threeHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - width, ypoint, width, height)];
    [self createHouseTypeInfoViewUI:threeHouseTypeRootView andHouseTypeTitle:@"三房房源" andDataKey:ThreeHouseTypeDataKey];
    [view addSubview:threeHouseTypeRootView];
    
    ///四房房源
    UIView *foutHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - 10.0f - width, ypoint + middleGap + height, width, height)];
    [self createHouseTypeInfoViewUI:foutHouseTypeRootView andHouseTypeTitle:@"四房房源" andDataKey:FourHouseTypeDataKey];
    [view addSubview:foutHouseTypeRootView];
    
    ///分隔线
    UILabel *fourMiddelLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - 0.25f, foutHouseTypeRootView.frame.origin.y, 0.5f, height)];
    fourMiddelLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:fourMiddelLineLabel];
    
    ///五房房源
    UIView *fiveHouseTypeRootView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f + 10.0f, foutHouseTypeRootView.frame.origin.y, width, height)];
    [self createHouseTypeInfoViewUI:fiveHouseTypeRootView andHouseTypeTitle:@"五房房源" andDataKey:FiveHouseTypeDataKey];
    [view addSubview:fiveHouseTypeRootView];

}

///创建房源信息UI
- (void)createHouseTypeInfoViewUI:(UIView *)view andHouseTypeTitle:(NSString *)title andDataKey:(char)dataKey
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
    dataLabel.text = @"38234";
    dataLabel.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:dataLabel];
    objc_setAssociatedObject(self, &dataKey, dataLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///单位
    UILabel *subTitleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height - 15.0f, view.frame.size.width, 15.0f)];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    subTitleLabel.text = @"套";
    subTitleLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:subTitleLabel];

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

#pragma mark - 收藏滚动页相关配置
///返回一共有多少个收藏项，如果没有收藏，则返回一个默认的添加收藏的view
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView
{

    if ([self.collectedDataSource count] > 0) {
        
        return [self.collectedDataSource count];
        
    }
    
    return 1;

}

///返回当前的滚动view
- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    if ([self.collectedDataSource count] > 0) {
        
        QSCollectedCommunityDataModel *model = self.collectedDataSource[index];
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

#pragma mark -点击新房
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
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterMainTypeSecondHouse andIsShowNavigation:YES];
        filterVC.hiddenCustomTabbarWhenPush = YES;
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
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterMainTypeRentalHouse andIsShowNavigation:YES];
        filterVC.resetFilterCallBack = ^(BOOL flag){
        
            ///出租房过滤设置成功
            if (flag) {
                
                ///发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:nHomeRentHouseActionNotification object:@"2"];
                
                ///进入出租房列表
                self.tabBarController.selectedIndex = 1;
                
            }
        
        };
        filterVC.hiddenCustomTabbarWhenPush = YES;
        [self hiddenBottomTabbar:YES];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }

}

#pragma mark - 我要放盘
///我要放盘按钮点击
- (void)saleHouseButtonAction
{
    
    
    
}

#pragma mark - 笋盘推荐
///笋盘推荐按钮点击
- (void)communityRecommendHouseButtonAction
{
    
    
    
}

#pragma mark - 刷新数据
- (void)loadStatisticsData
{

    ///显示HUD

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

@end
