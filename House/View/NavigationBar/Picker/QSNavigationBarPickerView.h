//
//  QSNavigationBarPickerView.h
//  House
//
//  Created by ysmeng on 15/1/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///导航栏选择器的类型
typedef enum
{

    nNavigationBarPickerStyleTypeCity = 0,      //!<选择城市
    nNavigationBarPickerStyleTypeHouseMainType, //!<房子的主要类型过滤

}NAVIGATIONBAR_PICKER_TYPE;                     //!<导航栏选择器类型

///导航栏选择器风格：左侧定位按钮/右侧箭头
typedef enum
{
    
    nNavigationBarPickerStyleRightLocal = 0,//!<左侧定位按钮的选择view
    nNavigationBarPickerStyleLeftArrow      //!<右侧箭头选择view
    
}NAVIGATIONBAR_PICKER_STYLE;                //!<导航栏选择器风格

/**
 *  @author yangshengmeng, 15-01-29 14:01:45
 *
 *  @brief  导航栏选择器工厂创建中心
 *
 *  @since  1.0.0
 */
@interface QSNavigationBarPickerView : UIView

/**
 *  @author             yangshengmeng, 15-01-29 14:01:47
 *
 *  @brief              创建一个导航栏的选择器
 *
 *  @param frame        大小和位置
 *  @param pickerType   选择器的类型
 *  @param pickerStyle  选择器的风格
 *  @param callBack     选择后的回调
 *
 *  @return             返回当前创建的选择器
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andPickerType:(NAVIGATIONBAR_PICKER_TYPE)pickerType andPickerViewStyle:(NAVIGATIONBAR_PICKER_STYLE)pickerStyle andPickedCallBack:(void(^)(NSString *cityKey,NSString *cityVal))callBack;

@end
