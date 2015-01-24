//
//  QSLabel.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-01-17 15:01:34
 *
 *  @brief  重写UILabel的标题显示区域，默认显示的内容上下左右各有2.0像素的间隙
 *
 *  @since  2.0
 */
@interface QSLabel : UILabel

/**
 *  @author     yangshengmeng, 15-01-24 09:01:42
 *
 *  @brief      创建一个上下左右都是统一间隙的UILabel
 *
 *  @param gap  上下左右固定的文字间隙
 *
 *  @return     返回当前创建的UILabel
 *
 *  @since      1.0.0
 */
- (instancetype)initWithGap:(CGFloat)gap;

/**
 *  @author             yangshengmeng, 15-01-24 09:01:19
 *
 *  @brief              根据上下左右的间隙初始化一个标签，文字按给定的距离放置
 *
 *  @param topGap       文字顶部间隙
 *  @param bottomGap    文字底部间隙
 *  @param leftGap      文字左侧间隙
 *  @param rightGap     文字右侧间隙
 *
 *  @return             返回当前创建的UILabel
 *
 *  @since              1.0.0
 */
- (instancetype)initWithGap:(CGFloat)topGap andBottomGap:(CGFloat)bottomGap andLeftGap:(CGFloat)leftGap andRightGap:(CGFloat)rightGap;

/**
 *  @author     yangshengmeng, 15-01-24 09:01:42
 *
 *  @brief      创建一个上下左右都是统一间隙的UILabel
 *
 *  @param gap  上下左右固定的文字间隙
 *
 *  @return     返回当前创建的UILabel
 *
 *  @since      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andGap:(CGFloat)gap;

/**
 *  @author             yangshengmeng, 15-01-24 09:01:19
 *
 *  @brief              根据上下左右的间隙初始化一个标签，文字按给定的距离放置
 *
 *  @param topGap       文字顶部间隙
 *  @param bottomGap    文字底部间隙
 *  @param leftGap      文字左侧间隙
 *  @param rightGap     文字右侧间隙
 *
 *  @return             返回当前创建的UILabel
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andTopGap:(CGFloat)topGap andBottomGap:(CGFloat)bottomGap andLeftGap:(CGFloat)leftGap andRightGap:(CGFloat)rightGap;

@end
