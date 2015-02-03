//
//  QSCustomDistrictSelectedPopView.h
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPopRootView.h"

@interface QSCustomDistrictSelectedPopView : QSCustomPopRootView

/**
 *  @author                     yangshengmeng, 15-02-03 14:02:48
 *
 *  @brief                      从下往上弹出一个地区选择窗口
 *
 *  @param selectedStreetKey    当前选择状态的街道
 *  @param callBack             选择后的回调
 *
 *  @return                     返回当前弹出框
 *
 *  @since                      1.0.0
 */
+ (instancetype)showCustomDistrictSelectedPopviewWithSteetSelectedKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))callBack;

@end
