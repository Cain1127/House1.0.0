//
//  QSCustomDistrictSelectedPopView.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomDistrictSelectedPopView.h"
#import "QSDistrictPickerView.h"

#import "QSCDBaseConfigurationDataModel.h"
#import "QSBaseConfigurationDataModel.h"

@implementation QSCustomDistrictSelectedPopView

/**
 *  @author                     yangshengmeng, 15-02-03 14:02:48
 *
 *  @brief                      从下往上弹出一个地区选择窗口
 *
 *  @param selectedStreetKey    当前选择状态的街道
 *  @param callBack             选择后的回调
 *
 *  @return                     返回当前弹出框
 *
 *  @since                      1.0.0
 */
+ (instancetype)showCustomDistrictSelectedPopviewWithSteetSelectedKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))callBack
{

    ///弹出动画框
    __block QSCustomDistrictSelectedPopView *districtPopView = [[QSCustomDistrictSelectedPopView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    districtPopView.customPopviewTapCallBack = callBack;
    
    ///地区选择view
    QSDistrictPickerView *districtPickerView = [[QSDistrictPickerView alloc] initWithFrame:CGRectMake(0.0f, 84.0f, districtPopView.frame.size.width, districtPopView.frame.size.height - 84.0f) andSelectedStreetKey:selectedStreetKey andDistrictPickeredCallBack:^(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType, QSCDBaseConfigurationDataModel *distictModel, QSCDBaseConfigurationDataModel *streetModel) {
        
        ///选择一个街道
        if (cCustomDistrictPickerActionTypePickedStreet == pickedActionType) {
            
            ///重新构建模型
            QSBaseConfigurationDataModel *tempReturnModel = [[QSBaseConfigurationDataModel alloc] init];
            tempReturnModel.key = streetModel.key;
            tempReturnModel.val = [NSString stringWithFormat:@"%@ | %@",distictModel.val,streetModel.val];
            
            districtPopView.customPopviewTapCallBack(cCustomPopviewActionTypeSingleSelected,tempReturnModel,-1);
            
        } else {
            
            districtPopView.customPopviewTapCallBack(cCustomPopviewActionTypeCancel,streetModel,-1);
            
        }
        
        [districtPopView hiddenCustomDistrictSelectedPopview];
        
    }];
    
    ///将地区选择view加载到弹出框中
    [districtPopView addSubview:districtPickerView];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    ///显示
    if ([districtPopView respondsToSelector:@selector(showCustomPopview)]) {
        
        [districtPopView performSelector:@selector(showCustomPopview)];
        
    }
    
#pragma clang diagnostic pop
    
    return districtPopView;

}

#pragma mark - 移除单选弹出框
- (void)hiddenCustomDistrictSelectedPopview
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