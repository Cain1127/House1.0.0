//
//  QSMultipleSelectedPopView.h
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPopRootView.h"

@interface QSMultipleSelectedPopView : QSCustomPopRootView

#pragma mark - 根据数据源创建并显示一个多选窗口
/**
 *  @author                 yangshengmeng, 15-01-27 15:01:29
 *
 *  @brief                  弹出一个给定数据源的复选框
 *
 *  @param dataSource       数据源：数组-字典-必须包涵以下两个字段：info-显示信息，selected-选择状态:1,0
 *  @param currentIndex     当前选择状态的选择项
 *  @param selectedCallBack 选择并确认后的回调
 *
 *  @return                 返回当前创建的弹出窗口
 *
 *  @since                  1.0.0
 */
+ (instancetype)showMultipleSelectedViewWithDataSource:(NSArray *)dataSource andSelectedSource:(NSArray *)selectedDataSource andSelectedCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))selectedCallBack;

@end
