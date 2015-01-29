//
//  QSCustomSelectedView.h
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///选择框的类型：单选，多选
typedef enum
{

    cCustomSelectedViewTypeSingle = 0,  //!<单选类型
    cCustomSelectedViewTypeMultiple     //!<多选

}CUSTOM_SELECTED_VIEW_TYPE;

/**
 *  @author yangshengmeng, 15-01-27 16:01:00
 *
 *  @brief  选择框
 *
 *  @since  1.0.0
 */
@interface QSCustomSelectedView : UIView

@property (nonatomic,assign) BOOL selectedStatus;   //!<选择框的状态

/**
 *  @author             yangshengmeng, 15-01-27 16:01:11
 *
 *  @brief              根据给定的信息和类型，创建一个选择view
 *
 *  @param frame        大小和位置
 *  @param info         选择项的显示信息
 *  @param selectedType 选择框的类型
 *
 *  @return             返回当前创建的选择框
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedInfo:(NSString *)info andSelectedType:(CUSTOM_SELECTED_VIEW_TYPE)selectedType andSelectedBoxTapCallBack:(void(^)(BOOL currentStatus))selectedBoxCallBack;

@end
