//
//  QSDistrictPickerView.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDistrictPickerView.h"
#import "QSCoreDataManager+App.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSCoreDataManager+User.h"

@interface QSDistrictPickerView ()

///选择地区完成后的回调
@property (nonatomic,copy) void(^districtPickeredCallBack)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *districtModel,QSCDBaseConfigurationDataModel *streetModel);

@property (nonatomic,assign) int citySelectedIndex;//!<当前选择状态的城市下标

@end

@implementation QSDistrictPickerView

#pragma mark - 初始化
/**
 *  @author                     yangshengmeng, 15-01-28 17:01:03
 *
 *  @brief                      根据给定的大小的位置，初始化一个地区选择view，同时只展现到给定的选择级别
 *
 *  @param frame               大小位置
 *  @param selectedDistrictKey 当前处于选择状态的区key
 *  @param selectedStreetKey   当前处于选择状态的街道key
 *  @param callBack            选择地点后的回调
 *
 *  @return                     返回当前创建的地区选择窗口对象
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedDistrcitKey:(NSString *)selectedDistrictKey andSelectedStreetKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *distictModel,QSCDBaseConfigurationDataModel *streetModel))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.districtPickeredCallBack = callBack;
            
        }
        
        ///UI搭建
        [self createDistrictPickerUI:selectedDistrictKey andSelectedStreetKey:selectedStreetKey];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createDistrictPickerUI:(NSString *)selectedDistrictKey andSelectedStreetKey:(NSString *)selectedStreetKey
{
    
    ///当前选择状态的城市key
    __block NSString *currentSelectedDistrictKey;
    
    ///区选择列
    
    UIView *districtPickerRootView = [[UIView alloc] initWithFrame:CGRectMake(25.0f, 0.0f, (self.frame.size.width - 80.0f) / 3.0f, self.frame.size.height)];
    currentSelectedDistrictKey = [self createDistrictSelectedItemUI:districtPickerRootView andSelectedDistrictKey:selectedDistrictKey];
    districtPickerRootView.backgroundColor = [UIColor clearColor];
    [self addSubview:districtPickerRootView];
    
    ///街道选择列
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIView *streetPickerRootView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20.0f - (self.frame.size.width - 70.0f) / 3.0f, 0.0f, (self.frame.size.width - 70.0f) / 3.0f, self.frame.size.height)];
        [self createStreetSelectedItemUI:streetPickerRootView andDistrictKey:currentSelectedDistrictKey andSelectedStreetKey:selectedStreetKey];
        streetPickerRootView.backgroundColor = [UIColor clearColor];
        [self addSubview:streetPickerRootView];
        
    });

}

///创建区选择列
- (NSString *)createDistrictSelectedItemUI:(UIView *)view andSelectedDistrictKey:(NSString *)selectedKey
{

    ///当前选择状态的区
    NSString *currentSelectedDistrictKey;
    
    ///不限按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.title = @"不限";
    buttonStyle.titleFont = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_20 : FONT_BODY_16)];
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_YELLOW;
    UIButton *unlimitedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.districtPickeredCallBack) {
            
            self.districtPickeredCallBack(cCustomDistrictPickerActionTypeUnLimitedDistrict,nil,nil);
            
        }
        
    }];
    [view addSubview:unlimitedButton];
    
    ///获取区列表
    NSArray *districtList = [QSCoreDataManager getDistrictListWithCityKey:[QSCoreDataManager getCurrentUserCityKey]];
    
    ///选择项的底view
    UIScrollView *selectedRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, unlimitedButton.frame.size.height, view.frame.size.width, view.frame.size.height - unlimitedButton.frame.size.height - 15.0f)];
    selectedRootView.showsHorizontalScrollIndicator = NO;
    selectedRootView.showsVerticalScrollIndicator = NO;
    [view addSubview:selectedRootView];
    
    ///循环创建选择项
    for (int i = 0; i < [districtList count]; i++) {
        
        ///获取数据模型
        QSCDBaseConfigurationDataModel *tempModel = districtList[i];
        
        ///标题
        buttonStyle.title = tempModel.val;
        
        ///选择项按钮
        UIButton *tempButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            
            
        }];
        
        ///添加到滚动框中
        [selectedRootView addSubview:tempButton];
        
        ///如果有对应的选择状态key，则让对应的城市处于选择状态
        if (selectedKey) {
            
            if ([selectedKey intValue] == [tempModel.key intValue]) {
                
                tempButton.selected = YES;
                
                ///判断是否需要滚动
                if (tempButton.frame.origin.y > selectedRootView.frame.size.height -20.0f) {
                    
                    selectedRootView.contentOffset = CGPointMake(0.0f, tempButton.frame.origin.y - 88.0f);
                    
                }
                
            }
            
            currentSelectedDistrictKey = selectedKey;
            
        } else if (0 == i) {
            
            tempButton.selected = YES;
            currentSelectedDistrictKey = [tempModel.key stringValue];
            
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

    ///不限按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.title = @"不限";
    buttonStyle.titleFont = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_20 : FONT_BODY_16)];
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_YELLOW;
    UIButton *unlimitedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.districtPickeredCallBack) {
            
            self.districtPickeredCallBack(cCustomDistrictPickerActionTypeUnLimitedStreet,nil,nil);
            
        }
        
    }];
    [view addSubview:unlimitedButton];
    
    ///获取街道列表
    NSArray *streetList = [QSCoreDataManager getStreetListWithDistrictKey:districtKey];
    
    ///选择项的底view
    UIScrollView *selectedRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, unlimitedButton.frame.size.height, view.frame.size.width, view.frame.size.height - unlimitedButton.frame.size.height - 15.0f)];
    selectedRootView.showsHorizontalScrollIndicator = NO;
    selectedRootView.showsVerticalScrollIndicator = NO;
    [view addSubview:selectedRootView];
    
    ///循环创建选择项
    for (int i = 0; i < [streetList count]; i++) {
        
        ///获取数据模型
        QSCDBaseConfigurationDataModel *tempModel = streetList[i];
        
        ///标题
        buttonStyle.title = tempModel.val;
        
        ///选择项按钮
        UIButton *tempButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            
            
        }];
        
        ///添加到滚动框中
        [selectedRootView addSubview:tempButton];
        
        ///如果有对应的选择状态key，则让对应的城市处于选择状态
        if (selectedKey) {
            
            if ([selectedKey intValue] == [tempModel.key intValue]) {
                
                tempButton.selected = YES;
                
                ///判断是否需要滚动
                if (tempButton.frame.origin.y > selectedRootView.frame.size.height -20.0f) {
                    
                    selectedRootView.contentOffset = CGPointMake(0.0f, tempButton.frame.origin.y - 88.0f);
                    
                }
                
            }
            
        } else if (0 == i) {
            
            tempButton.selected = YES;
            
        }
        
    }
    
    ///判断是否需要滚动
    if (VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [streetList count] > selectedRootView.frame.size.height) {
        
        selectedRootView.contentSize = CGSizeMake(selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [streetList count] + 10.0f);
        
    }

}

@end
