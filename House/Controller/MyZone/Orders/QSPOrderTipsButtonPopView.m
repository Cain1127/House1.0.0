//
//  QSPOrderTipsButtonPopView.m
//  House
//
//  Created by CoolTea on 15/4/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderTipsButtonPopView.h"
#import "QSBlockButtonStyleModel+Normal.h"

@interface QSPOrderTipsButtonPopView ()

///回调
@property (nonatomic,copy) void(^buttonTipsCallBack)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType);

@end

@implementation QSPOrderTipsButtonPopView

- (instancetype)initWithShareCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack
{
    
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        ///搭建UI
        [self createTipAndButtonsUI];
        
        ///保存回调
        if (callBack) {
            
            self.buttonTipsCallBack = callBack;
            
        }
        
    }
    
    return self;
}

#pragma mark - UI搭建
- (void)createTipAndButtonsUI
{
    
    //半透明背景层
    [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    [self setBackgroundColor:COLOR_CHARACTERS_BLACKH];
    
    //背景关闭按钮
    QSBlockButtonStyleModel *bgBtStyleModel = [QSBlockButtonStyleModel alloc];
    UIButton *bgBt = [UIButton createBlockButtonWithFrame:self.frame andButtonStyle:bgBtStyleModel andCallBack:^(UIButton *button) {
        
        if (self.buttonTipsCallBack) {
            
            self.buttonTipsCallBack(button,oOrderButtonTipsActionTypeCancel);
            
        }
        
        [self hideView];
    }];
    [self addSubview:bgBt];
    
    //底部内容区域层
    UIView *contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT - DefaultHeight , SIZE_DEVICE_WIDTH, DefaultHeight)];
    [contentBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentBackgroundView];
    
//    ///提示信息
//    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f, self.frame.size.width, 30.0f)];
//    tipsLabel.text = @"是否将此房进行比一比？";
//    tipsLabel.textAlignment = NSTextAlignmentCenter;
//    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
//    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
//    [self addSubview:tipsLabel];
//    
    ///按钮相关尺寸
    CGFloat xpoint = 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat width = (self.frame.size.width - 2.0f * xpoint - VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP) / 2.0f;
    
    ///取消按钮
    QSBlockButtonStyleModel *cancelButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
    cancelButtonStyle.title = @"取消";
    
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(xpoint, contentBackgroundView.frame.size.height-VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP-VIEW_SIZE_NORMAL_BUTTON_HEIGHT, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:cancelButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.buttonTipsCallBack) {
            
            self.buttonTipsCallBack(button,oOrderButtonTipsActionTypeCancel);
            
        }
        
        [self hideView];
        
    }];
    [contentBackgroundView addSubview:cancelButton];
    
    ///确认按钮
    QSBlockButtonStyleModel *confirmButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    confirmButtonStyle.title = @"确定";
    
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width / 2.0f + 4.0f, cancelButton.frame.origin.y, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:confirmButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.buttonTipsCallBack) {
            
            self.buttonTipsCallBack(button, oOrderButtonTipsActionTypeConfirm);
            
        }
        
        [self hideView];
        
    }];
    [contentBackgroundView addSubview:confirmButton];
    
}

- (void)hideView
{
    
    [self setHidden:YES];
    [self removeFromSuperview];
    
}

@end
