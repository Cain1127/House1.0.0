//
//  QSPSalerBookedOrdersListsViewController.m
//  House
//
//  Created by CoolTea on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPSalerBookedOrdersListsViewController.h"
#import "QSCoreDataManager+User.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSPSalerBookedOrderBookedListView.h"
#import "QSPSalerBookedOrderCompletedListView.h"
#import "QSPSalerBookedOrderCancelListView.h"

#include <objc/runtime.h>

///关联
static char BookingButtonKey;               //!<待看房按钮关联
static char CompleteButtonKey;              //!<已看房按钮关联
static char CancelButtonKey;                //!<已取消按钮关联

static char BookingListTableViewKey;        //!<待看房列表关联
static char CompleteListTableViewKey;       //!<已看房列表关联
static char CancelListTableViewKey;         //!<已取消列表关联
static char TipsImageViewKey;               //!<指示三角形关联



@interface QSPSalerBookedOrdersListsViewController ()

@property (nonatomic,assign) MYZONE_SALER_BOOKED_ORDER_LIST_TYPE selectedListType;//!<当前选中显示的列表状态

@end

@implementation QSPSalerBookedOrdersListsViewController

#pragma mark - 初始化
///初始化
- (instancetype)init
{
    
    if (self = [super init]) {
        
        self.selectedListType = mSalerBookedOrderListTypeBooked;
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
    UIButton *waitForButton;
    UIButton *completeButton;
    UIButton *cancelButton;
    
    ///指示三角指针
    QSImageView *tipsImage;
    
    ///创建待看房列表
    QSPSalerBookedOrderBookedListView *waitForListView = [[QSPSalerBookedOrderBookedListView alloc] initWithFrame:CGRectMake(0, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f)];
    [waitForListView setParentViewController:self];
    [self.view addSubview:waitForListView];
    
    objc_setAssociatedObject(self, &BookingListTableViewKey, waitForListView, OBJC_ASSOCIATION_ASSIGN);
    
    ///创建已看房列表
    QSPSalerBookedOrderCompletedListView *completeListView = [[QSPSalerBookedOrderCompletedListView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height)];
    [completeListView setParentViewController:self];
    [self.view addSubview:completeListView];
    
    objc_setAssociatedObject(self, &CompleteListTableViewKey, completeListView, OBJC_ASSOCIATION_ASSIGN);
    
    ///创建已取消列表
    QSPSalerBookedOrderCancelListView *cancelListView = [[QSPSalerBookedOrderCancelListView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height)];
    [cancelListView setParentViewController:self];
    [self.view addSubview:cancelListView];
    
    objc_setAssociatedObject(self, &CancelListTableViewKey, cancelListView, OBJC_ASSOCIATION_ASSIGN);
    
    ///待看房按钮
    buttonStyle.title = @"待看房";
    waitForButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH / 3.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        [self showAllList];
        ///转换选择状态
        [self setSelectedType:mSalerBookedOrderListTypeBooked animateWithDuration:0.3f];
        
    }];
    waitForButton.selected = YES;
    [self.view addSubview:waitForButton];
    
    objc_setAssociatedObject(self, &BookingButtonKey, waitForButton, OBJC_ASSOCIATION_ASSIGN);
    
    ///已看房按钮
    buttonStyle.title = @"已看房";
    completeButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 3.0f, 64.0f, SIZE_DEVICE_WIDTH / 3.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        [self showAllList];
        ///转换选择状态
        [self setSelectedType:mSalerBookedOrderListTypeCompleted animateWithDuration:0.3f];
        
    }];
    [self.view addSubview:completeButton];
    
    objc_setAssociatedObject(self, &CompleteButtonKey, completeButton, OBJC_ASSOCIATION_ASSIGN);
    
    ///已取消按钮
    buttonStyle.title = @"已取消";
    cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 3.0f * 2, 64.0f, SIZE_DEVICE_WIDTH / 3.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        [self showAllList];
        ///转换选择状态
        [self setSelectedType:mSalerBookedOrderListTypeCancel animateWithDuration:0.3f];
        
    }];
    [self.view addSubview:cancelButton];
    
    objc_setAssociatedObject(self, &CancelButtonKey, cancelButton, OBJC_ASSOCIATION_ASSIGN);
    
    ///指示三角
    tipsImage = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 6.0f - 8.0f, completeButton.frame.origin.y + completeButton.frame.size.height - 5.0f, 16.0f, 5.0f)];
    tipsImage.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:tipsImage];
    
    objc_setAssociatedObject(self, &TipsImageViewKey, tipsImage, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, completeButton.frame.origin.y + completeButton.frame.size.height - 0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLabel];
    [self.view sendSubviewToBack:sepLabel];
    
    [self setSelectedType: self.selectedListType];
    
}

