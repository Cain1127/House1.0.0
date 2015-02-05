//
//  QSGuideSaleHouseViewController.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideSaleHouseViewController.h"
#import "QSLoginViewController.h"
#import "QSTabBarViewController.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+Filter.h"
#import "QSCustomHUDView.h"

#import <objc/runtime.h>

///关联
static char TenantSumCountDataKey;  //!<当前房客总数
static char TenantCountDataKey;     //!<当前房客总数
static char BuyerCountDataKey;      //!<当前房客总数

@interface QSGuideSaleHouseViewController ()

@end

@implementation QSGuideSaleHouseViewController

#pragma mark - UI搭建
- (void)createCustomGuideHeaderSubviewsUI:(UIView *)view
{
    
    ///小圆
    CGFloat widthOfInnercircleImageView = SIZE_DEVICE_WIDTH > 320.0f ? (SIZE_DEVICE_WIDTH > 350.0f ? 265.5f : 255.5f) : 230.5f;
    CGFloat heightOfInnercirclImageView = widthOfInnercircleImageView * 255.5f / 260.0f;
    QSImageView *innerCircleImageView = [[QSImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - widthOfInnercircleImageView) / 2.0f, (view.frame.size.height - heightOfInnercirclImageView) / 2.0f, widthOfInnercircleImageView, heightOfInnercirclImageView)];
    innerCircleImageView.image = [UIImage imageNamed:IMAGE_GUIDE_HOUSES_INNER_CIRCLE];
    [view addSubview:innerCircleImageView];
    
    ///中间信息圆:
    UIView *middleInfoRootView = [[UIView alloc] initWithFrame:CGRectMake((view.frame.size.width - 125.0f) / 2.0f, (view.frame.size.height - 125.0f) / 2.0f, 125.0f, 125.0f)];
    middleInfoRootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    middleInfoRootView.layer.cornerRadius = 125.0f / 2.0f;
    [self createTenantHouseGuideMiddleTipsUI:middleInfoRootView];
    [view addSubview:middleInfoRootView];
    
    ///租客
    UIView *tenantInfoRootView = [[UIView alloc] initWithFrame:CGRectMake(innerCircleImageView.frame.origin.x - 40.0f, view.frame.size.height / 2.0f - 40.0f, 80.0f, 80.0f)];
    tenantInfoRootView.backgroundColor = [UIColor whiteColor];
    tenantInfoRootView.layer.cornerRadius = 40.0f;
    tenantInfoRootView.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    tenantInfoRootView.layer.borderWidth = 0.5f;
    [self createTenantInfoUI:tenantInfoRootView];
    [view addSubview:tenantInfoRootView];
    
    ///购房客
    UIView *buyHouseInfoRootView = [[UIView alloc] initWithFrame:CGRectMake(innerCircleImageView.frame.origin.x + innerCircleImageView.frame.size.width - 40.0f, view.frame.size.height / 2.0f - 40.0f, 80.0f, 80.0f)];
    buyHouseInfoRootView.backgroundColor = [UIColor whiteColor];
    buyHouseInfoRootView.layer.cornerRadius = 40.0f;
    buyHouseInfoRootView.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    buyHouseInfoRootView.layer.borderWidth = 0.5f;
    [self createBuyerInfoUI:buyHouseInfoRootView];
    [view addSubview:buyHouseInfoRootView];
    
    ///说明信息
    CGFloat ypontOfHeaderLabel = SIZE_DEVICE_HEIGHT > 480.0f ? (SIZE_DEVICE_WIDTH < 350.0f ? (view.frame.size.height - 45.0f) : (view.frame.size.height - 55.0f)) : (view.frame.size.height - 35.0f);
    UILabel *headerTipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(innerCircleImageView.frame.origin.x, ypontOfHeaderLabel, innerCircleImageView.frame.size.width, 30.0f)];
    headerTipsLabel.text = TITLE_GUIDE_SALEHOUSE_HEADER_TIP;
    headerTipsLabel.textAlignment = NSTextAlignmentCenter;
    headerTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_25];
    headerTipsLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:headerTipsLabel];
    
}

///租客信息
- (void)createTenantInfoUI:(UIView *)view
{
    
    ///标题
    QSLabel *titleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f - 20.0f, view.frame.size.width - 20.0f, 20.0f)];
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    titleLabel.text = TITLE_GUIDE_SALEHOUSE_TENANT_TIP;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    ///数据
    QSLabel *dataLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f, view.frame.size.width - 20.0f, 30.0f)];
    dataLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    dataLabel.textColor = COLOR_CHARACTERS_BLACK;
    dataLabel.text = @"24,234";
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:dataLabel];
    
    objc_setAssociatedObject(self, &TenantCountDataKey, dataLabel, OBJC_ASSOCIATION_ASSIGN);
    
}

///购房客信息
- (void)createBuyerInfoUI:(UIView *)view
{
    
    ///标题
    QSLabel *titleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f - 20.0f, view.frame.size.width - 20.0f, 20.0f)];
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    titleLabel.text = TITLE_GUIDE_SALEHOUSE_BUYER_TIP;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    ///数据
    QSLabel *dataLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f, view.frame.size.width - 20.0f, 30.0f)];
    dataLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    dataLabel.textColor = COLOR_CHARACTERS_BLACK;
    dataLabel.text = @"24,234";
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:dataLabel];
    
    objc_setAssociatedObject(self, &BuyerCountDataKey, dataLabel, OBJC_ASSOCIATION_ASSIGN);
    
}

