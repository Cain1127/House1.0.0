//
//  QSBlockButton.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSBlockButtonStyleModel.h"

@interface UIButton (QSBlockButton)

/**
 *  @author             yangshengmeng, 15-01-20 14:01:46
 *
 *  @brief              创建一个没有相对位置和大小的指定风格按钮，方便自适应使用
 *
 *  @param buttonStyle  按钮风格模型
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回创建的按钮
 *
 *  @since              1.0.0
 */
+ (UIButton *)createBlockButtonWithButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andCallBack:(void(^)(UIButton *button))callBack;

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
+ (UIButton *)createBlockButtonWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andCallBack:(void(^)(UIButton *button))callBack;

@end

/**
 *  @author yangshengmeng, 15-01-17 18:01:55
 *
 *  @brief  自定义具备回调功能的按钮
 *
 *  @since  1.0.0
 */
@interface QSBlockButton : UIButton

@property (nonatomic,copy) void(^blockButtonCallBack)(UIButton *button);//!<单击时的回调

/**
 *  @author             yangshengmeng, 15-01-20 14:01:44
 *
 *  @brief              创建一个没有frame的按钮
 *
 *  @param buttonStyle  按钮的风格
 *
 *  @return             返回当前按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithButtonStyle:(QSBlockButtonStyleModel *)buttonStyle;

/**
 *  @author             yangshengmeng, 15-01-17 18:01:29
 *
 *  @brief              创建一个特定风格的自定义按钮
 *
 *  @param frame        在父视图的位置和大小
 *  @param buttonStyle  按钮风格
 *
 *  @return             返回特定风格的回调按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle;


- (void)setButtonPropertyWithButtonStyle:(QSBlockButtonStyleModel *)buttonStyle;

@end
