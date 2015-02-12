//
//  QSDistrictListView.m
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDistrictListView.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "QSCDBaseConfigurationDataModel.h"
#import "QSBaseConfigurationReturnData.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"

#import "QSRequestManager.h"

#import <objc/runtime.h>

///关联
static char DistrictSelectedItemRootViewKey;//!<地区选项的底view
static char StreetSelectedItemRootViewKey;  //!<街道选择项底view
static char StreetRootViewKey;              //!<街道的底view

@interface QSDistrictListView ()

///选择地区后的回调
@property (nonatomic,copy) void(^districtPickedCallBack)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *distictModel,QSCDBaseConfigurationDataModel *streetModel);

///当前选择区
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentSelectedDistrict;

@end

@implementation QSDistrictListView

#pragma mark - 初始化
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
- (instancetype)initWithFrame:(CGRect)frame andSelectedStreetKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *distictModel,QSCDBaseConfigurationDataModel *streetModel))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.districtPickedCallBack = callBack;
            
        }
        
        ///UI创建
        [self createDistrictSelectedUIWithSelectedStreetKey:selectedStreetKey];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///创建地区选择列表
- (void)createDistrictSelectedUIWithSelectedStreetKey:(NSString *)selectedStreetKey
{

    ///选择状态的区
    NSString *selectedDistrictKey = nil;
    selectedDistrictKey = [QSCoreDataManager getDistrictKeyWithStreetKey:selectedStreetKey];
    
    ///当前选择状态的城市key
    __block NSString *currentSelectedDistrictKey;
    
    ///区选择列
    UIView *districtPickerRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width / 2.0f - 25.0f, self.frame.size.height)];
    currentSelectedDistrictKey = [self createDistrictSelectedItemUI:districtPickerRootView andSelectedDistrictKey:selectedDistrictKey];
    districtPickerRootView.backgroundColor = [UIColor clearColor];
    [self addSubview:districtPickerRootView];
    
    ///街道选择列
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIView *streetPickerRootView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f, 0.0f, districtPickerRootView.frame.size.width, districtPickerRootView.frame.size.height)];
        [self createStreetSelectedItemUI:streetPickerRootView andDistrictKey:currentSelectedDistrictKey andSelectedStreetKey:selectedStreetKey];
        streetPickerRootView.backgroundColor = [UIColor clearColor];
        [self addSubview:streetPickerRootView];
        objc_setAssociatedObject(self, &StreetRootViewKey, streetPickerRootView, OBJC_ASSOCIATION_ASSIGN);
        
    });

}

///创建区选择列
- (NSString *)createDistrictSelectedItemUI:(UIView *)view andSelectedDistrictKey:(NSString *)selectedKey
{
    
    ///不限按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.title = @"不限";
    buttonStyle.titleFont = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_20 : FONT_BODY_16)];
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_YELLOW;
    __block UIButton *unlimitedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///如若当前已是选择状态，则不再重复处理
        if (button.selected) {
            
            return;
            
        }
        
        ///将当前的不限按钮置于选择状态
        button.selected = YES;
        
        ///将区选择列的选择状态取消
        UIView *districtRootView = objc_getAssociatedObject(self, &DistrictSelectedItemRootViewKey);
        [self changeSelectedItemStatus:NO andSelectedRootView:districtRootView];
        
        ///回调
        if (self.districtPickedCallBack) {
            
            self.districtPickedCallBack(cCustomDistrictPickerActionTypeUnLimitedDistrict,nil,nil);
            
        }
        
        ///重置街道选择列
        UIView *streetRootView = objc_getAssociatedObject(self, &StreetRootViewKey);
        [self createStreetSelectedItemUI:streetRootView andDistrictKey:nil andSelectedStreetKey:nil];
        
    }];
    unlimitedButton.selected = YES;
    [view addSubview:unlimitedButton];
    
    ///城市
    NSString *cityKey = [QSCoreDataManager getCurrentUserCityKey];
    
    ///获取区列表
    __block NSArray *districtList = [QSCoreDataManager getDistrictListWithCityKey:cityKey];
    
    ///判断区是否有数据
    if ([districtList count] <= 0) {
        
        [self downloadDistrictInfoWithCityKey:cityKey andCallBack:^(BOOL isSuccess) {
            
            districtList = [QSCoreDataManager getDistrictListWithCityKey:cityKey];
            
        }];
        
    }
    
    ///选择项的底view
    UIScrollView *selectedRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, unlimitedButton.frame.size.height, view.frame.size.width, view.frame.size.height - unlimitedButton.frame.size.height - 15.0f)];
    selectedRootView.showsHorizontalScrollIndicator = NO;
    selectedRootView.showsVerticalScrollIndicator = NO;
    [view addSubview:selectedRootView];
    objc_setAssociatedObject(self, &DistrictSelectedItemRootViewKey, selectedRootView, OBJC_ASSOCIATION_ASSIGN);
    
    return [self createDistrictSelectedItemUI:selectedRootView andDataSource:districtList andSelectedKey:selectedKey andUnLimitedButton:unlimitedButton];
    
}

