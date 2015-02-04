//
//  QSCityPickerView.h
//  House
//
//  Created by ysmeng on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///回调事件的类型
typedef enum
{
    
    cCustomCityPickerActionTypeUnLimitedProvince,   //!<不限城市
    cCustomCityPickerActionTypeUnLimitedCity,       //!<不限街道
    cCustomCityPickerActionTypePickedProvince,      //!<选择区
    cCustomCityPickerActionTypePickedCity           //!<选择街道
    
}CUSTOM_CITY_PICKER_ACTION_TYPE;                    //!<选择地区后的回调类型

/**
 *  @author yangshengmeng, 15-02-03 09:02:29
 *
 *  @brief  城市选择窗口
 *
 *  @since  1.0.0
 */
@class QSCDBaseConfigurationDataModel;
@interface QSCityPickerView : UIView

/**
 *  @author                     yangshengmeng, 15-02-03 10:02:08
 *
 *  @brief                      显示城市选择窗口
 *
 *  @param frame                大小和位置
 *  @param selectedProvinceKey  当前选择省的key
 *  @param selectedCityKey      当前选择城市的key
 *  @param callBack             选择后的回调
 *
 *  @return                     返回一个城市选择对象
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedCityKey:(NSString *)selectedCityKey andDistrictPickeredCallBack:(void(^)(CUSTOM_CITY_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *provincetModel,QSCDBaseConfigurationDataModel *cityModel))callBack;

@end
