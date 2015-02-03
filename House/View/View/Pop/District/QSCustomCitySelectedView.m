//
//  QSCustomCitySelectedView.m
//  House
//
//  Created by ysmeng on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomCitySelectedView.h"

@implementation QSCustomCitySelectedView

/**
 *  @author                     yangshengmeng, 15-02-03 11:02:18
 *
 *  @brief                      弹出一个城市选择窗口
 *
 *  @param selectedProvinceKey  当前选择状态的省份
 *  @param selectedCityKey      当前选择状态的城市
 *  @param callBack             选择城市后的回调
 *
 *  @return                     返回当前的城市弹出框
 *
 *  @since                      1.0.0
 */
+ (instancetype)showCustomCitySelectedPopviewWithProvinceSelectedKey:(NSString *)selectedProvinceKey andSelectedCityKey:(NSString *)selectedCityKey andCityPickeredCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))callBack
{

    __block QSCustomCitySelectedView *cityPopView = [[QSCustomCitySelectedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///设置回调
    cityPopView.customPopviewTapCallBack = callBack;
    
    QSCityPickerView *cityPickerView = [[QSCityPickerView alloc] initWithFrame:CGRectMake(0.0f, 84.0f, cityPopView.frame.size.width, cityPopView.frame.size.height - 84.0f) andSelectedProvinceKey:selectedProvinceKey andSelectedCityKey:selectedCityKey andDistrictPickeredCallBack:^(CUSTOM_CITY_PICKER_ACTION_TYPE pickedActionType, QSCDBaseConfigurationDataModel *provincetModel, QSCDBaseConfigurationDataModel *cityModel) {
        
        ///选择一个城市
        if (cCustomCityPickerActionTypePickedCity == pickedActionType) {
            
            cityPopView.customPopviewTapCallBack(cCustomPopviewActionTypeSingleSelected,cityModel,-1);
            
        } else {
        
            cityPopView.customPopviewTapCallBack(cCustomPopviewActionTypeCancel,cityModel,-1);
        
        }
        
        [cityPopView hiddenCustomCitySelectedPopview];
        
    }];
    
    ///将地区选择view加载到弹出框中
    [cityPopView addSubview:cityPickerView];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    ///显示
    if ([cityPopView respondsToSelector:@selector(showCustomPopview)]) {
        
        [cityPopView performSelector:@selector(showCustomPopview)];
        
    }
    
#pragma clang diagnostic pop
    
    return cityPopView;

}

#pragma mark - 移除单选弹出框
- (void)hiddenCustomCitySelectedPopview
{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    ///回收
    if ([self respondsToSelector:@selector(hiddenCustomPopview)]) {
        
        [self performSelector:@selector(hiddenCustomPopview)];
        
    }
    
#pragma clang diagnostic pop
    
}

@end
