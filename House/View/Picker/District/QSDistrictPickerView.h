//
//  QSDistrictPickerView.h
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///地区选择的类型
typedef enum
{

    cCustomDistrictPickerLevelTypeCity = 0, //!<只选择城市
    cCustomDistrictPickerLevelTypeDistrict, //!<可以选择对应城市的区
    cCustomDistrictPickerLevelTypeStreet    //!<可以选择街道

}CUSTOM_DISTRICT_PICKER_LEVEL_TYPE;         //!<地区选择的级别类型

///回调事件的类型
typedef enum
{

    cCustomDistrictPickerActionTypeUnLimitedCity = 0,   //!<不限城市
    cCustomDistrictPickerActionTypeUnLimitedDistrict,   //!<不限区
    cCustomDistrictPickerActionTypeUnLimitedStreet,     //!<不限街道
    cCustomDistrictPickerActionTypePickedCity,          //!<选择城市
    cCustomDistrictPickerActionTypePickedDistrict,      //!<选择区
    cCustomDistrictPickerActionTypePickedStreet         //!<选择街道

}CUSTOM_DISTRICT_PICKER_ACTION_TYPE;

@interface QSDistrictPickerView : UIView

/**
 *  @author                     yangshengmeng, 15-01-28 17:01:03
 *
 *  @brief                      根据给定的大小的位置，初始化一个地区选择view，同时只展现到给定的选择级别
 *
 *  @param frame               大小的位轩
 *  @param levelType           选择级别类型
 *  @param selectedCityKey     当前处于选择状态的城市key
 *  @param selectedDistrictKey 当前处于选择状态的区key
 *  @param selectedStreetKey   当前处于选择状态的街道key
 *  @param callBack            选择地点后的回调
 *
 *  @return                     返回当前创建的地区选择窗口对象
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDistrictPickerLevelType:(CUSTOM_DISTRICT_PICKER_LEVEL_TYPE)levelType andSelectedCityKey:(NSString *)selectedCityKey andSelectedDistrcitKey:(NSString *)selectedDistrictKey andSelectedStreetKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_DISTRICT_PICKER_LEVEL_TYPE pickerLevelType,CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,id pikeredInfo))callBack;

@end
