//
//  QSGuideLookingforRoomViewController.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideLookingforRoomViewController.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSCoreDataManager+User.h"
#import "QSFilterViewController.h"
#import "QSTabBarViewController.h"
#import "QSCustomHUDView.h"

#import "QSCoreDataManager+Filter.h"
#import "QSCoreDataManager+Guide.h"

#import <objc/runtime.h>

///关联
static char HousesSumCountKey;          //!<房源总数
static char HousesTypeOneCountKey;      //!<一房房型的统计数量
static char HousesTypeTwoCountKey;      //!<二房房型的统计数量
static char HousesTypeThreeCountKey;    //!<三房房型的统计数量
static char HousesTypeFourCountKey;     //!<四房房型的统计数量

@interface QSGuideLookingforRoomViewController ()

@property (nonatomic,copy) NSString *cityVal;//!<城市val
@property (nonatomic,copy) NSString *cityKey;//!<城市key

@end

@implementation QSGuideLookingforRoomViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-02-06 14:02:29
 *
 *  @brief          根据给定的城市创建找房指引页
 *
 *  @param cityKey  城市key
 *  @param cityVal  城市val
 *
 *  @return         返回找房指引页
 *
 *  @since          1.0.0
 */
- (instancetype)initWithCityKey:(NSString *)cityKey andCityVal:(NSString *)cityVal
{

    if (self = [super init]) {
        
        ///获取基本信息
        self.cityVal = cityVal ? cityVal : ([QSCoreDataManager getCurrentUserCity] ? [QSCoreDataManager getCurrentUserCity] : @"广州");
        self.cityKey = cityKey ? cityKey : ([QSCoreDataManager getCurrentUserCityKey] ? [QSCoreDataManager getCurrentUserCityKey] : @"4401");
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createCustomGuideHeaderSubviewsUI:(UIView *)view
{
    
    ///外层大圈
    QSImageView *bigCircleImageView = [[QSImageView alloc] initWithFrame:CGRectMake(-10.0f, (view.frame.size.height - view.frame.size.width - 20.0f) / 2.0f, view.frame.size.width + 20.0f, view.frame.size.width + 20.0f)];
    bigCircleImageView.image = [UIImage imageNamed:IMAGE_GUIDE_HEADER_BIG_CIRCLE];
    [view addSubview:bigCircleImageView];
    
    ///小圆:511 x 520
    QSImageView *innerCircleImageView = [[QSImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - 255.5f) / 2.0f, (view.frame.size.height - 260.0f) / 2.0f, 255.5f, 260.0f)];
    innerCircleImageView.image = [UIImage imageNamed:IMAGE_GUIDE_TENANT_INNER_CIRCLE];
    [view addSubview:innerCircleImageView];
    
    ///中间信息圆:
    UIView *middleInfoRootView = [[UIView alloc] initWithFrame:CGRectMake((view.frame.size.width - 125.0f) / 2.0f, (view.frame.size.height - 125.0f) / 2.0f, 125.0f, 125.0f)];
    middleInfoRootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    middleInfoRootView.layer.cornerRadius = 125.0f / 2.0f;
    [self createFindHouseGuideMiddleTipsUI:middleInfoRootView];
    [view addSubview:middleInfoRootView];
    
    ///一房源数据
    CGFloat xpontOfOneHouseRootView = SIZE_DEVICE_WIDTH > 320.0f ? (innerCircleImageView.frame.origin.x - 40.0f) : (innerCircleImageView.frame.origin.x - 30.0f);
    UIView *oneHouseInfoRootView = [[UIView alloc] initWithFrame:CGRectMake(xpontOfOneHouseRootView, view.frame.size.height / 2.0f - 40.0f, 80.0f, 80.0f)];
    oneHouseInfoRootView.backgroundColor = [UIColor whiteColor];
    oneHouseInfoRootView.layer.cornerRadius = 40.0f;
    oneHouseInfoRootView.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    oneHouseInfoRootView.layer.borderWidth = 0.5f;
    [self createHouseTypeInfoUI:oneHouseInfoRootView andTitle:TITLE_GUIDE_FINDHOUSE_HOUSETYPE_ONE_TIP andAssociatinKey:HousesTypeOneCountKey];
    [view addSubview:oneHouseInfoRootView];
    
    ///二房源数据
    CGPoint twoHousePoint = CenterRadiusPoint(CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height / 2.0f), -45.0f, innerCircleImageView.frame.size.width / 2.0f);
    UIView *twoHouseInfoRootView = [[UIView alloc] initWithFrame:CGRectMake(twoHousePoint.x - 40.0f, twoHousePoint.y - 40.0f, 80.0f, 80.0f)];
    twoHouseInfoRootView.backgroundColor = [UIColor whiteColor];
    twoHouseInfoRootView.layer.cornerRadius = 40.0f;
    twoHouseInfoRootView.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    twoHouseInfoRootView.layer.borderWidth = 0.5f;
    [self createHouseTypeInfoUI:twoHouseInfoRootView andTitle:TITLE_GUIDE_FINDHOUSE_HOUSETYPE_TWO_TIP andAssociatinKey:HousesTypeTwoCountKey];
    [view addSubview:twoHouseInfoRootView];
    
    ///三房房源数据
    CGPoint threeHousePoint = CenterRadiusPoint(CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height / 2.0f), 45.0f, innerCircleImageView.frame.size.width / 2.0f);
    UIView *threeHouseInfoRootView = [[UIView alloc] initWithFrame:CGRectMake(threeHousePoint.x - 40.0f, threeHousePoint.y - 40.0f, 80.0f, 80.0f)];
    threeHouseInfoRootView.backgroundColor = [UIColor whiteColor];
    threeHouseInfoRootView.layer.cornerRadius = 40.0f;
    threeHouseInfoRootView.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    threeHouseInfoRootView.layer.borderWidth = 0.5f;
    [self createHouseTypeInfoUI:threeHouseInfoRootView andTitle:TITLE_GUIDE_FINDHOUSE_HOUSETYPE_THREE_TIP andAssociatinKey:HousesTypeTwoCountKey];
    [view addSubview:threeHouseInfoRootView];
    
    ///四房房源数据
    CGPoint fourHousePoint = CenterRadiusPoint(CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height / 2.0f), (SIZE_DEVICE_HEIGHT > 480.0f ? ((SIZE_DEVICE_HEIGHT > 568.0f ? 125.0f : 120.0f)) : 134.0f), bigCircleImageView.frame.size.width / 2.0f);
    UIView *fourHouseInfoRootView = [[UIView alloc] initWithFrame:CGRectMake(fourHousePoint.x - 40.0f, fourHousePoint.y - 40.0f, 80.0f, 80.0f)];
    fourHouseInfoRootView.backgroundColor = [UIColor whiteColor];
    fourHouseInfoRootView.layer.cornerRadius = 40.0f;
    fourHouseInfoRootView.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    fourHouseInfoRootView.layer.borderWidth = 0.5f;
    [self createHouseTypeInfoUI:fourHouseInfoRootView andTitle:TITLE_GUIDE_FINDHOUSE_HOUSETYPE_FOUR_TIP andAssociatinKey:HousesTypeFourCountKey];
    [view addSubview:fourHouseInfoRootView];
    
}

