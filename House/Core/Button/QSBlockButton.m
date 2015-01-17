//
//  QSBlockButton.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockButton.h"

@implementation UIButton (QSBlockButton)

/**
 *  @author             yangshengmeng, 15-01-17 17:01:04
 *
 *  @brief              创建并返回一个特定风格并且带有回调的按钮
 *
 *  @param frame        在父视图中的位置和大小
 *  @param buttonStyle  按钮风格模型
 *  @param callBack     单击时的回调
 *
 *  @return             返回一个特定风格并且单击时有回调的按钮
 *
 *  @since              1.0.0
 */
+ (UIButton *)createBlockButtonWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andCallBack:(void (^)(UIButton *))callBack
{
    
    ///创建一个单击时回调的按钮并返回
    QSBlockButton *blockButton = [[QSBlockButton alloc] initWithFrame:frame andButtonStyle:buttonStyle];
    
    ///保存回调
    if (callBack) {
        
        blockButton.blockButtonCallBack = callBack;
        
    }
    
    return blockButton;

}

@end

@implementation QSBlockButton

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle
{

    if (self = [super initWithFrame:frame]) {
        
        ///创建按钮时就添加单击回调
        [self addTarget:self action:@selector(blockButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ///设置风格
        if (buttonStyle) {
            
            [self setButtonPropertyWithButtonStyle:buttonStyle];
            
        }
        
    }
    
    return self;

}

#pragma mark - 按钮单击时回调
/**
 *  @author         yangshengmeng, 15-01-17 18:01:53
 *
 *  @brief          按钮单击时回调
 *
 *  @param button   当前单击的按钮对象指针
 *
 *  @since          1.0.0
 */
- (void)blockButtonTapAction:(UIButton *)button
{

    if (self.blockButtonCallBack) {
        
        self.blockButtonCallBack(button);
        
    }

}

#pragma mark - 根据按钮风格数据模型设置按钮的相关属性
/**
 *  @author             yangshengmeng, 15-01-17 18:01:55
 *
 *  @brief              按给定的按钮风格设置按钮相关属性
 *
 *  @param buttonStyle  按钮风格模型
 *
 *  @since              1.0.0
 */
- (void)setButtonPropertyWithButtonStyle:(QSBlockButtonStyleModel *)buttonStyle
{

    if (buttonStyle.title) {
        
        [self setTitle:buttonStyle.title forState:UIControlStateNormal];
        
    }
    
    if (buttonStyle.bgColor) {
        
        self.backgroundColor = buttonStyle.bgColor;
        
    }
    
    if (buttonStyle.titleNormalColor) {
        
        [self setTitleColor:buttonStyle.titleNormalColor
                   forState:UIControlStateNormal];
        
    }
    
    if (buttonStyle.titleHightedColor) {
        
        [self setTitleColor:buttonStyle.titleHightedColor
                   forState:UIControlStateHighlighted];
        
    }
    
    if (buttonStyle.titleSelectedColor) {
        
        [self setTitleColor:buttonStyle.titleSelectedColor
                   forState:UIControlStateSelected];
        
    }
    
    if (buttonStyle.borderColor) {
        
        self.layer.borderColor = [buttonStyle.borderColor CGColor];
        
    }
    
    if (buttonStyle.borderWith >= 0.5f && buttonStyle.borderWith <= 10.0f) {
        
        self.layer.borderWidth = buttonStyle.borderWith;
        
    }
    
    if (buttonStyle.imagesNormal) {
        
        UIImage *image = [UIImage imageNamed:buttonStyle.imagesNormal];
        [self setImage:image forState:UIControlStateNormal];
        
    }
    
    if (buttonStyle.imagesHighted) {
        
        [self setImage:[UIImage imageNamed:buttonStyle.imagesHighted]
              forState:UIControlStateHighlighted];
        
    }
    
    if (buttonStyle.imagesSelected) {
        
        [self setImage:[UIImage imageNamed:buttonStyle.imagesSelected]
              forState:UIControlStateSelected];
        
    }
    
    if (buttonStyle.cornerRadio > 1.0f && buttonStyle.cornerRadio <= 100.0f) {
        
        self.layer.cornerRadius = buttonStyle.cornerRadio;
        
    }
    
    if (buttonStyle.titleFont) {
        
        self.titleLabel.font = buttonStyle.titleFont;
        
    }

}

@end
