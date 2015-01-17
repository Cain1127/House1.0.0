//
//  QSTabbar.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSImageView.h"

/**
 *  @bridf  自定义tabbar
 */
@interface QSTabbar : QSImageView

/**
 *  @author         yangshengmeng, 15-01-17 17:01:12
 *
 *  @brief          按给定的tabbar信息初始化一个tabbar
 *
 *  @param frame    在父视图中的位置和大小
 *  @param array    tabbar按钮信息
 *
 *  @return         返回一个tabbar
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andTabbarButtonArray:(NSArray *)array andTabbarTapCallBack:(void(^)(int index))callBack;

/**
 *  @author         yangshengmeng, 15-01-17 17:01:07
 *
 *  @brief          设置给定下标的tabbarItem处于选择状态
 *
 *  @param index    给定下标
 *
 *  @since          1.0.0
 */
- (void)setCurrentSelectedIndex:(int)index;

/**
 *  @author             yangshengmeng, 15-01-17 18:01:11
 *
 *  @brief              在特定下标的按钮右上角显示红色提示信息
 *
 *  @param tipsString   提示信息
 *  @param index        下标
 *
 *  @since              1.0.0
 */
- (void)setUpperRightCornerTipsWithString:(NSString *)tipsString andIndex:(int)index;

@end