///创建不同户型的统计信息UI
- (void)createHouseTypeInfoUI:(UIView *)view andTitle:(NSString *)title andAssociatinKey:(char)key
{
    
    ///标题
    QSLabel *titleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f - 20.0f, view.frame.size.width - 20.0f, 20.0f)];
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    ///数据
    QSLabel *dataLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f, view.frame.size.width - 20.0f, 30.0f)];
    dataLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    dataLabel.textColor = COLOR_CHARACTERS_BLACK;
    dataLabel.text = @"24,234";
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:dataLabel];
    
    objc_setAssociatedObject(self, &key, dataLabel, OBJC_ASSOCIATION_ASSIGN);
    
}

///找房指引页中间提示信息UI
- (void)createFindHouseGuideMiddleTipsUI:(UIView *)view
{
    
    ///划线图片
    QSImageView *tipImageView = [[QSImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - 115.0f) / 2.0f, (view.frame.size.height - 5.0f) / 2.0f, 115.0f, 5.0f)];
    tipImageView.image = [UIImage imageNamed:IMAGE_GUIDE_INNER_TIP];
    [view addSubview:tipImageView];
    
    ///显示当前城市
    QSLabel *cityLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f - 32.0f, 60.0f, 30.0f)];
    cityLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    cityLabel.textColor = [UIColor blackColor];
    cityLabel.textAlignment = NSTextAlignmentLeft;
    cityLabel.text = self.cityVal;
    [view addSubview:cityLabel];
    
    ///正在出售
    QSLabel *tipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 130.0f, view.frame.size.height / 2.0f - 22.0f, 120.0f, 20.0f)];
    tipLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.textAlignment = NSTextAlignmentRight;
    tipLabel.text = TITLE_GUIDE_FINDHOUSE_MIDDLE_TIP;
    [view addSubview:tipLabel];
    
    ///当前城市相关统计数据
    QSLabel *dataLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, view.frame.size.height / 2.0f + 2.0f, view.frame.size.width - 20.0f, 30.0f)];
    dataLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    dataLabel.textColor = [UIColor blackColor];
    dataLabel.textAlignment = NSTextAlignmentLeft;
    dataLabel.text = @"234,234,343";
    [view addSubview:dataLabel];
    
    objc_setAssociatedObject(self, &HousesSumCountKey, dataLabel, OBJC_ASSOCIATION_ASSIGN);
    
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
    
    ///二手房
    QSBlockButtonStyleModel *yellowButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    yellowButtonStyle.title = TITLE_GUIDE_SUMMARY_FINDHOUSE_SECOND_BUTTON;
    UIButton *secondHouseButton = [UIButton createBlockButtonWithButtonStyle:yellowButtonStyle andCallBack:^(UIButton *button) {
        
        ///设置用户的默认过滤器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            ///修改过滤器的状态
            
            ///当二手房设置为当前用户的默认过滤器
            [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse] andCallBack:^(BOOL isSuccess) {}];
            
            ///修改指引状态
            [QSCoreDataManager updateAppGuideIndexStatus:gGuideStatusUnneedDisplay];
            
        });
        
        ///进入过滤器页面
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeGuideSecondHouse];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }];
    secondHouseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:secondHouseButton];
    
    ///出租房
    QSBlockButtonStyleModel *whiteButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    whiteButtonStyle.title = TITLE_GUIDE_SUMMARY_FINDHOUSE_RENTAL_BUTTON;
    UIButton *rentalHouseButton = [UIButton createBlockButtonWithButtonStyle:whiteButtonStyle andCallBack:^(UIButton *button) {
        
        ///设置用户的默认过滤器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse] andCallBack:^(BOOL isSuccess) {}];
            
            ///修改指引状态
            [QSCoreDataManager updateAppGuideIndexStatus:gGuideStatusUnneedDisplay];
            
        });
        
        ///进入过滤器设置页面
        QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:fFilterSettingVCTypeGuideRentHouse];
        [self.navigationController pushViewController:filterVC animated:YES];
        
    }];
    rentalHouseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:rentalHouseButton];
    
    ///跳过按钮
    QSBlockButtonStyleModel *clearButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClear];
    clearButtonStyle.title = TITLE_GUIDE_SKIP_BUTTON;
    UIButton *skipButton = [UIButton createBlockButtonWithButtonStyle:clearButtonStyle andCallBack:^(UIButton *button) {
        
        ///设置用户的默认过滤器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            ///判断是否设置过，设置过，就不再设置
            NSString *defaultFilterID = [QSCoreDataManager getCurrentUserDefaultFilterID];
            if (nil == defaultFilterID || 0 >= [defaultFilterID length]) {
                
                [QSCoreDataManager updateCurrentUserDefaultFilter:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse] andCallBack:^(BOOL isSuccess) {}];
                
            }
            
            ///修改指引状态
            [QSCoreDataManager updateAppGuideIndexStatus:gGuideStatusNeedDispay];
            
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
    NSString *___hVFL_secondButton = @"H:[secondHouseButton(width)]";
    NSString *___hVFL_rentalButton = @"H:[rentalHouseButton(width)]";
    NSString *___hVFL_skipButton = @"H:[skipButton(width)]";
    NSString *___vVFL_all = @"V:|-gap-[secondHouseButton]-10-[rentalHouseButton(==secondHouseButton)]-[skipButton(==secondHouseButton)]-gap-|";
    
    ///约束参数字典
    NSDictionary *___VFLViewsDict = NSDictionaryOfVariableBindings(secondHouseButton,rentalHouseButton,skipButton);
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_secondButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:secondHouseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_rentalButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_skipButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_all options:NSLayoutFormatAlignAllCenterX metrics:___VFLSizeDict views:___VFLViewsDict]];
    
}

#pragma mark - 更新数据

///更新房源总数统计
- (void)updateHousesSumCount:(NSString *)count
{
    
    UILabel *sumCountLabel = objc_getAssociatedObject(self, &HousesSumCountKey);
    if (sumCountLabel && count) {
        
        sumCountLabel.text = count;
        
    }
    
}

///更新一房房源总数统计
- (void)updateHouseTypeOnwSumCount:(NSString *)count
{
    
    UILabel *sumCountLabel = objc_getAssociatedObject(self, &HousesTypeOneCountKey);
    if (sumCountLabel && count) {
        
        sumCountLabel.text = count;
        
    }
    
}

///更新二房房源总数统计
- (void)updateHouseTypeTwoSumCount:(NSString *)count
{
    
    UILabel *sumCountLabel = objc_getAssociatedObject(self, &HousesTypeTwoCountKey);
    if (sumCountLabel && count) {
        
        sumCountLabel.text = count;
        
    }
    
}

///更新三房房源总数统计
- (void)updateHouseTypeThreeSumCount:(NSString *)count
{
    
    UILabel *sumCountLabel = objc_getAssociatedObject(self, &HousesTypeThreeCountKey);
    if (sumCountLabel && count) {
        
        sumCountLabel.text = count;
        
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
