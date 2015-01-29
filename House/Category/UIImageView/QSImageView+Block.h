//
//  QSImageView+Block.h
//  House
//
//  Created by ysmeng on 15/1/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSImageView.h"

/**
 *  @author yangshengmeng, 15-01-29 15:01:33
 *
 *  @brief  创建单击回调的block图片view
 *
 *  @since  1.0.0
 */
@interface QSImageView (Block)

/**
 *  @author         yangshengmeng, 15-01-29 15:01:10
 *
 *  @brief          创建一个有单击事件的图片view
 *
 *  @param frame    大小和位置
 *  @param callBack 单击时的回调
 *
 *  @since          1.0.0
 */
+ (UIImageView *)createBlockImageViewWithFrame:(CGRect)frame andSingleTapCallBack:(void(^)(void))callBack;

@end

/**
 *  @author yangshengmeng, 15-01-29 15:01:55
 *
 *  @brief  单击后回调的图片view
 *
 *  @since  1.0.0
 */
@interface QSBlockImageView : UIImageView

/**
 *  @author         yangshengmeng, 15-01-29 15:01:40
 *
 *  @brief          匿名的初始化方法
 *
 *  @param frame    大小和位置
 *  @param callBack 单击时的回调
 *
 *  @return         返回当前创建的单击图片view
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSingleTapCallBack:(void(^)(void))callBack;

@end