- (NSString *)createDistrictSelectedItemUI:(UIScrollView *)selectedRootView andDataSource:(NSArray *)districtList andSelectedKey:(NSString *)selectedKey andUnLimitedButton:(UIButton *)unlimitedButton
{
    
    ///当前选择状态的区
    NSString *currentSelectedDistrictKey;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.titleFont = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_20 : FONT_BODY_16)];
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_YELLOW;

    ///循环创建选择项
    for (int i = 0; i < [districtList count]; i++) {
        
        ///获取数据模型
        QSCDBaseConfigurationDataModel *tempModel = districtList[i];
        
        ///标题
        buttonStyle.title = tempModel.val;
        
        ///选择项按钮
        UIButton *tempButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///如果按钮当前处于选择状态，则不再操作
            if (button.selected) {
                
                return;
                
            }
            
            ///将不限按钮置为非选择状态
            unlimitedButton.selected = NO;
            
            ///重置街道选择列
            UIView *streetRootView = objc_getAssociatedObject(self, &StreetRootViewKey);
            [self createStreetSelectedItemUI:streetRootView andDistrictKey:tempModel.key andSelectedStreetKey:nil];
            
            ///保存当前选择的区
            self.currentSelectedDistrict = tempModel;
            
        }];
        
        ///添加单击事件，主要是更换选择状态
        [tempButton addTarget:self action:@selector(districtSelctedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ///添加到滚动框中
        [selectedRootView addSubview:tempButton];
        
        ///如果有对应的选择状态key，则让对应的城市处于选择状态
        if (selectedKey) {
            
            if ([selectedKey isEqualToString:tempModel.key]) {
                
                tempButton.selected = YES;
                
                ///保存当前选择项
                self.currentSelectedDistrict = tempModel;
                
                unlimitedButton.selected = NO;
                
                ///判断是否需要滚动
                if (tempButton.frame.origin.y > selectedRootView.frame.size.height -20.0f) {
                    
                    selectedRootView.contentOffset = CGPointMake(0.0f, tempButton.frame.origin.y - 88.0f);
                    
                }
                
            }
            
            currentSelectedDistrictKey = selectedKey;
            
        }
        
    }
    
    ///判断是否需要滚动
    if (VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [districtList count] > selectedRootView.frame.size.height) {
        
        selectedRootView.contentSize = CGSizeMake(selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [districtList count] + 10.0f);
        
    }
    
    return currentSelectedDistrictKey;

}

