//
//  QSCustomDistrictSelectedPopView.h
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPopRootView.h"
#import "QSDistrictPickerView.h"

@interface QSCustomDistrictSelectedPopView : QSCustomPopRootView

/**
 *  @author yangshengmeng, 15-01-28 17:01:09
 *
 *  @brief                      弹出一个地区选择窗口
 *
 *  @param frame                大小和位置
 *  @param levelType            地区选择的级别类型：城市、区、街道
 *  @param selectedCityKey      当前处于选择状态的城市key
 *  @param selectedDistrictKey  当前处于选择状态的区key
 *  @param selectedStreetKey    当前处于选择状态的街道key
 *  @param callBack             选择后的回调
 *
 *  @return                     返回当前弹框对象
 *
 *  @since                      1.0.0
 */
+ (instancetype)showCustomDistrictSelectedPopviewWithDistrictPickerLevelType:(CUSTOM_DISTRICT_PICKER_LEVEL_TYPE)levelType andSelectedCityKey:(NSString *)selectedCityKey andSelectedDistrcitKey:(NSString *)selectedDistrictKey andSelectedStreetKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_DISTRICT_PICKER_LEVEL_TYPE pickerLevelType,CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,id pikeredInfo))callBack;

@end
