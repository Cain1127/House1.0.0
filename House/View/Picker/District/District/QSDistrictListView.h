//
//  QSDistrictListView.h
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///回调事件的类型
typedef enum
{
    
    cCustomDistrictPickerActionTypeUnLimitedDistrict,   //!<不限区
    cCustomDistrictPickerActionTypeUnLimitedStreet,     //!<不限街道
    cCustomDistrictPickerActionTypePickedDistrict,      //!<选择区
    cCustomDistrictPickerActionTypePickedStreet         //!<选择街道
    
}CUSTOM_DISTRICT_PICKER_ACTION_TYPE;                    //!<选择地区后的回调类型

/**
 *  @author yangshengmeng, 15-02-04 11:02:16
 *
 *  @brief  地区列表
 *
 *  @since  1.0.0
 */
@class QSCDBaseConfigurationDataModel;
@interface QSDistrictListView : UIView

/**
 *  @author                     yangshengmeng, 15-02-04 11:02:10
 *
 *  @brief                      创建地区选择的列表
 *
 *  @param frame                大小和位置
 *  @param selectedStreetKey    当前选择状态的街道key
 *  @param callBack             选择后的回调
 *
 *  @return                     返回地区选择view
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedStreetKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *distictModel,QSCDBaseConfigurationDataModel *streetModel))callBack;

@end