///创建街道选择列
- (void)createStreetSelectedItemUI:(UIView *)view andDistrictKey:(NSString *)districtKey andSelectedStreetKey:(NSString *)selectedKey
{
    
    ///清空原信息
    for (UIView *obj in [view subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///如果当前没有选择的区，则不创建街道选择
    if (!districtKey) {
        
        return;
        
    }
    
    ///获取街道列表
    NSArray *streetList = [QSCoreDataManager getStreetListWithDistrictKey:districtKey];
    
    ///如果没有街道信息，则不创建街道UI
    if (nil == streetList || 0 >= [streetList count]) {
        
        return;
        
    }
    
    ///不限按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.title = @"不限";
    buttonStyle.titleFont = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_20 : FONT_BODY_16)];
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_YELLOW;
    __block UIButton *unlimitedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///设置选择状态
        button.selected = YES;
        
        ///将区选择列的选择状态取消
        UIView *districtRootView = objc_getAssociatedObject(self, &StreetSelectedItemRootViewKey);
        [self changeSelectedItemStatus:NO andSelectedRootView:districtRootView];
        
        ///回调
        if (self.districtPickedCallBack) {
            
            self.districtPickedCallBack(cCustomDistrictPickerActionTypeUnLimitedDistrict,nil,nil);
            
        }
        
    }];
    unlimitedButton.selected = YES;
    [view addSubview:unlimitedButton];
    
    ///选择项的底view
    UIScrollView *selectedRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, unlimitedButton.frame.size.height, view.frame.size.width, view.frame.size.height - unlimitedButton.frame.size.height - 15.0f)];
    selectedRootView.showsHorizontalScrollIndicator = NO;
    selectedRootView.showsVerticalScrollIndicator = NO;
    [view addSubview:selectedRootView];
    objc_setAssociatedObject(self, &StreetSelectedItemRootViewKey, selectedRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///循环创建选择项
    for (int i = 0; i < [streetList count]; i++) {
        
        ///获取数据模型
        QSCDBaseConfigurationDataModel *tempModel = streetList[i];
        
        ///标题
        buttonStyle.title = tempModel.val;
        
        ///选择项按钮
        UIButton *tempButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///判断当前是否处于选择状态
            if (button.selected) {
                
                return;
                
            }
            
            ///修改状态
            unlimitedButton.selected = NO;
            
            ///回调
            if (self.districtPickedCallBack) {
                
                self.districtPickedCallBack(cCustomDistrictPickerActionTypePickedStreet,self.currentSelectedDistrict,tempModel);
                
            }
            
        }];
        
        ///添加单击事件，切换选择状态
        [tempButton addTarget:self action:@selector(streetSelectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ///添加到滚动框中
        [selectedRootView addSubview:tempButton];
        
        ///如果有对应的选择状态key，则让对应的城市处于选择状态
        if (selectedKey) {
            
            if ([selectedKey intValue] == [tempModel.key intValue]) {
                
                tempButton.selected = YES;
                
                unlimitedButton.selected = NO;
                
                ///判断是否需要滚动
                if (tempButton.frame.origin.y > selectedRootView.frame.size.height -20.0f) {
                    
                    selectedRootView.contentOffset = CGPointMake(0.0f, tempButton.frame.origin.y - 88.0f);
                    
                }
                
            }
            
        }
        
    }
    
    ///判断是否需要滚动
    if (VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [streetList count] > selectedRootView.frame.size.height) {
        
        selectedRootView.contentSize = CGSizeMake(selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [streetList count] + 10.0f);
        
    }
    
}

#pragma mark - 将给定视图上的按钮置为指定的状态
/**
 *  @author     yangshengmeng, 15-02-03 16:02:35
 *
 *  @brief      将指定选择项上的所有选择项状态重置
 *
 *  @param flag 给定的状态
 *  @param view 选择项所在的父view
 *
 *  @since      1.0.0
 */
- (void)changeSelectedItemStatus:(BOOL)flag andSelectedRootView:(UIView *)view
{
    
    if (!view) {
        
        return;
        
    }
    
    for (UIButton *obj in [view subviews]) {
        
        obj.selected = flag;
        
    }
    
}

#pragma mark - 地区选择时的按钮事件
///地区选择时点击的事件，主要是切换选择状态
- (void)districtSelctedButtonAction:(UIButton *)button
{
    
    ///判断当前按钮是否处于选择状态
    if (button.selected) {
        
        return;
        
    }
    
    UIView *distrcitRootView = objc_getAssociatedObject(self, &DistrictSelectedItemRootViewKey);
    for (UIButton *obj in [distrcitRootView subviews]) {
        
        obj.selected = NO;
        
    }
    
    button.selected = YES;
    
}

- (void)streetSelectedButtonAction:(UIButton *)button
{
    
    ///判断当前按钮是否处于选择状态
    if (button.selected) {
        
        return;
        
    }
    
    UIView *distrcitRootView = objc_getAssociatedObject(self, &StreetSelectedItemRootViewKey);
    for (UIButton *obj in [distrcitRootView subviews]) {
        
        obj.selected = NO;
        
    }
    
    button.selected = YES;
    
}

#pragma mark - 下载给定城市的区和街道信息
///下载给定城市的区和街道信息
- (void)downloadDistrictInfoWithCityKey:(NSString *)cityKey andCallBack:(void(^)(BOOL isSuccess))callBack
{
    
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
                
                ///判断是否最后一个
                if (i < [dataModel.baseConfigurationHeaderData.baseConfigurationList count] - 1) {
                    
                    [self downloadStreetInfoWithStreetKey:tempDistrictModel.key andFinishCallBack:nil];
                    
                } else {
                    
                    [self downloadStreetInfoWithStreetKey:tempDistrictModel.key andFinishCallBack:callBack];
                    
                }
                
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
- (void)downloadStreetInfoWithStreetKey:(NSString *)districtKey andFinishCallBack:(void(^)(BOOL isSuccess))callBack
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
            
            ///回调
            if (callBack) {
                
                callBack(YES);
                
            }
            
        } else {
            
            NSLog(@"==================请求街道信息失败=======================");
            NSLog(@"当前配置信息项为：conf : %@,error : %@",districtKey,errorInfo);
            NSLog(@"==================请求街道信息失败=======================");
            
        }
        
    }];
    
}

@end
