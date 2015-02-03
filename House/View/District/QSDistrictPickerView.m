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

#import <objc/runtime.h>

///关联
static char StreetRootViewKey;              //!<街道信息底view
static char DistrictSelectedItemRootViewKey;//!<区选择列的底view
static char StreetSelectedItemRootViewKey;  //!<区选择列的底view

@interface QSDistrictPickerView ()

///选择地区完成后的回调
@property (nonatomic,copy) void(^districtPickeredCallBack)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *districtModel,QSCDBaseConfigurationDataModel *streetModel);

@property (nonatomic,assign) BOOL isUnLimited;                                          //!<当前是否是不限
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentSelectedDistrict;   //!<当前选择的区
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentSelectedStreet;     //!<当前选择的街道

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
- (instancetype)initWithFrame:(CGRect)frame andSelectedStreetKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *distictModel,QSCDBaseConfigurationDataModel *streetModel))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///初始化时，表示不限
        self.isUnLimited = selectedStreetKey ? NO : YES;
        
        ///保存回调
        if (callBack) {
            
            self.districtPickeredCallBack = callBack;
            
        }
        
        ///UI搭建
        [self createDistrictPickerUIWithSelectedStreetKey:selectedStreetKey];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createDistrictPickerUIWithSelectedStreetKey:(NSString *)selectedStreetKey
{
    
    ///选择状态的区
    NSString *selectedDistrictKey = nil;
    selectedDistrictKey = [QSCoreDataManager getDistrictKeyWithStreetKey:selectedStreetKey];
    
    ///当前选择状态的城市key
    __block NSString *currentSelectedDistrictKey;
    
    ///区选择列
    UIView *districtPickerRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width / 2.0f - 25.0f, self.frame.size.height - 84.0f)];
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
    
    ///取消按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    buttonStyle.title = @"取消";
    CGFloat widthOfButton = (SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height - 69.0f, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.districtPickeredCallBack) {
            
            self.districtPickeredCallBack(cCustomDistrictPickerActionTypeUnLimitedDistrict,nil,nil);
            
        }
        
    }];
    [self addSubview:cancelButton];
    
    ///确认按钮
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"确定";
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width / 2.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT / 2.0f, cancelButton.frame.origin.y, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.districtPickeredCallBack) {
            
            ///判断是否不限
            if (self.isUnLimited) {
                
                self.districtPickeredCallBack(cCustomDistrictPickerActionTypeUnLimitedDistrict,nil,nil);
                
            } else {
            
                self.districtPickeredCallBack(cCustomDistrictPickerActionTypePickedStreet,self.currentSelectedDistrict,self.currentSelectedStreet);
            
            }
            
        }
        
    }];
    [self addSubview:confirmButton];
    
    ///分隔线
    UILabel *buttonLineLable = [[UILabel alloc] initWithFrame:CGRectMake(cancelButton.frame.origin.x, confirmButton.frame.origin.y - 14.5f, self.frame.size.width  - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.5f)];
    buttonLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:buttonLineLable];

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
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_BLACK;
    buttonStyle.bgColorSelected = COLOR_CHARACTERS_YELLOW;
    __block UIButton *unlimitedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///如若当前已是选择状态，则不再重复处理
        if (button.selected) {
            
            return;
            
        }
        
        ///将当前的不限按钮置于选择状态
        button.selected = YES;
        
        ///把当前状态修改为不限状态
        self.isUnLimited = YES;
        
        ///将区选择列的选择状态取消
        UIView *districtRootView = objc_getAssociatedObject(self, &DistrictSelectedItemRootViewKey);
        [self changeSelectedItemStatus:NO andSelectedRootView:districtRootView];
        
        ///重置街道选择列
        UIView *streetRootView = objc_getAssociatedObject(self, &StreetRootViewKey);
        [self createStreetSelectedItemUI:streetRootView andDistrictKey:nil andSelectedStreetKey:nil];
        
    }];
    unlimitedButton.selected = YES;
    [view addSubview:unlimitedButton];
    
    ///获取区列表
    NSArray *districtList = [QSCoreDataManager getDistrictListWithCityKey:[QSCoreDataManager getCurrentUserCityKey]];
    
    ///选择项的底view
    UIScrollView *selectedRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, unlimitedButton.frame.size.height, view.frame.size.width, view.frame.size.height - unlimitedButton.frame.size.height - 15.0f)];
    selectedRootView.showsHorizontalScrollIndicator = NO;
    selectedRootView.showsVerticalScrollIndicator = NO;
    [view addSubview:selectedRootView];
    objc_setAssociatedObject(self, &DistrictSelectedItemRootViewKey, selectedRootView, OBJC_ASSOCIATION_ASSIGN);
    
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
            
            ///将选择状态置为非不限
            self.isUnLimited = NO;
            
            ///保存当前的选择项
            self.currentSelectedDistrict = tempModel;
            
            ///重置街道选择列
            UIView *streetRootView = objc_getAssociatedObject(self, &StreetRootViewKey);
            [self createStreetSelectedItemUI:streetRootView andDistrictKey:[NSString stringWithFormat:@"%@",tempModel.key] andSelectedStreetKey:nil];
            
        }];
        
        ///添加单击事件，主要是更换选择状态
        [tempButton addTarget:self action:@selector(districtSelctedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ///添加到滚动框中
        [selectedRootView addSubview:tempButton];
        
        ///如果有对应的选择状态key，则让对应的城市处于选择状态
        if (selectedKey) {
            
            if ([selectedKey intValue] == [tempModel.key intValue]) {
                
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
        
        ///如若当前已是选择状态，则不再重复处理
        if (button.selected) {
            
            return;
            
        }
        
        ///将当前的不限按钮置于选择状态
        button.selected = YES;
        
        ///把当前状态修改为不限状态
        self.isUnLimited = YES;
        
        ///将区选择列的选择状态取消
        UIView *districtRootView = objc_getAssociatedObject(self, &StreetSelectedItemRootViewKey);
        [self changeSelectedItemStatus:NO andSelectedRootView:districtRootView];
        
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
            self.isUnLimited = NO;
            unlimitedButton.selected = NO;
            
            ///保存当前选择的模型
            self.currentSelectedStreet = tempModel;
            
        }];
        
        ///添加单击事件，切换选择状态
        [tempButton addTarget:self action:@selector(streetSelectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ///添加到滚动框中
        [selectedRootView addSubview:tempButton];
        
        ///如果有对应的选择状态key，则让对应的城市处于选择状态
        if (selectedKey) {
            
            if ([selectedKey intValue] == [tempModel.key intValue]) {
                
                tempButton.selected = YES;
                
                ///保存当前街道信息
                self.currentSelectedStreet = tempModel;
                
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

@end
