//
//  QSHomeViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHomeViewController.h"
#import "QSTabBarViewController.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSHouseKeySearchViewController.h"
#import "ColorHeader.h"
#import "QSCustomHUDView.h"
#import "QSNavigationBarPickerView.h"
#import "QSImageView+Block.h"
#import "UIButton+Factory.h"

@interface QSHomeViewController ()

@end

@implementation QSHomeViewController

#pragma mark - UI搭建
///导航栏UI创建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///中间选择城市按钮
    QSNavigationBarPickerView *cityPickerView = [[QSNavigationBarPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 40.0f) andPickerType:nNavigationBarPickerStyleTypeCity andPickerViewStyle:nNavigationBarPickerStyleRightLocal andPickedCallBack:^(NSString *cityKey, NSString *cityVal) {
        
        NSLog(@"====================首页城市选择====================");
        NSLog(@"当前选择城市：%@,%@",cityKey,cityVal);
        NSLog(@"====================首页城市选择====================");
        
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
    
    ///分隔线
    UILabel *bottomMiddelLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 0.25f, SIZE_DEVICE_HEIGHT - bottomHeight - 49.0f, 0.25f, bottomHeight)];
    bottomMiddelLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:bottomMiddelLineLabel];
    
    ///笋盘推荐
    buttonStyle.title = @"笋盘推荐";
    buttonStyle.imagesNormal = IMAGE_HOME_COMMUNITYRECOMMAND_NORMAL;
    buttonStyle.imagesHighted = IMAGE_HOME_COMMUNITYRECOMMAND_HIGHLIGHTED;
    UIButton *recommandHouseButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH * 3.0f / 4.0f - 30.0f, saleHouseButton.frame.origin.y, saleHouseButton.frame.size.width, saleHouseButton.frame.size.height) andButtonStyle:buttonStyle andCustomButtonStyle:cCustomButtonStyleBottomTitle andTitleSize:15.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        
        
    }];
    recommandHouseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:recommandHouseButton];
    
}

///创建统计信息展现UI
- (void)createHeaderInfoUI:(UIView *)view
{

    

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

    

}

#pragma mark - 二手房按钮点击
///二手房按钮点击
- (void)secondHandHouseButtonAction
{

    

}

#pragma mark - 出租房按钮点击
///出租房按钮点击
- (void)rentalHouseButtonAction
{

    

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

@end
