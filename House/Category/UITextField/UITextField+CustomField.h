//
//  UITextField+CustomField.h
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///自定义输入框的几种常用风格
typedef enum
{
    
    cCustomTextFieldStyleRightArrow = 0,                    //!<纯右侧剪头输入框
    cCustomTextFieldStyleRightArrowLeftTipsLightGray,       //!<右箭头+左提示信息(浅灰)
    cCustomTextFieldStyleRightArrowLeftTipsBlack,           //!<右箭头+左提示(黑色)
    cCustomTextFieldStyleRightArrowLeftTipsGray,            //!<右箭头+左提示(灰色)
    cCustomTextFieldStyleLeftTipsLightGray,                 //!<左提示(浅灰)
    cCustomTextFieldStyleLeftTipsGray,                      //!<左提示(深灰)
    cCustomTextFieldStyleLeftTipsBlack,                     //!<左提示(黑色)
    cCustomTextFieldStyleLeftAndRightTipsBlack,             //!<左右都是文字提示:文字黑色
    cCustomTextFieldStyleLeftAndRightTipsGray,              //!<左右都是文字提示：灰色
    cCustomTextFieldStyleLeftAndRightTipsLightGray,         //!<左右都是文字提示：浅灰色
    cCustomTextFieldStyleLeftAndRightTipsAndRightArrowBlack,//!<左右都是文字提示:文字黑色
    
}CUSTOM_TEXTFIELD_STLYE;                                    //!<自定义输入框的几种常用风格

/**
 *  @author yangshengmeng, 15-01-24 12:01:32
 *
 *  @brief  常用的输入框工厂创建类型
 *
 *  @since  1.0.0
 */
@interface UITextField (CustomField)

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
+ (UITextField *)createCustomTextFieldWithStyle:(CUSTOM_TEXTFIELD_STLYE)fieldStyle andLeftTipsInfo:(NSString *)info andLeftTipsAlignment:(NSTextAlignment)alignment;

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
+ (UITextField *)createCustomTextFieldWithFrame:(CGRect)frame andPlaceHolder:(NSString *)placeHoulder andLeftTipsInfo:(NSString *)info andLeftTipsTextAlignment:(NSTextAlignment)alignment andTextFieldStyle:(CUSTOM_TEXTFIELD_STLYE)fieldStyle;

+ (UITextField *)createCustomTextFieldWithFrame:(CGRect)frame andPlaceHolder:(NSString *)placeHoulder andLeftTipsInfo:(NSString *)leftInfo andRightTipsInfo:(NSString *)rightInfo andLeftTipsTextAlignment:(NSTextAlignment)alignment andTextFieldStyle:(CUSTOM_TEXTFIELD_STLYE)fieldStyle;

@end
