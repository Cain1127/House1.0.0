//
//  QSTurnBackViewController.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMasterViewController.h"

@interface QSTurnBackViewController : QSMasterViewController

@property (nonatomic,assign) BOOL hiddenCustomTabbarWhenPush;   //!<当push时是否隐藏tabbar

/**
 *  @author yangshengmeng, 15-03-26 11:03:13
 *
 *  @brief  返回事件
 *
 *  @since  1.0.0
 */
- (void)gotoTurnBackAction;

/**
 *  @author             yangshengmeng, 15-01-17 23:01:53
 *
 *  @brief              设置返回时，跳转到当前相差stepCount个的页面，如若超过rootView，则直接显示rootView
 *
 *  @param stepCount    跳转的步距
 *
 *  @since              1.0.0
 */
- (void)setTurnBackDistanceStep:(int)stepCount;

@end
