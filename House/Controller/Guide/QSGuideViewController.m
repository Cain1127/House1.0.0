//
//  QSGuideViewController.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideViewController.h"
#import "QSAutoScrollView.h"
#import "QSGuideSummaryView.h"
#import "QSGuideLookingforRoomView.h"
#import "QSGuideSaleHouseView.h"
#import "QSFilterViewController.h"
#import "QSLoginViewController.h"

@interface QSGuideViewController ()

@end

@implementation QSGuideViewController

#pragma mark - 加载UI：默认显示是否房客或业主的页面
- (void)createMainShowUI
{

    QSGuideSummaryView *sumaryView = [[QSGuideSummaryView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///设置回调
    sumaryView.guideButtonCallBack = ^(GUIDE_BUTTON_ATIONTYPE guideButtonActionType){
        
        [self guideButtonActionCallBack:guideButtonActionType];
        
    };
    
    [self.view addSubview:sumaryView];

}

#pragma mark - 指引页点击事件回调
- (void)guideButtonActionCallBack:(GUIDE_BUTTON_ATIONTYPE)guideButtonActionType
{

    switch (guideButtonActionType) {
            
            ///我要找房事件
        case gGuideButtonActionTypeFindHouse:
            
            [self gotoFindHouse];
            
            break;
            
            ///我要放盘事件
        case gGuideButtonActionTypeSaleHouse:
            
            [self gotoSaleHouse];
            
            break;
            
            ///找房：二手房
        case gGuideButtonActionTypeFindHouseSecondHouse:
        {
            
            QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:applicationFileterTypeSecondHandHouse];
            [self changeWindowRootViewController:filterVC];
            
        }
            break;
            
            ///找房：出租房
        case gGuideButtonActionTypeFindHouseRentalHouse:
        {
            
            QSFilterViewController *filterVC = [[QSFilterViewController alloc] initWithFilterType:applicationFileterTypeRenantHouse];
            [self changeWindowRootViewController:filterVC];
            
        }
            break;
            
            ///找房：跳过
        case gGuideButtonActionTypeFindHouseSkip:
            
            
            
            break;
            
            ///我要放盘：出售物业
        case gGuideButtonActionTypeSaleHouseSaleHouse:
            
            ///我要放盘：出租物业
        case gGuideButtonActionTypeSaleHouseRentalHouse:
        {
         
            QSLoginViewController *loginVC = [[QSLoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }
            break;
            
            ///我要放盘：跳过
        case gGuideButtonActionTypeSaleHouseSkip:
            
            
            
            break;
            
        default:
            break;
    }

}

#pragma mark - 我要发盘指引页
- (void)gotoSaleHouse
{

    ///原来首页
    UIView *guideSummaryView = [self.view subviews][0];
    
    ///创建我要找房页面
    QSGuideSaleHouseView *saleHouseView = [[QSGuideSaleHouseView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///保存回调
    saleHouseView.guideButtonCallBack = ^(GUIDE_BUTTON_ATIONTYPE guideActionType){
    
        [self guideButtonActionCallBack:guideActionType];
    
    };
    
    [self.view addSubview:saleHouseView];
    
    ///动画移出
    [UIView animateWithDuration:0.3 animations:^{
        
        saleHouseView.frame = CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
        guideSummaryView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            ///移聊汇总页
            [guideSummaryView removeFromSuperview];
            
        }
        
    }];

}

#pragma mark - 我要找房指引页面
- (void)gotoFindHouse
{
    
    ///原来首页
    UIView *guideSummaryView = [self.view subviews][0];

    ///创建我要找房页面
    QSGuideLookingforRoomView *findHouseView = [[QSGuideLookingforRoomView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///保存回调
    findHouseView.guideButtonCallBack = ^(GUIDE_BUTTON_ATIONTYPE guideActionType){
        
        [self guideButtonActionCallBack:guideActionType];
        
    };
    
    [self.view addSubview:findHouseView];
    
    ///动画移出
    [UIView animateWithDuration:0.3 animations:^{
        
        findHouseView.frame = CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
        guideSummaryView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            ///移聊汇总页
            [guideSummaryView removeFromSuperview];
            
        }
        
    }];

}

@end
