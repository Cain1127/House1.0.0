//
//  QSLabel.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSLabel.h"

@interface QSLabel ()

@property (nonatomic,assign) CGFloat topGap;    //!<文字的上间隙
@property (nonatomic,assign) CGFloat bottomGap; //!<文字的上间隙
@property (nonatomic,assign) CGFloat leftGap;   //!<文字的上间隙
@property (nonatomic,assign) CGFloat rightGap;  //!<文字的上间隙

@end

@implementation QSLabel

#pragma mark - 初始化
- (instancetype)init
{

    return [self initWithGap:2.0f];

}

- (instancetype)initWithFrame:(CGRect)frame
{

    return [self initWithFrame:frame andTopGap:2.0f andBottomGap:2.0f andLeftGap:2.0f andRightGap:2.0f];

}

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
- (instancetype)initWithGap:(CGFloat)gap
{

    return [self initWithGap:gap andBottomGap:gap andLeftGap:gap andRightGap:gap];

}

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
- (instancetype)initWithGap:(CGFloat)topGap andBottomGap:(CGFloat)bottomGap andLeftGap:(CGFloat)leftGap andRightGap:(CGFloat)rightGap
{

    if (self = [super init]) {
        
        ///保存固定文字间隙
        self.topGap = (topGap >= 1.0f) ? topGap : 2.0f;
        self.bottomGap = (bottomGap >= 1.0f) ? bottomGap : 2.0f;
        self.leftGap = (leftGap >= 1.0f) ? leftGap : 2.0f;
        self.rightGap = (rightGap >= 1.0f) ? rightGap : 2.0f;
        
    }
    
    return self;

}

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
- (instancetype)initWithFrame:(CGRect)frame andGap:(CGFloat)gap
{

    return [self initWithFrame:frame andTopGap:gap andBottomGap:gap andLeftGap:gap andRightGap:gap];

}

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
- (instancetype)initWithFrame:(CGRect)frame andTopGap:(CGFloat)topGap andBottomGap:(CGFloat)bottomGap andLeftGap:(CGFloat)leftGap andRightGap:(CGFloat)rightGap
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存固定文字间隙
        self.topGap = (topGap >= 1.0f) ? topGap : 2.0f;
        self.bottomGap = (bottomGap >= 1.0f) ? bottomGap : 2.0f;
        self.leftGap = (leftGap >= 1.0f) ? leftGap : 2.0f;
        self.rightGap = (rightGap >= 1.0f) ? rightGap : 2.0f;
        
    }
    
    return self;

}

/**
 *  @author                 yangshengmeng, 15-01-17 15:01:22
 *
 *  @brief                  重写文本信息显示的位置
 *
 *  @param rect             当前Label文字的编制位置的大小
 *
 *  @return                 返回文本信息显示的区域
 *
 *  @since                  1.0.0
 */
- (void)drawTextInRect:(CGRect)rect
{

    [super drawTextInRect:CGRectMake(rect.origin.x + self.leftGap, rect.origin.y + self.topGap, rect.size.width - (self.leftGap + self.rightGap), rect.size.height - (self.topGap + self.bottomGap))];

}

@end
