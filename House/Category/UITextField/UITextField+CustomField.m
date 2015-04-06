//
//  UITextField+CustomField.m
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "UITextField+CustomField.h"
#import "NSString+Calculation.h"

@implementation UITextField (CustomField)

/**
 *  @author             yangshengmeng, 15-01-24 12:01:48
 *
 *  @brief              根据给定的风格，创建一个没有frame的自定义输入框
 *
 *  @param fieldStyle   输入框的自定义风格
 *
 *  @return             返回当前创建的输入框
 *
 *  @since              1.0.0
 */
+ (UITextField *)createCustomTextFieldWithStyle:(CUSTOM_TEXTFIELD_STLYE)fieldStyle andLeftTipsInfo:(NSString *)info andLeftTipsAlignment:(NSTextAlignment)alignment
{

    return nil;

}

/**
 *  @author yangshengmeng, 15-01-24 12:01:32
 *
 *  @brief              创建一个给定位置和大小，具有特定自定义风格的输入框
 *
 *  @param frame        位置和大小
 *  @param fieldStyle   自定义风格
 *
 *  @return             返回当前创建的输入框
 *
 *  @since              1.0.0
 */
+ (UITextField *)createCustomTextFieldWithFrame:(CGRect)frame andPlaceHolder:(NSString *)placeHoulder andLeftTipsInfo:(NSString *)info andLeftTipsTextAlignment:(NSTextAlignment)alignment andTextFieldStyle:(CUSTOM_TEXTFIELD_STLYE)fieldStyle
{

    return [self createCustomTextFieldWithFrame:frame andPlaceHolder:placeHoulder andLeftTipsInfo:info andRightTipsInfo:nil andLeftTipsTextAlignment:alignment andTextFieldStyle:fieldStyle];

}

