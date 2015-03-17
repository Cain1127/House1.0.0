//
//  QSPOrderBookTimeViewController.m
//  House
//
//  Created by CoolTea on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderBookTimeViewController.h"
#import "QSCoreDataManager+User.h"
#import "QSPCalendarView.h"

@interface QSPOrderBookTimeViewController ()

@property (nonatomic,assign) USER_COUNT_TYPE userType;//!<用户类型

@end

@implementation QSPOrderBookTimeViewController

#pragma mark - 初始化
///初始化
- (instancetype)init
{
    
    if (self = [super init]) {
        
        ///获取当前用户类型
        self.userType = [QSCoreDataManager getCurrentUserCountType];
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_BOOKTIME];
    
}

///搭建主展示UI
- (void)createMainShowUI
{
    ///由于此页面是放置在tabbar页面上的，所以中间可用的展示高度是设备高度减去导航栏和底部tabbar的高度
    __block CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f;
    
    QSPCalendarView *calendarView = [[QSPCalendarView alloc] initAtTopLeft:CGPointMake(0, 64)];
    [self.view addSubview:calendarView];
 
}

@end
