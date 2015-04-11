//
//  QSPOrderBottomButtonView.h
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButton.h"

typedef enum
{
    
    bBottomButtonTypeOne = 100, //!<一个按钮
    bBottomButtonTypeLeft,      //!<两个按钮时左按钮
    bBottomButtonTypeRight      //!<两个按钮时右按钮
    
}BOTTOM_BUTTON_TYPE;

@interface QSPOrderBottomButtonView : QSPOrderDetalSubBaseView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withButtonCount:(NSInteger)num andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack;

/**
 *  设置中间按钮的样式
 *
 *  @param buttonStyle 样式
 */
- (void)setCenterButtonType:(NORMAL_BUTTON_TYPE)buttonType;

/**
 *  设置右按钮的样式
 *
 *  @param buttonStyle 样式
 */
- (void)setRightButtonType:(NORMAL_BUTTON_TYPE)buttonType;

/**
 *  设置左按钮的样式
 *
 *  @param buttonStyle 样式
 */
- (void)setLeftButtonType:(NORMAL_BUTTON_TYPE)buttonType;

/**
 *  设置中间按钮的标题
 *
 *  @param title 标题字符串
 */
- (void)setCenterBtTitle:(NSString*)title;

/**
 *  设置左按钮的标题
 *
 *  @param title 标题字符串
 */
- (void)setLeftBtTitle:(NSString*)title;

/**
 *  设置右按钮的标题
 *
 *  @param title 标题字符串
 */
- (void)setRightBtTitle:(NSString*)title;

- (void)setBtTitleFont:(UIFont*)font;

- (void)setCenterBtBackgroundColor:(UIColor*)color;

- (void)setLeftBtBackgroundColor:(UIColor*)color;

- (void)setRightBtBackgroundColor:(UIColor*)color;

//禁用按钮
- (void)disableButtons;

@end