///找房指引页中间提示信息UI
- (void)createTenantHouseGuideMiddleTipsUI:(UIView *)view
{
    
    ///正在出售
    QSLabel *tipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f - 20.0f, view.frame.size.width - 20.0f, 20.0f)];
    tipLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = TITLE_GUIDE_SALEHOUSE_MIDDLE_TIP;
    [view addSubview:tipLabel];
    
    ///当前城市相关统计数据
    QSLabel *dataLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f, view.frame.size.width - 20.0f, 30.0f)];
    dataLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    dataLabel.textColor = [UIColor blackColor];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.text = @"234,234,343";
    [view addSubview:dataLabel];
    
    objc_setAssociatedObject(self, &TenantSumCountDataKey, dataLabel, OBJC_ASSOCIATION_ASSIGN);
    
}

/**
 *  @author     yangshengmeng, 15-01-20 14:01:51
 *
 *  @brief      在给定的视图上添加底部相关控件
 *
 *  @param view 底部控制
 *
 *  @since      1.0.0
 */
- (void)createCustomGuideFooterUI:(UIView *)view
{
    
    ///出售物业
    QSBlockButtonStyleModel *yellowButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    yellowButtonStyle.title = TITLE_GUIDE_SUMMARY_SALEHOUSE_SECOND_BUTTON;
    UIButton *saleHouseButton = [UIButton createBlockButtonWithButtonStyle:yellowButtonStyle andCallBack:^(UIButton *button) {
        
        ///设置用户的默认过滤器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse] andCallBack:^(BOOL isSuccess) {}];
            
        });
        
        [self gotoLoginViewController];
        
    }];
    saleHouseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:saleHouseButton];
    
    ///出租物业
    QSBlockButtonStyleModel *whiteButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    whiteButtonStyle.title = TITLE_GUIDE_SUMMARY_SALEHOUSE_RENTAL_BUTTON;
    UIButton *rentalHouseButton = [UIButton createBlockButtonWithButtonStyle:whiteButtonStyle andCallBack:^(UIButton *button) {
        
        ///设置用户的默认过滤器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse] andCallBack:^(BOOL isSuccess) {}];
            
        });
        
        [self gotoLoginViewController];
        
    }];
    rentalHouseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:rentalHouseButton];
    
    ///跳过按钮
    QSBlockButtonStyleModel *clearButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClear];
    clearButtonStyle.title = TITLE_GUIDE_SKIP_BUTTON;
    UIButton *skipButton = [UIButton createBlockButtonWithButtonStyle:clearButtonStyle andCallBack:^(UIButton *button) {
        
        ///设置用户的默认过滤器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse] andCallBack:^(BOOL isSuccess) {}];
            
        });
        
        ///进入主页
        QSTabBarViewController *homePageVC = [[QSTabBarViewController alloc] initWithCurrentIndex:0];
        [self changeWindowRootViewController:homePageVC];
        
    }];
    skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:skipButton];
    
    ///计算间隙
    CGFloat gap = (SIZE_DEVICE_HEIGHT > 480.0f) ? ((SIZE_DEVICE_WIDTH > 320.0f) ? ((SIZE_DEVICE_WIDTH > 350.0f) ? 40.0f : 30.0f) : 30.0f) : 20.0f;
    CGFloat width = (SIZE_DEVICE_WIDTH > 320.0f) ? ((SIZE_DEVICE_WIDTH > 350.0f) ? 300.0f : 240.0f) : 200.0f;
    NSDictionary *___VFLSizeDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",gap],@"gap",[NSString stringWithFormat:@"%.2f",width],@"width",nil];
    
    ///添加约束
    NSString *___hVFL_secondButton = @"H:[saleHouseButton(width)]";
    NSString *___hVFL_rentalButton = @"H:[rentalHouseButton(width)]";
    NSString *___hVFL_skipButton = @"H:[skipButton(width)]";
    NSString *___vVFL_all = @"V:|-gap-[saleHouseButton]-10-[rentalHouseButton(==saleHouseButton)]-[skipButton(==saleHouseButton)]-gap-|";
    
    ///约束参数字典
    NSDictionary *___VFLViewsDict = NSDictionaryOfVariableBindings(saleHouseButton,rentalHouseButton,skipButton);
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_secondButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:saleHouseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_rentalButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_skipButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_all options:NSLayoutFormatAlignAllCenterX metrics:___VFLSizeDict views:___VFLViewsDict]];
    
}

#pragma mark - 进入登录页面
- (void)gotoLoginViewController
{

    QSLoginViewController *loginVC = [[QSLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];

}

#pragma mark - 更新统计数据
///更新中间当前总的租客信息
- (void)updateTenantSumCount:(NSString *)sumCount
{
    
    UILabel *sumCountLabel = objc_getAssociatedObject(self, &TenantSumCountDataKey);
    if (sumCountLabel && sumCount) {
        
        sumCountLabel.text = sumCount;
        
    }
    
}

///更新租客统计数量
- (void)updateTenantCount:(NSString *)tenantCount
{
    
    UILabel *tenantLabel = objc_getAssociatedObject(self, &TenantCountDataKey);
    if (tenantLabel && tenantCount) {
        
        tenantLabel.text = tenantCount;
        
    }
    
}

///更新购房客统计数量
- (void)updateBuyerCount:(NSString *)tenantCount
{
    
    UILabel *buyerCountLabel = objc_getAssociatedObject(self, &BuyerCountDataKey);
    if (buyerCountLabel && tenantCount) {
        
        buyerCountLabel.text = tenantCount;
        
    }
    
}

#pragma mark - 已经显示找房指引页时，下载统计数据
/**
 *  @author         yangshengmeng, 15-02-04 14:02:33
 *
 *  @brief          找房指引页将要出现时，下载统计数据
 *
 *  @param animated 出现的动画
 *
 *  @since          1.0.0
 */
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    ///下载统计数据
    
    
    ///隐藏HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [hud hiddenCustomHUD];
        
    });
    
}

@end
