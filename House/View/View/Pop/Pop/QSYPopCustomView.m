//
//  QSYPopCustomView.m
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYPopCustomView.h"

@implementation QSYPopCustomView

#pragma mark - 弹出一个自定义的功能view
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
+ (instancetype)popCustomView:(UIView *)view andPopViewActionCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))callBack
{

    ///弹出框
    __block QSYPopCustomView *popView = [[QSYPopCustomView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    popView.customPopviewTapCallBack = callBack;
    
    ///添加自定义的view
    view.frame = CGRectMake(0.0f, popView.frame.size.height - view.frame.size.height, popView.frame.size.width, view.frame.size.width);
    [popView addSubview:view];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    ///显示
    if ([popView respondsToSelector:@selector(showCustomPopview)]) {
        
        [popView performSelector:@selector(showCustomPopview)];
        
    }
    
#pragma clang diagnostic pop
    
    return popView;

}

@end
