//
//  QSCustomSingleSelectedPopView.h
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPopRootView.h"

/**
 *  @author yangshengmeng, 15-01-27 15:01:44
 *
 *  @brief  弹出自定义的单选框
 *
 *  @since  1.0.0
 */
@interface QSCustomSingleSelectedPopView : QSCustomPopRootView

/**
 *  @author                 yangshengmeng, 15-01-27 15:01:29
 *
 *  @brief                  弹出一个给定数据源的单选框
 *
 *  @param dataSource       数据源
 *  @param currentIndex     当前选择状态的选择项
 *  @param selectedCallBack 选择并确认后的回调
 *
 *  @return                 返回当前创建的弹出窗口
 *
 *  @since                  1.0.0
 */
+ (instancetype)showSingleSelectedViewWithDataSource:(NSArray *)dataSource andCurrentSelectedKey:(NSString *)selectedKey andSelectedCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int index))selectedCallBack;

/**
 *  @author                 yangshengmeng, 15-01-27 15:01:29
 *
 *  @brief                  弹出一个给定数据源的单选框，没有不限选择项和确认按钮
 *
 *  @param dataSource       数据源
 *  @param currentIndex     当前选择状态的选择项
 *  @param selectedCallBack 选择并确认后的回调
 *
 *  @return                 返回当前创建的弹出窗口
 *
 *  @since                  1.0.0
 */
+ (instancetype)showSingleSelectedViewNoConfirmWithDataSource:(NSArray *)dataSource andCurrentSelectedKey:(NSString *)selectedKey andSelectedCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int index))selectedCallBack;

@end
