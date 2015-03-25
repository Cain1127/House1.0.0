//
//  QSYReleaseSaleHouseViewController.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseSaleHouseViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSReleaseSaleHouseDataModel.h"

@interface QSYReleaseSaleHouseViewController ()

///出售物业的数据模型
@property (nonatomic,retain) QSReleaseSaleHouseDataModel *saleHouseReleaseModel;

@end

@implementation QSYReleaseSaleHouseViewController

#pragma mark - 初始化
///初始化
- (instancetype)init
{

    if (self = [super init]) {
        
        ///初始化发布数据模型
        self.saleHouseReleaseModel = [[QSReleaseSaleHouseDataModel alloc] init];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"发布出售物业"];

}

- (void)createMainShowUI
{

    ///过滤条件的底view
    QSScrollView *pickedRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f - 15.0f)];
//    [self createSettingInputUI:pickedRootView];
    [self.view addSubview:pickedRootView];
    
    ///分隔线
    
    ///底部确定按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"下一步";
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        
        
    }];
    [self.view addSubview:commitButton];

}

@end
