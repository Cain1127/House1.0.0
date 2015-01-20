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

@interface QSGuideViewController ()<QSAutoScrollViewDelegate>

@end

@implementation QSGuideViewController

#pragma mark - 加载UI
- (void)createMainShowUI
{

    QSAutoScrollView *autoScrollView = [[QSAutoScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT) andDelegate:self andScrollDirectionType:aAutoScrollDirectionTypeRightToLeft andShowPageIndex:NO andShowTime:0.0f andTapCallBack:^(id params) {
        
        
        
    }];
    [self.view addSubview:autoScrollView];

}

#pragma mark - 返回有多少个滚动页
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView
{

    return 1;

}

#pragma mark - 单击时的参数
- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    return @"NO";

}

#pragma mark - 返回每个广告页
- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    QSGuideSummaryView *sumaryView = [[QSGuideSummaryView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///设置回调
    sumaryView.guideButtonCallBack = ^(GUIDE_BUTTON_ATIONTYPE guideButtonActionType){
        
        [self guideButtonActionCallBack:guideButtonActionType];
    
    };
    
    return sumaryView;

}

#pragma mark - 指引页点击事件回调
- (void)guideButtonActionCallBack:(GUIDE_BUTTON_ATIONTYPE)guideButtonActionType
{

    switch (guideButtonActionType) {
            
            ///我要找房事件
        case gGuideButtonActionTypeFindHouse:
            
            break;
            
            ///我要放盘事件
        case gGuideButtonActionTypeSaleHouse:
            
            break;
            
        default:
            break;
    }

}

@end