- (void)setSelectedType:(MYZONE_SALER_BOOKED_ORDER_LIST_TYPE)type
{
    
    [self setSelectedType:type animateWithDuration:0.0f];
    
}

- (void)setSelectedType:(MYZONE_SALER_BOOKED_ORDER_LIST_TYPE)type animateWithDuration:(NSTimeInterval)duration
{
    
    self.selectedListType = type;
    
    UIButton *completeButton = objc_getAssociatedObject(self, &CompleteButtonKey);
    UIButton *bookingButton = objc_getAssociatedObject(self, &BookingButtonKey);
    UIButton *cancelButton = objc_getAssociatedObject(self, &CancelButtonKey);
    
    
    QSImageView *tipsImage = objc_getAssociatedObject(self, &TipsImageViewKey);
    QSPSalerBookedOrderBookedListView *waitForListView = objc_getAssociatedObject(self, &BookingListTableViewKey);
    QSPSalerBookedOrderCompletedListView *completeListView = objc_getAssociatedObject(self, &CompleteListTableViewKey);
    QSPSalerBookedOrderCancelListView *cancelListView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    
    switch (self.selectedListType) {
        case mSalerBookedOrderListTypeBooked:
        {
            ///转换选择状态
            if (completeButton) {
                completeButton.selected = NO;
            }
            if (bookingButton) {
                bookingButton.selected = YES;
            }
            if (cancelButton) {
                cancelButton.selected = NO;
            }
            
            ///动画移动
            [UIView animateWithDuration:duration animations:^{
                
                if (waitForListView) {
                    waitForListView.frame = CGRectMake(0.0f, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height);
                }
                if (completeListView) {
                    completeListView.frame = CGRectMake(SIZE_DEVICE_WIDTH, completeListView.frame.origin.y, completeListView.frame.size.width, completeListView.frame.size.height);
                }
                if (cancelListView) {
                    cancelListView.frame = CGRectMake(SIZE_DEVICE_WIDTH, cancelListView.frame.origin.y, cancelListView.frame.size.width, cancelListView.frame.size.height);
                }
                if (tipsImage) {
                    tipsImage.frame = CGRectMake(SIZE_DEVICE_WIDTH / 6.0f - 8.0f, tipsImage.frame.origin.y, tipsImage.frame.size.width, tipsImage.frame.size.height);
                }
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }
            break;
        case mSalerBookedOrderListTypeCompleted:
        {
            ///转换选择状态
            if (completeButton) {
                completeButton.selected = YES;
            }
            if (bookingButton) {
                bookingButton.selected = NO;
            }
            if (cancelButton) {
                cancelButton.selected = NO;
            }
            
            ///动画移动
            [UIView animateWithDuration:duration animations:^{
                
                if (waitForListView) {
                    waitForListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height);
                }
                if (completeListView) {
                    completeListView.frame = CGRectMake(0.0f, completeListView.frame.origin.y, completeListView.frame.size.width, completeListView.frame.size.height);
                }
                if (cancelListView) {
                    cancelListView.frame = CGRectMake(SIZE_DEVICE_WIDTH, cancelListView.frame.origin.y, cancelListView.frame.size.width, cancelListView.frame.size.height);
                }
                if (tipsImage) {
                    tipsImage.frame = CGRectMake(SIZE_DEVICE_WIDTH * 1.0f / 2.0f - 8.0f, tipsImage.frame.origin.y, tipsImage.frame.size.width, tipsImage.frame.size.height);
                }
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }
            break;
        case mSalerBookedOrderListTypeCancel:
        {
            ///转换选择状态
            if (completeButton) {
                completeButton.selected = NO;
            }
            if (bookingButton) {
                bookingButton.selected = NO;
            }
            if (cancelButton) {
                cancelButton.selected = YES;
            }
            
            ///动画移动
            [UIView animateWithDuration:duration animations:^{
                
                if (waitForListView) {
                    waitForListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, waitForListView.frame.origin.y, waitForListView.frame.size.width, waitForListView.frame.size.height);
                }
                if (completeListView) {
                    completeListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, completeListView.frame.origin.y, completeListView.frame.size.width, completeListView.frame.size.height);
                }
                if (cancelListView) {
                    cancelListView.frame = CGRectMake(0.0f, cancelListView.frame.origin.y, cancelListView.frame.size.width, cancelListView.frame.size.height);
                }
                if (tipsImage) {
                    tipsImage.frame = CGRectMake(SIZE_DEVICE_WIDTH * 5.0f / 6.0f - 8.0f, tipsImage.frame.origin.y, tipsImage.frame.size.width, tipsImage.frame.size.height);
                }
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }
            break;
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

    [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {

        if (flag == lLoginCheckActionTypeLogined || flag == lLoginCheckActionTypeReLogin) {
            
            [self showListWithType:self.selectedListType];
            
        }
    
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hideAllList];
    
}

- (void)showAllList
{
    
    QSPSalerBookedOrderBookedListView *waitForListView = objc_getAssociatedObject(self, &BookingListTableViewKey);
    QSPSalerBookedOrderCompletedListView *completeListView = objc_getAssociatedObject(self, &CompleteListTableViewKey);
    QSPSalerBookedOrderCancelListView *cancelListView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    
    if (waitForListView) {
        [waitForListView setHidden:NO];
    }
    if (completeListView) {
        [completeListView setHidden:NO];
    }
    if (cancelListView) {
        [cancelListView setHidden:NO];
    }
    
}

- (void)hideAllList
{
    
    QSPSalerBookedOrderBookedListView *waitForListView = objc_getAssociatedObject(self, &BookingListTableViewKey);
    QSPSalerBookedOrderCompletedListView *completeListView = objc_getAssociatedObject(self, &CompleteListTableViewKey);
    QSPSalerBookedOrderCancelListView *cancelListView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    
    if (waitForListView) {
        [waitForListView setHidden:YES];
    }
    if (completeListView) {
        [completeListView setHidden:YES];
    }
    if (cancelListView) {
        [cancelListView setHidden:YES];
    }
    
}


- (void)showListWithType:(MYZONE_SALER_BOOKED_ORDER_LIST_TYPE)type
{
    
    [self hideAllList];
    QSPSalerBookedOrderBookedListView *waitForListView = objc_getAssociatedObject(self, &BookingListTableViewKey);
    QSPSalerBookedOrderCompletedListView *completeListView = objc_getAssociatedObject(self, &CompleteListTableViewKey);
    QSPSalerBookedOrderCancelListView *cancelListView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    
    switch (type) {
        case mSalerBookedOrderListTypeBooked:
            if (waitForListView) {
                [waitForListView setHidden:NO];
            }
            break;
        case mSalerBookedOrderListTypeCompleted:
            if (completeListView) {
                [completeListView setHidden:NO];
            }
            break;
        case mSalerBookedOrderListTypeCancel:
            if (cancelListView) {
                [cancelListView setHidden:NO];
            }
            break;
        default:
            break;
    }
    
}

@end
