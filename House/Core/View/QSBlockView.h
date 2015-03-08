//
//  QSBlockView.h
//  House
//
//  Created by ysmeng on 15/3/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-03-08 13:03:57
 *
 *  @brief  自定义，自带单击事件的UIView
 *
 *  @since  1.0.0
 */
@interface QSBlockView : UIView

/**
 *  @author                     yangshengmeng, 15-03-08 13:03:28
 *
 *  @brief                      根据给定的单击回调block，创建一个带有单击回调的 UIView
 *
 *  @param singleTapCallBack    单击时的回调
 *
 *  @return                     返回当前创建的回调View
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithSingleTapBlock:(void(^)(BOOL flag))singleTapCallBack;
- (instancetype)initWithFrame:(CGRect)frame andSingleTapCallBack:(void(^)(BOOL flag))singleTapCallBack;

@end
