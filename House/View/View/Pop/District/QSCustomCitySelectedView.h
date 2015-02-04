//
//  QSCustomCitySelectedView.h
//  House
//
//  Created by ysmeng on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPopRootView.h"

/**
 *  @author yangshengmeng, 15-02-03 11:02:32
 *
 *  @brief  城市选择窗口
 *
 *  @since  1.0.0
 */
@interface QSCustomCitySelectedView : QSCustomPopRootView

/**
 *  @author                     yangshengmeng, 15-02-03 11:02:18
 *
 *  @brief                      弹出一个城市选择窗口
 *
 *  @param selectedProvinceKey  当前选择状态的省份
 *  @param selectedCityKey      当前选择状态的城市
 *  @param callBack             选择城市后的回调
 *
 *  @return                     返回当前的城市弹出框
 *
 *  @since                      1.0.0
 */
+ (instancetype)showCustomCitySelectedPopviewWithCitySelectedKey:(NSString *)selectedCityKey andCityPickeredCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))callBack;

@end
