//
//  UIButton+Factory.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSBlockButton.h"

///自定义按钮的类型
typedef enum
{

    cCustomButtonStyleTopTitle = 99,    //!<标题在上，图片在下的按钮
    cCustomButtonStyleBottomTitle,      //!<标题在下，图片在上的按钮
    cCustomButtonStyleLeftTitle,        //!<标题在左，图片在右的按钮
    cCustomButtonStyleRightTitle        //!<标题在右，图片在左的按钮

}CUSTOM_BUTTOM_STYLE;

/**
 *  @author yangshengmeng, 15-01-29 16:01:39
 *
 *  @brief  不同的自定义按钮统一创建接口
 *
 *  @since  1.0.0
 */
@interface UIButton (Factory)

/**
 *  @author             yangshengmeng, 15-01-29 16:01:30
 *
 *  @brief              创建指定类型的自定义按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮属性模型
 *  @param buttonType   按钮类型
 *  @param titleHeight  标题所占的高度/宽度
 *  @param gap          标题和图片的间隙
 *  @param callBack     按钮的回调
 *
 *  @return             返回创建的按钮
 *
 *  @since              1.0.0
 */
+ (UIButton *)createCustomStyleButtonWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andCustomButtonStyle:(CUSTOM_BUTTOM_STYLE)buttonType andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack;

@end

/**
 *  @author yangshengmeng, 15-01-29 16:01:48
 *
 *  @brief  自定义标题在顶部的按钮
 *
 *  @since  1.0.0
 */
@interface QSTopTitleButton : QSBlockButton

/**
 *  @author             yangshengmeng, 15-01-29 16:01:27
 *
 *  @brief              根据给定的按钮属性和风格，创建一个单击回调按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮相关属性
 *  @param gap          图片的标题之间的间隙：默认为2.0
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回当前创建的按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack;

@end

/**
 *  @author yangshengmeng, 15-01-29 16:01:48
 *
 *  @brief  自定义标题在底部的按钮
 *
 *  @since  1.0.0
 */
@interface QSBottomTitleButton : QSBlockButton

/**
 *  @author             yangshengmeng, 15-01-29 16:01:27
 *
 *  @brief              根据给定的按钮属性和风格，创建一个单击回调按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮相关属性
 *  @param gap          图片的标题之间的间隙：默认为2.0
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回当前创建的按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack;

@end

/**
 *  @author yangshengmeng, 15-01-29 16:01:48
 *
 *  @brief  自定义标题在左侧的按钮
 *
 *  @since  1.0.0
 */
@interface QSLeftTitleButton : QSBlockButton

/**
 *  @author             yangshengmeng, 15-01-29 16:01:27
 *
 *  @brief              根据给定的按钮属性和风格，创建一个单击回调按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮相关属性
 *  @param gap          图片的标题之间的间隙：默认为2.0
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回当前创建的按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack;

@end

/**
 *  @author yangshengmeng, 15-01-29 16:01:48
 *
 *  @brief  自定义标题在右侧的按钮
 *
 *  @since  1.0.0
 */
@interface QSRightTitleButton : QSBlockButton

/**
 *  @author             yangshengmeng, 15-01-29 16:01:27
 *
 *  @brief              根据给定的按钮属性和风格，创建一个单击回调按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮相关属性
 *  @param gap          图片的标题之间的间隙：默认为2.0
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回当前创建的按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack;

@end