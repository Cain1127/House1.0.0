//
//  QSPOrderBottomButtonView.m
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderBottomButtonView.h"
#import "QSBlockButtonStyleModel+Normal.h"

//上下间隙
#define     CONTENT_TOP_BOTTOM_OFFSETY     12.0f
//左右间隙
#define     CONTENT_LEFT_RIGHT_OFFSETX     CONTENT_TOP_BOTTOM_OFFSETY //35.0f


@interface QSPOrderBottomButtonView ()

@property ( nonatomic, assign ) NSInteger buttonNum;

@end

@implementation QSPOrderBottomButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withButtonCount:(NSInteger)num andCallBack:(void(^)(BOTTOM_BUTTON_TYPE btType, UIButton *button))callBack
{
    
    if (self = [super initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f)]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _buttonNum = num;
        [self creatButton:_buttonNum];
        
        self.blockButtonCallBack = callBack;
        
    }
    
    return self;
    
}

///创建按钮
- (void)creatButton:(NSInteger)num
{
    
    if (num == 1) {
        
        ///按钮风格
        QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        
        ///中间一个的按钮
        buttonStyle.title = TITLE_MYZONE_ORDER_DETAIL_CHANGE_ORDER_TITLE_TIP;
        UIButton *centerOneButton = [UIButton createBlockButtonWithFrame:CGRectMake(CONTENT_LEFT_RIGHT_OFFSETX, CONTENT_TOP_BOTTOM_OFFSETY, SIZE_DEVICE_WIDTH-2.0f*CONTENT_LEFT_RIGHT_OFFSETX, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(bBottomButtonTypeOne,button);
            }
            
        }];
        [centerOneButton setTag:bBottomButtonTypeOne];
        [self addSubview:centerOneButton];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, centerOneButton.frame.origin.y+centerOneButton.frame.size.height+CONTENT_TOP_BOTTOM_OFFSETY)];
        
    }else if (num == 2) {
        
        ///左按钮风格
        QSBlockButtonStyleModel *leftButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        
        ///左按钮
        leftButtonStyle.title = TITLE_MYZONE_ORDER_CHANGE_BT_CANCEl;
        UIButton *leftButtonButton = [UIButton createBlockButtonWithFrame:CGRectMake(CONTENT_TOP_BOTTOM_OFFSETY, CONTENT_TOP_BOTTOM_OFFSETY, (SIZE_DEVICE_WIDTH-3.0f*CONTENT_TOP_BOTTOM_OFFSETY)/2, 44.0f) andButtonStyle:leftButtonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(bBottomButtonTypeLeft,button);
            }
            
        }];
        [leftButtonButton setTag:bBottomButtonTypeLeft];
        [self addSubview:leftButtonButton];
        
        
        ///右按钮风格
        QSBlockButtonStyleModel *rightButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        
        ///右按钮
        rightButtonStyle.title = TITLE_MYZONE_ORDER_CHANGE_BT_SUBMIT;
        UIButton *rightButtonButton = [UIButton createBlockButtonWithFrame:CGRectMake(leftButtonButton.frame.origin.x+leftButtonButton.frame.size.width+CONTENT_TOP_BOTTOM_OFFSETY, CONTENT_TOP_BOTTOM_OFFSETY, leftButtonButton.frame.size.width, leftButtonButton.frame.size.height) andButtonStyle:rightButtonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(bBottomButtonTypeRight,button);
            }
            
        }];
        [rightButtonButton setTag:bBottomButtonTypeRight];
        [self addSubview:rightButtonButton];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, leftButtonButton.frame.origin.y+leftButtonButton.frame.size.height+CONTENT_TOP_BOTTOM_OFFSETY)];
        
    }
    
}

- (void)setCenterBtBackgroundColor:(UIColor*)color
{
    if (_buttonNum == 1 && color && [color isKindOfClass:[UIColor class]]) {
        
        UIView *view = [self viewWithTag:bBottomButtonTypeOne];
        
        if (view && [view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)view;
            [button setBackgroundColor:color];
            
        }
    }
}

- (void)setLeftBtBackgroundColor:(UIColor*)color
{
    if (_buttonNum == 2 && color && [color isKindOfClass:[UIColor class]]) {
        
        UIView *view = [self viewWithTag:bBottomButtonTypeLeft];
        
        if (view && [view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)view;
            [button setBackgroundColor:color];
            
        }
        
    }
}

- (void)setRightBtBackgroundColor:(UIColor*)color
{
    if (_buttonNum == 2 && color && [color isKindOfClass:[UIColor class]]) {
        
        UIView *view = [self viewWithTag:bBottomButtonTypeRight];
        
        if (view && [view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)view;
            [button setBackgroundColor:color];
            
        }
        
    }
}

- (void)setCenterBtTitle:(NSString*)title
{
    if (_buttonNum == 1 && title && [title isKindOfClass:[NSString class]]) {
        
        UIView *view = [self viewWithTag:bBottomButtonTypeOne];
        
        if (view && [view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)view;
            [button setTitle:title forState:UIControlStateNormal];
            
        }
    }
}

- (void)setLeftBtTitle:(NSString*)title
{
    if (_buttonNum == 2 && title && [title isKindOfClass:[NSString class]]) {
        
        UIView *view = [self viewWithTag:bBottomButtonTypeLeft];
        
        if (view && [view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)view;
            [button setTitle:title forState:UIControlStateNormal];
            
        }
    }
}

- (void)setRightBtTitle:(NSString*)title
{
    if (_buttonNum == 2 && title && [title isKindOfClass:[NSString class]]) {
        
        UIView *view = [self viewWithTag:bBottomButtonTypeRight];
        
        if (view && [view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)view;
            [button setTitle:title forState:UIControlStateNormal];
            
        }
    }
}

- (void)setBtTitleFont:(UIFont*)font
{
    for (UIView *view in [self subviews]) {
        
        if (view && [view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)view;
            [button.titleLabel setFont:font];
            
        }
    }
}

@end
