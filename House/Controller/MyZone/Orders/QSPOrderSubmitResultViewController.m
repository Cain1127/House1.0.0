//
//  QSPOrderSubmitResultViewController.m
//  House
//
//  Created by CoolTea on 15/3/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderSubmitResultViewController.h"
#import "QSPOrderBottomButtonView.h"

#define ORDER_RESULT_AUTO_RETURN_TIME_OUT_TIME   _resultType==oOrderSubmitResultTypeEvaluationListingsSuccessed?3.0f:5.0f

@interface QSPOrderSubmitResultViewController ()

@property (nonatomic,copy) void  (^blockButtonCallBack)(ORDER_SUBMIT_RESULT_BACK_TYPE);
@property (nonatomic, assign) ORDER_SUBMIT_RESULT_TYPE resultType;
@property (nonatomic,retain) NSTimer *autoReturnTimer;      //!<自动返回的定时器

@end

@implementation QSPOrderSubmitResultViewController

- (instancetype)initWithResultType:(ORDER_SUBMIT_RESULT_TYPE)type andAutoBackCallBack:(void(^)(ORDER_SUBMIT_RESULT_BACK_TYPE)) callBack
{
    if (self = [super init]) {
        
        _resultType = type;
        self.blockButtonCallBack = callBack;
        
    }
    return self;
}

#pragma mark - UI搭建
///搭建主展示UI
- (void)createMainShowUI
{
    UIView *contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, 0)];
    [self.view addSubview:contentBgView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH-75.0f)/2.0f, 0, 75.0f, 85.0f)];
    [imgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_SUBMIT_RESULT_ICON]];
    if (oOrderSubmitResultTypeEvaluationListingsSuccessed == _resultType) {
        [imgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_SUBMIT_RESULT_SUCCESS_ICON]];
    }
    [contentBgView addSubview:imgView];
    
    //state label
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+10, SIZE_DEVICE_WIDTH, 30)];
    [stateLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_18]];
    [stateLabel setTextColor:COLOR_CHARACTERS_BLACK];
    [stateLabel setTextAlignment:NSTextAlignmentCenter];
    [contentBgView addSubview:stateLabel];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, stateLabel.frame.origin.y+stateLabel.frame.size.height, SIZE_DEVICE_WIDTH, 22)];
    [tipLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_14]];
    [tipLabel setTextColor:COLOR_CHARACTERS_GRAY];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [contentBgView addSubview:tipLabel];
    
    __block QSPOrderBottomButtonView *buttonsView;
    
    if (_resultType == oOrderSubmitResultTypeBookSuccessed) {
        
        [stateLabel setText:TITLE_MYZONE_ORDER_SUBMIT_BOOKED_SUCCESS_TIP];
        [tipLabel setText:TITLE_MYZONE_ORDER_SUBMIT_WAIT_COMFIN_TIP];
        
        buttonsView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointZero withButtonCount:2 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            
            NSLog(@"QSPOrderSubmitResultViewController clickButton：%d",buttonType);
            if (buttonType == bBottomButtonTypeLeft) {
                //左边按钮
                
                [self backToLastViewControllerWithBackType:oOrderSubmitResultBackTypeToDetail];
                
            }else if (buttonType == bBottomButtonTypeRight) {
                //右边按钮
                
                [self backToLastViewControllerWithBackType:oOrderSubmitResultBackTypeToMoreHouse];
                
            }
            
        }];
        [buttonsView setRightBtBackgroundColor:COLOR_CHARACTERS_LIGHTYELLOW];
        [buttonsView setLeftBtTitle:TITLE_MYZONE_ORDER_SUBMIT_ORDER_DETAIL_BT];
        [buttonsView setRightBtTitle:TITLE_MYZONE_ORDER_SUBMIT_MORE_HOUSE_BT];
        
    }else if (_resultType == oOrderSubmitResultTypeCancelSuccessed) {
        
        [stateLabel setText:TITLE_MYZONE_ORDER_SUBMIT_CANCEL_SUCCESS_TIP];
        [tipLabel setText:@""];
        
        buttonsView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointZero withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            
            NSLog(@"QSPOrderSubmitResultViewController clickButton：%d",buttonType);
            if (buttonType == bBottomButtonTypeOne) {
                //中间按钮
                
                 [self backToLastViewControllerWithBackType:oOrderSubmitResultBackTypeToMoreHouse];
                
            }
            
        }];
        [buttonsView setCenterBtTitle:TITLE_MYZONE_ORDER_SUBMIT_MORE_HOUSE_BT];
        
    }else if (_resultType == oOrderSubmitResultTypeEvaluationListingsSuccessed) {
        
        [stateLabel setText:TITLE_MYZONE_ORDER_SUBMIT_COMMENT_SUCCESS_TIP];
        [tipLabel setText:@""];
        
    }
    
    CGFloat offsetY = tipLabel.frame.origin.y + tipLabel.frame.size.height;
    
    if (buttonsView) {
        
        [buttonsView setBtTitleFont:[UIFont boldSystemFontOfSize:FONT_BODY_18]];
        [buttonsView setFrame:CGRectMake(buttonsView.frame.origin.x, offsetY + 30.0f, buttonsView.frame.size.width, buttonsView.frame.size.height)];
        [contentBgView addSubview:buttonsView];
        offsetY = buttonsView.frame.origin.y + buttonsView.frame.size.height;
        
    }
    
    [contentBgView setFrame:CGRectMake(contentBgView.frame.origin.x, contentBgView.frame.origin.y, contentBgView.frame.size.width, offsetY)];
    
    [contentBgView setCenter: self.view.center];
    
    [self initAutoReturnTimer];
    
}

///初始化自动返回定时器
- (void)initAutoReturnTimer
{
    ///判断是否已开启
    if ([self.autoReturnTimer isValid]) {
        
        [self.autoReturnTimer invalidate];
        self.autoReturnTimer = nil;
        
    }
    
    ///开启定时器
    self.autoReturnTimer = [NSTimer scheduledTimerWithTimeInterval:ORDER_RESULT_AUTO_RETURN_TIME_OUT_TIME target:self selector:@selector(checkReturn:) userInfo:nil repeats:NO];
    
}

///退出视图
- (void)checkReturn:(NSTimer *)timer
{
    
    [self backToLastViewControllerWithBackType:oOrderSubmitResultBackTypeAuto];
    
}

- (void)backToLastViewControllerWithBackType:(ORDER_SUBMIT_RESULT_BACK_TYPE)backType
{
    
    if (self.autoReturnTimer && [self.autoReturnTimer isValid]) {
        
        [self.autoReturnTimer invalidate];
        self.autoReturnTimer = nil;
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if (self.blockButtonCallBack) {
        self.blockButtonCallBack(backType);
    }
    
    
}

@end
