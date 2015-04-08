//
//  QSPBuyerTransactionOrderListViewController.m
//  House
//
//  Created by CoolTea on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPBuyerTransactionOrderListViewController.h"
#import "QSCoreDataManager+User.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSPBuyerTransactionOrderListPendingView.h"
#import "QSPBuyerTransactionOrderListCompletedView.h"
#import "QSPBuyerTransactionOrderListCancelView.h"
#include <objc/runtime.h>

///关联
static char PendingButtonKey;               //!<待成交按钮关联
static char CompleteButtonKey;              //!<已成交按钮关联
static char CancelButtonKey;                //!<已取消按钮关联

static char PendingListTableViewKey;        //!<待成交列表关联
static char CompleteListTableViewKey;       //!<已成交列表关联
static char CancelListTableViewKey;         //!<已取消列表关联
static char TipsImageViewKey;               //!<指示三角形关联

@interface QSPBuyerTransactionOrderListViewController ()

@property (nonatomic,assign) MYZONE_BUYER_TRANSACTION_ORDER_LIST_TYPE selectedListType;//!<当前选中显示的列表状态

@end

@implementation QSPBuyerTransactionOrderListViewController

#pragma mark - 初始化
///初始化
- (instancetype)init
{
    
    if (self = [super init]) {
        
        ///获取当前用户类型
        self.selectedListType = mBuyerTransactionOrderListTypePending;
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_TRANSATIONORDERSLIST];
    
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
    UIButton *PendingButton;
    UIButton *completeButton;
    UIButton *cancelButton;
    
    ///指示三角指针
    QSImageView *tipsImage;
    
    ///创建待成交列表
    QSPBuyerTransactionOrderListPendingView *pendingListView = [[QSPBuyerTransactionOrderListPendingView alloc] initWithFrame:CGRectMake(0, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f)];
    [pendingListView setParentViewController:self];
    [self.view addSubview:pendingListView];
    
    objc_setAssociatedObject(self, &PendingListTableViewKey, pendingListView, OBJC_ASSOCIATION_ASSIGN);
    
    ///创建已成交列表
    QSPBuyerTransactionOrderListCompletedView *completeListView = [[QSPBuyerTransactionOrderListCompletedView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, pendingListView.frame.origin.y, pendingListView.frame.size.width, pendingListView.frame.size.height)];
    [completeListView setParentViewController:self];
    [self.view addSubview:completeListView];
    
    objc_setAssociatedObject(self, &CompleteListTableViewKey, completeListView, OBJC_ASSOCIATION_ASSIGN);
    
    ///创建已取消列表
    QSPBuyerTransactionOrderListCancelView *cancelListView = [[QSPBuyerTransactionOrderListCancelView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, pendingListView.frame.origin.y, pendingListView.frame.size.width, pendingListView.frame.size.height)];
    [cancelListView setParentViewController:self];
    [self.view addSubview:cancelListView];
    
    objc_setAssociatedObject(self, &CancelListTableViewKey, cancelListView, OBJC_ASSOCIATION_ASSIGN);
    
    ///待成交按钮
    buttonStyle.title = @"待成交";
    PendingButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH / 3.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        [self showAllList];
        ///转换选择状态
        [self setSelectedType:mBuyerTransactionOrderListTypePending animateWithDuration:0.3f];
        
    }];
    PendingButton.selected = YES;
    [self.view addSubview:PendingButton];
    
    objc_setAssociatedObject(self, &PendingButtonKey, PendingButton, OBJC_ASSOCIATION_ASSIGN);
    
    ///已成交按钮
    buttonStyle.title = @"已成交";
    completeButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 3.0f, 64.0f, SIZE_DEVICE_WIDTH / 3.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        [self showAllList];
        ///转换选择状态
        [self setSelectedType:mBuyerTransactionOrderListTypeCompleted animateWithDuration:0.3f];
        
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
        [self setSelectedType:mBuyerTransactionOrderListTypeCancel animateWithDuration:0.3f];
        
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

- (void)setSelectedType:(MYZONE_BUYER_TRANSACTION_ORDER_LIST_TYPE)type
{
    
    [self setSelectedType:type animateWithDuration:0.0f];
    
}