+ (UITextField *)createCustomTextFieldWithFrame:(CGRect)frame andPlaceHolder:(NSString *)placeHoulder andLeftTipsInfo:(NSString *)leftInfo andRightTipsInfo:(NSString *)rightInfo andLeftTipsTextAlignment:(NSTextAlignment)alignment andTextFieldStyle:(CUSTOM_TEXTFIELD_STLYE)fieldStyle
{

    QSTextField *textField = [[QSTextField alloc] initWithFrame:frame];
    
    ///左右view
    UIView *rightView = nil;
    UIView *leftView = nil;
    
    ///根据类型添加不同的控件
    switch (fieldStyle) {
            ///单纯右箭头
        case cCustomTextFieldStyleRightArrow:
            
            rightView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 13.0f, 23.0f)];
            ((UIImageView *)rightView).image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            
            break;
            
            ///左提示(浅灰)
        case cCustomTextFieldStyleLeftTipsLightGray:
        {
        
            ///获取文字显示最小长度
            CGFloat width = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, width + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
        
        }
            break;
            
            ///右箭头+左提示信息(浅灰)
        case cCustomTextFieldStyleRightArrowLeftTipsLightGray:
        {
            
            ///获取文字显示最小长度
            CGFloat width = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, width + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
            ///右箭头
            rightView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 13.0f, 23.0f)];
            ((UIImageView *)rightView).image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            
        }
            break;
            
            ///左提示(深灰)
        case cCustomTextFieldStyleLeftTipsGray:
        {
            
            ///获取文字显示最小长度
            CGFloat width = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, width + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
        }
            break;
            
            ///右箭头+左提示(深灰)
        case cCustomTextFieldStyleRightArrowLeftTipsGray:
        {
            
            ///获取文字显示最小长度
            CGFloat width = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, width + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
            ///右箭头
            rightView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 13.0f, 23.0f)];
            ((UIImageView *)rightView).image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            
        }
            break;
            
            ///左提示(黑色)
        case cCustomTextFieldStyleLeftTipsBlack:
        {
            
            ///获取文字显示最小长度
            CGFloat width = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, width + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
        }
            break;
            ///右箭头+左提示(黑色)
        case cCustomTextFieldStyleRightArrowLeftTipsBlack:
        {
            
            ///获取文字显示最小长度
            CGFloat width = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, width + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
            ///右箭头
            rightView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 13.0f, 23.0f)];
            ((UIImageView *)rightView).image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            
        }
            break;
            
            ///左右都是文字提示:文字黑色
        case cCustomTextFieldStyleLeftAndRightTipsBlack:
        {
            
            ///获取文字显示最小长度
            CGFloat widthLeft = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, widthLeft + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
            ///右箭头
            ((UIImageView *)rightView).image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            
            CGFloat widthRight = [rightInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            QSLabel *rightTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, widthRight + 30.0f, 44.0)];
            rightTipsLabel.textAlignment = NSTextAlignmentRight;
            rightTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
            rightTipsLabel.text = rightInfo;
            rightView = rightTipsLabel;
            
        }
            break;
            
            ///左右都是文字提示+ 右箭头:文字黑色
        case cCustomTextFieldStyleLeftAndRightTipsAndRightArrowBlack:
        {
            
            ///获取文字显示最小长度
            CGFloat widthLeft = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, widthLeft + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
            ///右箭头
            ((UIImageView *)rightView).image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            
            CGFloat widthRight = [rightInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            QSLabel *rightTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, widthRight + 30.0f, 44.0)];
            rightTipsLabel.textAlignment = NSTextAlignmentCenter;
            rightTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
            rightTipsLabel.text = rightInfo;
            rightView = rightTipsLabel;
            
        }
            break;

            
            
            ///左右都是文字提示:文字灰色
        case cCustomTextFieldStyleLeftAndRightTipsGray:
        {
            
            ///获取文字显示最小长度
            CGFloat widthLeft = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, widthLeft + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
            ///右箭头
            ((UIImageView *)rightView).image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            
            CGFloat widthRight = [rightInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            QSLabel *rightTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, widthRight + 30.0f, 44.0)];
            rightTipsLabel.textAlignment = NSTextAlignmentRight;
            rightTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
            rightTipsLabel.text = rightInfo;
            rightView = rightTipsLabel;
            
        }
            break;
            
            ///左右都是文字提示:文字浅灰色
        case cCustomTextFieldStyleLeftAndRightTipsLightGray:
        {
            
            ///获取文字显示最小长度
            CGFloat widthLeft = [leftInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            
            QSLabel *leftTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, widthLeft + 30.0f, 44.0)];
            leftTipsLabel.textAlignment = alignment;
            leftTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
            leftTipsLabel.text = leftInfo;
            leftView = leftTipsLabel;
            
            ///右箭头
            ((UIImageView *)rightView).image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
            
            CGFloat widthRight = [rightInfo calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_BODY_16];
            QSLabel *rightTipsLabel = [self createCustomFieldTipsLableWithFrame:CGRectMake(0.0f, 0.0f, widthRight + 30.0f, 44.0)];
            rightTipsLabel.textAlignment = NSTextAlignmentRight;
            rightTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
            rightTipsLabel.text = rightInfo;
            rightView = rightTipsLabel;
            
        }
            break;
            
        default:
            break;
    }
    
    ///加载左右控件
    if (rightView) {
        
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = rightView;
        
    } else {
    
        textField.rightViewMode = UITextFieldViewModeNever;
    
    }
    
    if (leftView) {
        
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftView;
        
    } else {
    
        textField.leftViewMode = UITextFieldViewModeNever;
    
    }
    
    ///提示信息
    if (placeHoulder) {
        
        textField.placeholder = placeHoulder;
        
    }
    
    return textField;

}

///创建左侧提示UILabel
+ (QSLabel *)createCustomFieldTipsLableWithFrame:(CGRect)frame
{

    QSLabel *leftTipsLabel = [[QSLabel alloc] initWithFrame:frame andTopGap:2.0f andBottomGap:2.0f andLeftGap:2.0f andRightGap:20.0f];
    leftTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    
    return leftTipsLabel;

}

@end
