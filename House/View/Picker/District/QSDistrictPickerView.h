//
//  QSDistrictPickerView.h
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSDistrictListView.h"

/**
 *  @brief  地区选择窗口
 */
@class QSBaseConfigurationDataModel;
@interface QSDistrictPickerView : UIView

/**
 *  @author                     yangshengmeng, 15-01-28 17:01:03
 *
 *  @brief                      根据给定的大小的位置，初始化一个地区选择view，同时只展现到给定的选择级别
 *
 *  @param frame                大小位置
 *  @param selectedDistrictKey  当前处于选择状态的区key
 *  @param selectedStreetKey    当前处于选择状态的街道key
 *  @param callBack             选择地点后的回调
 *
 *  @return                     返回当前创建的地区选择窗口对象
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedStreetKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSBaseConfigurationDataModel *distictModel,QSBaseConfigurationDataModel *streetModel))callBack;

@end
