//
//  QSPOrderDetailBookedViewController.m
//  House
//
//  Created by CoolTea on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailBookedViewController.h"
#import "QSPOrderDetailTitleLabel.h"
#import "QSPOrderDetailShowingsTimeView.h"
#import "QSPHouseSummaryView.h"
#import "QSPOrderDetailAddressView.h"
#import "QSPOrderDetailPersonInfoView.h"
#import "QSPOrderDetalBottomButtonView.h"

@interface QSPOrderDetailBookedViewController ()

@end

@implementation QSPOrderDetailBookedViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_BOOKINGORDERSLIST];
    
}


///搭建主展示UI
- (void)createMainShowUI
{
    ///头部标题
    QSPOrderDetailTitleLabel *titleTipLabel = [[QSPOrderDetailTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 44)];
    
    [self.view addSubview:titleTipLabel];
    
    //底部按钮
    QSPOrderDetalBottomButtonView *changeOrderButtonView = [[QSPOrderDetalBottomButtonView alloc] initAtTopLeft:CGPointZero withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
        
        NSLog(@"changeOrderButton");
        
    }];
    [changeOrderButtonView setFrame:CGRectMake(changeOrderButtonView.frame.origin.x, SIZE_DEVICE_HEIGHT -changeOrderButtonView.frame.size.height, changeOrderButtonView.frame.size.width, changeOrderButtonView.frame.size.height)];
    [self.view addSubview:changeOrderButtonView];
    
    QSScrollView *scrollView = [[QSScrollView alloc] initWithFrame:CGRectMake(titleTipLabel.frame.origin.x, titleTipLabel.frame.origin.y+titleTipLabel.frame.size.height, SIZE_DEVICE_WIDTH, changeOrderButtonView.frame.origin.y-(titleTipLabel.frame.origin.y+titleTipLabel.frame.size.height))];
    [self.view addSubview:scrollView];
    
    ///看房时间
    NSArray *timeArray = [NSArray arrayWithObjects:@"",@"",@"", nil];
    QSPOrderDetailShowingsTimeView *stView = [[QSPOrderDetailShowingsTimeView alloc] initAtTopLeft:CGPointMake(0.0f, 0.0f) withTimeData:timeArray];
    [scrollView addSubview:stView];
    
    ///房源简介
    QSPHouseSummaryView *houseSView = [[QSPHouseSummaryView alloc] initAtTopLeft:CGPointMake(0.0f, stView.frame.origin.y+stView.frame.size.height) withHouseData:nil andCallBack:^(UIButton *button) {
        NSLog(@"房源 clickBt");
    }];
    [scrollView addSubview:houseSView];
    ///将房源简介引用添加进看房时间控件管理作动态高度扩展
    [stView addAfterView:&houseSView];
    
    ///地址栏
    QSPOrderDetailAddressView *addressView = [[QSPOrderDetailAddressView alloc] initAtTopLeft:CGPointMake(0.0f, houseSView.frame.origin.y+houseSView.frame.size.height) withHouseData:nil andCallBack:^(UIButton *button) {
        
        NSLog(@"地图定位 clickBt");
        
    }];
    [scrollView addSubview:addressView];
    ///将地址栏引用添加进看房时间控件管理作动态高度扩展
    [stView addAfterView:&addressView];
    
    //业主信息栏
    QSPOrderDetailPersonInfoView *personView = [[QSPOrderDetailPersonInfoView alloc] initAtTopLeft:CGPointMake(0.0f, addressView.frame.origin.y+addressView.frame.size.height) withHouseData:nil andCallBack:^(UIButton *button) {
        
        NSLog(@"askButton");
        
    }];
    [scrollView addSubview:personView];
    ///将业主信息栏引用添加进看房时间控件管理作动态高度扩展
    [stView addAfterView:&personView];

    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, personView.frame.origin.y+personView.frame.size.height)];
    
}

@end
