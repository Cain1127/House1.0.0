//
//  QSYPopCustomView.h
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPopRootView.h"

@interface QSYPopCustomView : QSCustomPopRootView

/**
 *  @author         yangshengmeng, 15-03-13 14:03:49
 *
 *  @brief          弹出一个自定义的功能view
 *
 *  @param view     给定的view
 *  @param callBack 弹出窗口的回调事件
 *
 *  @return         返回当前的弹出窗口
 *
 *  @since          1.0.0
 */
+ (instancetype)popCustomView:(UIView *)view andPopViewActionCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))callBack;

@end
