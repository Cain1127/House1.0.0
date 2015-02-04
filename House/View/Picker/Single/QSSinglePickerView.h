//
//  QSSinglePickerView.h
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///单选项选择后的回调类型
typedef enum
{

    sSinglePickviewPickedTypeUnLimited = 99,//!<不限
    sSinglePickviewPickedTypePicked         //!<已选择
    
}SINGLE_PICKVIEW_PICKEDTYPE;

/**
 *  @author yangshengmeng, 15-02-03 09:02:29
 *
 *  @brief  单项选择窗口
 *
 *  @since  1.0.0
 */
@interface QSSinglePickerView : UIScrollView

/**
 *  @author             yangshengmeng, 15-02-04 09:02:48
 *
 *  @brief              创建一个给定数据源的单选项view
 *
 *  @param frame        大小和位置
 *  @param dataSource   数据源
 *  @param selectedKey  当前选择状态的key
 *  @param callBack     选择一项内容的一的回调
 *
 *  @return             返回当前创建的单选项窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)dataSource andSelectedKey:(NSString *)selectedKey andPickedCallBack:(void(^)(SINGLE_PICKVIEW_PICKEDTYPE pickedType,id params))callBack;

@end
