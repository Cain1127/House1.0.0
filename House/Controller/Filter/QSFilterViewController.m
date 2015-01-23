//
//  QSFilterViewController.m
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSFilterViewController.h"
#import "QSCoreDataManager+App.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+RightArrow.h"

@interface QSFilterViewController ()

@property (nonatomic,assign) BOOL isSettingFilter;              //!<本地过滤器是否已配置标识:YES-已配置
@property (nonatomic,assign) APPLICATION_FILTER_TYPE filterType;//!<过滤器类型

@end

@implementation QSFilterViewController

#pragma mark - 初始化
- (instancetype)initWithFilterType:(APPLICATION_FILTER_TYPE)filterType
{

    if (self = [super init]) {
        
        ///获取过滤器是否已配置标识
        self.isSettingFilter = [QSCoreDataManager getLocalFilterSettingFlag];
        
        ///保存过滤器类型
        self.filterType = filterType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    ///如果未配置过滤器，则不创建导航栏
    if (self.isSettingFilter) {
        
        [super createNavigationBarUI];
        
    }
    
}

- (void)createMainShowUI
{

    ///两种情况：已配置有过滤器时，存在导航栏，未配置时，是没有导航栏的
    if (self.isSettingFilter) {
        
        [self createUpdateFilterSettingPage];
        
    } else {
    
        [self createFirstSettingFilterPage];
    
    }

}

#pragma mark - 创建第一次设置过滤器的页面
- (void)createFirstSettingFilterPage
{

    ///头背景图片:700 x 305
    QSImageView *headerImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_WIDTH * 305.0f / 700.0f)];
    headerImageView.image = [UIImage imageNamed:IMAGE_FILTER_DEFAULT_HEADER];
    [self.view addSubview:headerImageView];
    
    ///头部提示信息
    QSLabel *titleTipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.size.height / 2.0f - 30.0f, SIZE_DEFAULT_MAX_WIDTH, 30.0f)];
    titleTipsLabel.text = TITLE_FILTER_FIRSTSETTING_HEADER_TITLE;
    titleTipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    titleTipsLabel.textAlignment = NSTextAlignmentCenter;
    titleTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    [headerImageView addSubview:titleTipsLabel];
    
    QSLabel *subTitleTipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.size.height / 2.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    subTitleTipsLabel.text = TITLE_FILTER_FIRSTSETTING_SUBHEADER_TITLE;
    subTitleTipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    subTitleTipsLabel.textAlignment = NSTextAlignmentCenter;
    subTitleTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [headerImageView addSubview:subTitleTipsLabel];
    
    ///过滤器设置底view
    UIView *filterSettingRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerImageView.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - headerImageView.frame.size.height)];
    [self createSettingInputUI:filterSettingRootView];
    [self.view addSubview:filterSettingRootView];
    
    ///看看运气如何按钮
    UIButton *commitFilterButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 54.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:[QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow] andCallBack:^(UIButton *button) {
        
        
        
    }];
    [commitFilterButton setTitle:TITLE_FILTER_FIRSTSETTING_COMMITBUTTON forState:UIControlStateNormal];
    [self.view addSubview:commitFilterButton];

}

///搭建过滤器设置信息输入栏
- (void)createSettingInputUI:(UIView *)view
{

    /**
     *  房子类型 :
     *  区域 : 
     *  户型 :
     *  购房目的 :
     *  售价 :
     *  面积 :
     *  出租方式 :
     *  租金 :
     *  面积 :
     *  租金支付方式 :
     *  楼层 :
     *  朝向 :
     *  装修 :
     *  房龄 :
     *  标签 :
     *  备注 :
     *  配套 :
     */

}

#pragma mark - 创建重新设置过滤器的页面
- (void)createUpdateFilterSettingPage
{

    

}

@end
