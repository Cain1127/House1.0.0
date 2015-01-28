//
//  QSViewControllerAnimatedTransitioning.h
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author yangshengmeng, 15-01-27 22:01:44
 *
 *  @brief  自定义动画过渡类
 *
 *  @since  1.0.0
 */
@interface QSViewControllerAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithPresenting:(BOOL)isPresenting;

@end
