//
//  QSCustomCitySelectedView.m
//  House
//
//  Created by ysmeng on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomCitySelectedView.h"
#import "QSCityPickerView.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSCoreDataManager+App.h"
#import "QSRequestManager.h"
#import "QSBaseConfigurationReturnData.h"

@implementation QSCustomCitySelectedView

#pragma mark - 弹出城市选择窗口
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
+ (instancetype)showCustomCitySelectedPopviewWithCitySelectedKey:(NSString *)selectedCityKey andCityPickeredCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))callBack
{

    __block QSCustomCitySelectedView *cityPopView = [[QSCustomCitySelectedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///设置回调
    cityPopView.customPopviewTapCallBack = callBack;
    
    QSCityPickerView *cityPickerView = [[QSCityPickerView alloc] initWithFrame:CGRectMake(0.0f, 84.0f, cityPopView.frame.size.width, cityPopView.frame.size.height - 84.0f) andSelectedCityKey:selectedCityKey andDistrictPickeredCallBack:^(CUSTOM_CITY_PICKER_ACTION_TYPE pickedActionType, QSCDBaseConfigurationDataModel *provincetModel, QSCDBaseConfigurationDataModel *cityModel) {
        
        ///选择一个城市
        if (cCustomCityPickerActionTypePickedCity == pickedActionType) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
               
                ///下载对应城市的区和街道信息
                [cityPopView downloadDistrictInfoWithCityKey:[NSString stringWithFormat:@"%@",cityModel.key]];
                
            });
            
            ///回调
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

#pragma mark - 下载给定城市的区和街道信息
///下载给定城市的区和街道信息
- (void)downloadDistrictInfoWithCityKey:(NSString *)cityKey
{

    ///先查找原来是否已有街道信息
    NSArray *districtList = [QSCoreDataManager getDistrictListWithCityKey:cityKey];
    if ([districtList count] > 0) {
        
        return;
        
    }
    
    /**
     *  @brief  原来没有区信息，则下载
     */
    
    ///请求参数
    NSDictionary *districtRequestParams = @{@"conf" : @"AREA",
                                            @"parent" : cityKey};
    
    [QSRequestManager requestDataWithType:rRequestTypeAppBaseInfoConfiguration andParams:districtRequestParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换
            QSBaseConfigurationReturnData *dataModel = resultData;
            
            ///将对应的区信息插入配置库中
            [QSCoreDataManager updateBaseConfigurationList:dataModel.baseConfigurationHeaderData.baseConfigurationList andKey:[NSString stringWithFormat:@"district%@",cityKey]];
            
            ///下载对应区的街道信息
            for (int i = 0; i < [dataModel.baseConfigurationHeaderData.baseConfigurationList count]; i++) {
                
                ///获取模型
                QSBaseConfigurationDataModel *tempDistrictModel = dataModel.baseConfigurationHeaderData.baseConfigurationList[i];
                [self downloadStreetInfoWithStreetKey:tempDistrictModel.key];
                
            }
            
        } else {
            
            NSLog(@"==================请求城市区信息失败=======================");
            NSLog(@"当前配置信息项为：conf : %@,error : %@",cityKey,errorInfo);
            NSLog(@"==================请求城市区信息失败=======================");
            
        }
        
    }];
    
}

#pragma mark - 下载对应区的街道信息
///下载对应街道信息
- (void)downloadStreetInfoWithStreetKey:(NSString *)districtKey
{
    
    ///请求参数
    NSDictionary *streetRequestParams = @{@"conf" : @"STREET",
                                            @"parent" : districtKey};

    ///下载对应区的街道信息
    [QSRequestManager requestDataWithType:rRequestTypeAppBaseInfoConfiguration andParams:streetRequestParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///模型转换
            QSBaseConfigurationReturnData *dataModel = resultData;
            
            ///将对应的街道信息插入配置库中
            [QSCoreDataManager updateBaseConfigurationList:dataModel.baseConfigurationHeaderData.baseConfigurationList andKey:[NSString stringWithFormat:@"street%@",districtKey]];
            
        } else {
            
            NSLog(@"==================请求街道信息失败=======================");
            NSLog(@"当前配置信息项为：conf : %@,error : %@",districtKey,errorInfo);
            NSLog(@"==================请求街道信息失败=======================");
            
        }
        
    }];

}

#pragma mark - 移除单选弹出框
///移除城市选择窗口
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
