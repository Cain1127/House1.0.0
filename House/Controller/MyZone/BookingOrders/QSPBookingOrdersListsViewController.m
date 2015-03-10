//
//  QSPBookingOrdersViewController.m
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPBookingOrdersListsViewController.h"
#import "QSCoreDataManager+User.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSPBookingOrderBookingListView.h"
#import "QSPBookingOrderCompletedListView.h"
#import "QSPBookingOrderCancelListView.h"


///房客事件回调
typedef enum
{
    
    tTenantZoneOrderListSelectTypeStayAround = 99,  //!<待看房
    tTenantZoneOrderListSelectTypeHavedAround,      //!<已看房
    tTenantZoneOrderListSelectTypeCancel,           //!<已取消
    
}TENANT_ZONE_ORDERLIST_SELECT_TYPE;

@interface QSPBookingOrdersListsViewController ()

@property (nonatomic,assign) USER_COUNT_TYPE userType;//!<用户类型

@end

@implementation QSPBookingOrdersListsViewController

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
    
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_BOOKINGORDERSLIST];
    
}

///搭建主展示UI
- (void)createMainShowUI
{
    
    ///由于此页面是放置在tabbar页面上的，所以中间可用的展示高度是设备高度减去导航栏和底部tabbar的高度
    __block CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.titleFont = [UIFont systemFontOfSize:16.0f];
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_BLACK;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
    
    ///按钮指针
    __block UIButton *waitForButton;
    __block UIButton *completeButton;
    __block UIButton *cancelButton;
    
    ///指示三角指针
    __block QSImageView *tipsImage;
    
    ///待看房列表指针
    __block QSPBookingOrderBookingListView *waitForListView;

    ///已看房指针
    __block QSPBookingOrderCompletedListView *completeListView;
    
    ///已取消指针
    __block QSPBookingOrderCancelListView *cancelListView;
    
    ///创建待看房列表
    waitForListView = [[QSPBookingOrderBookingListView alloc] initWithFrame:CGRectMake(0, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f) andUserType:uUserCountTypeTenant];
    [self.view addSubview:waitForListView];
    
    ///创建已看房列表
    completeListView = [[QSPBookingOrderCompletedListView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height) andUserType:uUserCountTypeTenant];
    [self.view addSubview:completeListView];
    
    ///创建已取消列表
    cancelListView = [[QSPBookingOrderCancelListView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height) andUserType:uUserCountTypeTenant];
    [self.view addSubview:cancelListView];
    
    ///待看房按钮
    buttonStyle.title = @"待看房";
    waitForButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH / 3.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        ///转换选择状态
        completeButton.selected = NO;
        button.selected = YES;
        cancelButton.selected = NO;
        
        ///动画移动
        [UIView animateWithDuration:0.3 animations:^{
            
            waitForListView.frame = CGRectMake(0.0f, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height);
            completeListView.frame = CGRectMake(SIZE_DEVICE_WIDTH, completeListView.frame.origin.y, completeListView.frame.size.width, completeListView.frame.size.height);
            cancelListView.frame = CGRectMake(SIZE_DEVICE_WIDTH, cancelListView.frame.origin.y, cancelListView.frame.size.width, cancelListView.frame.size.height);
            
            tipsImage.frame = CGRectMake(SIZE_DEVICE_WIDTH / 6.0f - 8.0f, tipsImage.frame.origin.y, tipsImage.frame.size.width, tipsImage.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }];
    waitForButton.selected = YES;
    [self.view addSubview:waitForButton];
    
    ///已看房按钮
    buttonStyle.title = @"已看房";
    completeButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 3.0f, 64.0f, SIZE_DEVICE_WIDTH / 3.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        ///转换选择状态
        waitForButton.selected = NO;
        button.selected = YES;
        cancelButton.selected = NO;
        
        ///动画移动
        [UIView animateWithDuration:0.3 animations:^{
            
            waitForListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height);
            completeListView.frame = CGRectMake(0.0f, completeListView.frame.origin.y, completeListView.frame.size.width, completeListView.frame.size.height);
            cancelListView.frame = CGRectMake(SIZE_DEVICE_WIDTH, cancelListView.frame.origin.y, cancelListView.frame.size.width, cancelListView.frame.size.height);
            
            tipsImage.frame = CGRectMake(SIZE_DEVICE_WIDTH * 1.0f / 2.0f - 8.0f, tipsImage.frame.origin.y, tipsImage.frame.size.width, tipsImage.frame.size.height);
            
        } completion:^(BOOL finished) {
            
//            [waitForListView removeFromSuperview];
//            waitForListView = nil;
            
        }];
        
    }];
    [self.view addSubview:completeButton];
    
    
    ///已取消按钮
    buttonStyle.title = @"已取消";
    cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 3.0f * 2, 64.0f, SIZE_DEVICE_WIDTH / 3.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        ///转换选择状态
        waitForButton.selected = NO;
        button.selected = YES;
        completeButton.selected = NO;
        
        ///动画移动
        [UIView animateWithDuration:0.3 animations:^{
            
            waitForListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height);
            completeListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, completeListView.frame.origin.y, completeListView.frame.size.width, completeListView.frame.size.height);
            cancelListView.frame = CGRectMake(0.0f, cancelListView.frame.origin.y, cancelListView.frame.size.width, cancelListView.frame.size.height);
            
            tipsImage.frame = CGRectMake(SIZE_DEVICE_WIDTH * 5.0f / 6.0f - 8.0f, tipsImage.frame.origin.y, tipsImage.frame.size.width, tipsImage.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    [self.view addSubview:cancelButton];
    
    ///指示三角
    tipsImage = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 6.0f - 8.0f, completeButton.frame.origin.y + completeButton.frame.size.height - 5.0f, 16.0f, 5.0f)];
    tipsImage.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:tipsImage];
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, completeButton.frame.origin.y + completeButton.frame.size.height - 0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLabel];
    [self.view sendSubviewToBack:sepLabel];
    
    ///首先创建待看房列表
//    waitForListView = [[QSChatwaitForsView alloc] initWithFrame:CGRectMake(0.0f, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f) andUserType:uUserCountTypeTenant];
//    [self.view addSubview:waitForListView];
    
}


@end
