//
//  QSCustomPickerView.h
//  House
//
//  Created by ysmeng on 15/1/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///选择器的类型
typedef enum
{
    
    cCustomPickerTypeNavigationBarCity = 0,         //!<选择城市
    cCustomPickerTypeNavigationBarHouseMainType,    //!<房子的主要类型过滤
    
    cCustomPickerTypeChannelBarDistrict,            //!<频道栏地区选择
    cCustomPickerTypeChannelBarHouseType,           //!<频道栏户型选择
    cCustomPickerTypeChannelBarTotalPrice           //!<频道栏总价选择
    
}CUSTOM_PICKER_TYPE;                                //!<选择器类型

///选择器回调事件类型
typedef enum
{

    pPickerCallBackActionTypeShow = 99,     //!<显示时的回调
    pPickerCallBackActionTypeUnPickedHidden,//!<未选择时隐藏回调
    pPickerCallBackActionTypePicked         //!<已选择

}PICKER_CALLBACK_ACTION_TYPE;

///选择器风格：左侧定位按钮/右侧箭头
typedef enum
{
    
    cCustomPickerStyleRightLocal = 0,//!<左侧定位按钮的选择view
    cCustomPickerStyleLeftArrow      //!<右侧箭头选择view
    
}CUSTOM_PICKER_STYLE;                //!<选择器风格

@interface QSCustomPickerView : UIView

/**
 *  @author             yangshengmeng, 15-01-30 11:01:11
 *
 *  @brief              创建一个选择view
 *
 *  @param frame        大小和位置
 *  @param pickerType   选择器的类型
 *  @param pickerStyle  选择器的风格
 *  @param callBack     选择内容后的回调
 *
 *  @return             返回当前创建的选择view
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andPickerType:(CUSTOM_PICKER_TYPE)pickerType andPickerViewStyle:(CUSTOM_PICKER_STYLE)pickerStyle andIndicaterCenterXPoint:(CGFloat)xpoint andPickedCallBack:(void(^)(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey,NSString *pickedVal))callBack;

/**
 *  @author yangshengmeng, 15-01-30 13:01:48
 *
 *  @brief  移聊当前弹出的选择框
 *
 *  @since  1.0.0
 */
- (void)removePickerView;

@end
