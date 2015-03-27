//
//  QSPOrderBottomButtonView.h
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    
    bBottomButtonTypeOne = 100, //!<一个按钮
    bBottomButtonTypeLeft,      //!<两个按钮时左按钮
    bBottomButtonTypeRight      //!<两个按钮时右按钮
    
}BOTTOM_BUTTON_TYPE;

@interface QSPOrderBottomButtonView : UIView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withButtonCount:(NSInteger)num andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack;

- (void)setCenterBtBackgroundColor:(UIColor*)color;

- (void)setLeftBtBackgroundColor:(UIColor*)color;

- (void)setRightBtBackgroundColor:(UIColor*)color;

- (void)setCenterBtTitle:(NSString*)title;

- (void)setLeftBtTitle:(NSString*)title;

- (void)setRightBtTitle:(NSString*)title;

- (void)setBtTitleFont:(UIFont*)font;

@end
