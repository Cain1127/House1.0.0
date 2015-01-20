//
//  QSGuideSummaryView.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideSummaryView.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSWDeveloperHomeViewController.h"


@implementation QSGuideSummaryView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///搭建UI
        [self createGuideSummaryUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
/**
 *  @author yangshengmeng, 15-01-20 11:01:13
 *
 *  @brief  搭建汇总指引页的UI
 *
 *  @since  1.0.0
 */
- (void)createGuideSummaryUI
{

    ///我要找房
    QSBlockButtonStyleModel *yellowButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    yellowButtonStyle.title = TITLE_GUIDE_SUMMARY_FINDHOUSE_BUTTON;
    UIButton *findHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 160.0f)/2.0f, SIZE_DEVICE_HEIGHT - 20.0f - 44.0f * 2.0f - 8.0f, 160.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:yellowButtonStyle andCallBack:^(UIButton *button) {
        
        [self findHouse];
        
    }];
    [self addSubview:findHouseButton];
    
    ///我要放房
    QSBlockButtonStyleModel *whiteButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    
    whiteButtonStyle.title = TITLE_GUIDE_SUMMARY_SALEHOUSE_BUTTON;
    
    UIButton *saleHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 160.0f)/2.0f, SIZE_DEVICE_HEIGHT - 20.0f - 44.0f, 160.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:whiteButtonStyle andCallBack:^(UIButton *button) {
        
        [self saleHouse];
        
    }];
    [self addSubview:saleHouseButton];

}

#pragma mark - 点击<我要找房>
- (void)findHouse
{

    

}

#pragma mark - 点击<我要放盘>
- (void)saleHouse
{



}

@end