- (void)setSelectedType:(MYZONE_BUYER_TRANSACTION_ORDER_LIST_TYPE)type animateWithDuration:(NSTimeInterval)duration
{
    
    self.selectedListType = type;
    
    UIButton *completeButton = objc_getAssociatedObject(self, &CompleteButtonKey);
    UIButton *pendingButton = objc_getAssociatedObject(self, &PendingButtonKey);
    UIButton *cancelButton = objc_getAssociatedObject(self, &CancelButtonKey);
    
    
    QSImageView *tipsImage = objc_getAssociatedObject(self, &TipsImageViewKey);
    QSPBuyerTransactionOrderListPendingView *pendingListView = objc_getAssociatedObject(self, &PendingListTableViewKey);
    QSPBuyerTransactionOrderListCompletedView *completeListView = objc_getAssociatedObject(self, &CompleteListTableViewKey);
    QSPBuyerTransactionOrderListCancelView *cancelListView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    
    switch (self.selectedListType) {
        case mBuyerTransactionOrderListTypePending:
        {
            ///转换选择状态
            if (completeButton) {
                completeButton.selected = NO;
            }
            if (pendingButton) {
                pendingButton.selected = YES;
            }
            if (cancelButton) {
                cancelButton.selected = NO;
            }
            
            ///动画移动
            [UIView animateWithDuration:duration animations:^{
                
                if (pendingListView) {
                    pendingListView.frame = CGRectMake(0.0f, pendingListView.frame.origin.y, pendingListView.frame.size.width, pendingListView.frame.size.height);
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
        case mBuyerTransactionOrderListTypeCompleted:
        {
            ///转换选择状态
            if (completeButton) {
                completeButton.selected = YES;
            }
            if (pendingButton) {
                pendingButton.selected = NO;
            }
            if (cancelButton) {
                cancelButton.selected = NO;
            }
            
            ///动画移动
            [UIView animateWithDuration:duration animations:^{
                
                if (pendingListView) {
                    pendingListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, pendingListView.frame.origin.y, pendingListView.frame.size.width, pendingListView.frame.size.height);
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
        case mBuyerTransactionOrderListTypeCancel:
        {
            ///转换选择状态
            if (completeButton) {
                completeButton.selected = NO;
            }
            if (pendingButton) {
                pendingButton.selected = NO;
            }
            if (cancelButton) {
                cancelButton.selected = YES;
            }
            
            ///动画移动
            [UIView animateWithDuration:duration animations:^{
                
                if (pendingListView) {
                    pendingListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, pendingListView.frame.origin.y, pendingListView.frame.size.width, pendingListView.frame.size.height);
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
    
    QSPBuyerTransactionOrderListPendingView *pendingListView = objc_getAssociatedObject(self, &PendingListTableViewKey);
    QSPBuyerTransactionOrderListCompletedView *completeListView = objc_getAssociatedObject(self, &CompleteListTableViewKey);
    QSPBuyerTransactionOrderListCancelView *cancelListView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    
    if (pendingListView) {
        [pendingListView setHidden:NO];
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
    
    QSPBuyerTransactionOrderListPendingView *pendingListView = objc_getAssociatedObject(self, &PendingListTableViewKey);
    QSPBuyerTransactionOrderListCompletedView *completeListView = objc_getAssociatedObject(self, &CompleteListTableViewKey);
    QSPBuyerTransactionOrderListCancelView *cancelListView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    
    if (pendingListView) {
        [pendingListView setHidden:YES];
    }
    if (completeListView) {
        [completeListView setHidden:YES];
    }
    if (cancelListView) {
        [cancelListView setHidden:YES];
    }
    
}


- (void)showListWithType:(MYZONE_BUYER_TRANSACTION_ORDER_LIST_TYPE)type
{
    
    [self hideAllList];
    QSPBuyerTransactionOrderListPendingView *pendingListView = objc_getAssociatedObject(self, &PendingListTableViewKey);
    QSPBuyerTransactionOrderListCompletedView *completeListView = objc_getAssociatedObject(self, &CompleteListTableViewKey);
    QSPBuyerTransactionOrderListCancelView *cancelListView = objc_getAssociatedObject(self, &CancelListTableViewKey);
    
    switch (type) {
        case mBuyerTransactionOrderListTypePending:
            if (pendingListView) {
                [pendingListView setHidden:NO];
            }
            break;
        case mBuyerTransactionOrderListTypeCompleted:
            if (completeListView) {
                [completeListView setHidden:NO];
            }
            break;
        case mBuyerTransactionOrderListTypeCancel:
            if (cancelListView) {
                [cancelListView setHidden:NO];
            }
            break;
        default:
            break;
    }
    
}

@end
