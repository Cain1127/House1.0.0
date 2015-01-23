//
//  UITextField+RightArrow.h
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (RightArrow)

/**
 *  @author yangshengmeng, 15-01-23 14:01:32
 *
 *  @brief  创建一个右侧带有箭头的输入框
 *
 *  @return 返回一个右侧带有箭头的输入框
 *
 *  @since  1.0.0
 */
+ (UITextField *)createRightArrowTextField;

/**
 *  @author yangshengmeng, 15-01-23 14:01:32
 *
 *  @brief  创建一个有大小的，右侧带有箭头的输入框
 *
 *  @return 返回一个右侧带有箭头的输入框
 *
 *  @since  1.0.0
 */
+ (UITextField *)createRightArrowTextFieldWithFrame:(CGRect)frame;

@end

/**
 *  @author yangshengmeng, 15-01-23 14:01:31
 *
 *  @brief  自定义右侧带有箭头输入框
 *
 *  @since  1.0.0
 */
@interface QSRightArrowTextField : UITextField

@end