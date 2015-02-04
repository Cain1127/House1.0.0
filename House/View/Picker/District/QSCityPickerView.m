//
//  QSCityPickerView.m
//  House
//
//  Created by ysmeng on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCityPickerView.h"
#import "QSCoreDataManager+App.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSCoreDataManager+User.h"

#import <objc/runtime.h>

///关联
static char HeaderViewKey;  //!<第一栏的view关联
static char SubViewKey;     //!<第二栏view的关联

@interface QSCityPickerView ()

///选择城市后的回调
@property (nonatomic,copy) void(^cityPickedCallBack)(CUSTOM_CITY_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *provincetModel,QSCDBaseConfigurationDataModel *cityModel);

///当前选择的城市模型
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentSelectedProvinceModel;
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentSelectedCityModel;

@end

@implementation QSCityPickerView

/**
 *  @author                     yangshengmeng, 15-02-03 10:02:08
 *
 *  @brief                      显示城市选择窗口
 *
 *  @param frame                大小和位置
 *  @param selectedProvinceKey  当前选择省的key
 *  @param selectedCityKey      当前选择城市的key
 *  @param callBack             选择后的回调
 *
 *  @return                     返回一个城市选择对象
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedCityKey:(NSString *)selectedCityKey andDistrictPickeredCallBack:(void(^)(CUSTOM_CITY_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *distictModel,QSCDBaseConfigurationDataModel *streetModel))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.cityPickedCallBack = callBack;
            
        }
        
        ///UI搭建
        [self createCityPickerUIWithCityKey:selectedCityKey];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createCityPickerUIWithCityKey:(NSString *)selectedCityKey
{
    
    ///获取对应省的key
    NSString *selectedProvinceKey = [QSCoreDataManager getCityProvinceWithCityKey:selectedCityKey];
    
    ///当前选择状态的省key
    __block NSString *currentSelectedCityKey;
    
    ///提示信息
    UILabel *tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT)];
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    tipsLabel.text = @"请选择城市";
    [self addSubview:tipsLabel];
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsLabel.frame.size.height - 0.5f, self.frame.size.width - SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 2.0f, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:sepLabel];
    
    ///省选择列
    UIScrollView *provincePickerRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, tipsLabel.frame.size.height + 10.0f, self.frame.size.width / 2.0f - 25.0f, self.frame.size.height - tipsLabel.frame.size.height - 84.0f - 20.0f)];
    currentSelectedCityKey = [self createProvinceSelectedItemUI:provincePickerRootView andSelectedProvinceKey:selectedProvinceKey];
    provincePickerRootView.backgroundColor = [UIColor clearColor];
    provincePickerRootView.showsHorizontalScrollIndicator = NO;
    provincePickerRootView.showsVerticalScrollIndicator = NO;
    [self addSubview:provincePickerRootView];
    objc_setAssociatedObject(self, &HeaderViewKey, provincePickerRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///城市选择列
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIScrollView *cityPickerRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f, provincePickerRootView.frame.origin.y, provincePickerRootView.frame.size.width, provincePickerRootView.frame.size.height)];
        [self createCitySelectedItemWithView:cityPickerRootView andProvinceKey:currentSelectedCityKey andSelectedCityKey:selectedCityKey];
        cityPickerRootView.backgroundColor = [UIColor clearColor];
        cityPickerRootView.showsHorizontalScrollIndicator = NO;
        cityPickerRootView.showsVerticalScrollIndicator = NO;
        [self addSubview:cityPickerRootView];
        objc_setAssociatedObject(self, &SubViewKey, cityPickerRootView, OBJC_ASSOCIATION_ASSIGN);
        
    });
    
    ///取消按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    buttonStyle.title = @"取消";
    CGFloat widthOfButton = (SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height - 69.0f, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.cityPickedCallBack) {
            
            self.cityPickedCallBack(cCustomCityPickerActionTypeUnLimitedProvince,nil,nil);
            
        }
        
    }];
    [self addSubview:cancelButton];
    
    ///确认按钮
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"确定";
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width / 2.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT / 2.0f, cancelButton.frame.origin.y, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.cityPickedCallBack) {
            
            self.cityPickedCallBack(cCustomCityPickerActionTypePickedCity,self.currentSelectedProvinceModel,self.currentSelectedCityModel);
            
        }
        
    }];
    [self addSubview:confirmButton];
    
    ///分隔线
    UILabel *buttonLineLable = [[UILabel alloc] initWithFrame:CGRectMake(cancelButton.frame.origin.x, confirmButton.frame.origin.y - 14.5f, self.frame.size.width  - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.5f)];
    buttonLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:buttonLineLable];
    
}

///创建省选择列
- (NSString *)createProvinceSelectedItemUI:(UIScrollView *)selectedRootView andSelectedProvinceKey:(NSString *)selectedKey
{
    
    ///当前选择状态的省key
    NSString *currentSelectedProvinceKey;
    
    ///获取省列表
    NSArray *provinceList = [QSCoreDataManager getProvinceList];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.titleFont = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_20 : FONT_BODY_16)];
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_YELLOW;
    
    ///循环创建选择项
    for (int i = 0; i < [provinceList count]; i++) {
        
        ///获取数据模型
        QSCDBaseConfigurationDataModel *tempModel = provinceList[i];
        
        ///标题
        buttonStyle.title = tempModel.val;
        buttonStyle.titleSelectedColor = COLOR_CHARACTERS_BLACK;
        buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
        
        ///选择项按钮
        UIButton *tempButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///判断当前点击的按钮是否处于选择状态
            if (button.selected) {
                
                return;
                
            }
            
            ///刷新城市数据
            UIScrollView *view = objc_getAssociatedObject(self, &SubViewKey);
            [self createCitySelectedItemWithView:view andProvinceKey:tempModel.key andSelectedCityKey:nil];
            
            ///保存当前选择的省
            self.currentSelectedProvinceModel = tempModel;
            
        }];
        
        ///标题右对齐
        tempButton.titleLabel.textAlignment = NSTextAlignmentRight;
        
        ///添加点击事件
        [tempButton addTarget:self action:@selector(provinceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ///添加到滚动框中
        [selectedRootView addSubview:tempButton];
        
        ///如果有对应的选择状态key，则让对应的城市处于选择状态
        if (selectedKey) {
            
            if ([selectedKey intValue] == [tempModel.key intValue]) {
                
                tempButton.selected = YES;
                
                ///保存当前选择的省
                self.currentSelectedProvinceModel = tempModel;
                
                ///判断是否需要滚动
                if (tempButton.frame.origin.y > selectedRootView.frame.size.height -20.0f) {
                    
                    selectedRootView.contentOffset = CGPointMake(0.0f, tempButton.frame.origin.y - 88.0f);
                    
                }
                
            }
            
            currentSelectedProvinceKey = selectedKey;
            
        } else if (0 == i) {
            
            tempButton.selected = YES;
            currentSelectedProvinceKey = tempModel.key;
            
            ///保存当前选择的省
            self.currentSelectedProvinceModel = tempModel;
            
        }
        
    }
    
    ///判断是否需要滚动
    if (VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [provinceList count] > selectedRootView.frame.size.height) {
        
        selectedRootView.contentSize = CGSizeMake(selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [provinceList count] + 10.0f);
        
    }
    
    return currentSelectedProvinceKey;
    
}

///在滚动视图中添加城市选择项
- (void)createCitySelectedItemWithView:(UIScrollView *)selectedRootView andProvinceKey:(NSString *)provinceKey andSelectedCityKey:(NSString *)selectedKey
{
    
    ///清空原选择项
    for (UIView *obj in [selectedRootView subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///按钮的风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.titleFont = [UIFont systemFontOfSize:(SIZE_DEVICE_WIDTH > 320.0f ? FONT_BODY_20 : FONT_BODY_16)];
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_YELLOW;
    
    ///获取城市列表
    NSArray *cityList = [QSCoreDataManager getCityListWithProvinceKey:provinceKey];

    ///循环创建选择项
    for (int i = 0; i < [cityList count]; i++) {
        
        ///获取数据模型
        QSCDBaseConfigurationDataModel *tempModel = cityList[i];
        
        ///标题
        buttonStyle.title = tempModel.val;
        
        ///选择项按钮
        UIButton *tempButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///已是选择状态的按钮，不再重复触发事件
            if (button.selected) {
                
                return;
                
            }
            
            ///修改当前选择的城市
            self.currentSelectedCityModel = tempModel;
            
        }];
        
        ///标题左对齐
        tempButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        ///添加单击事件，主要是用来修改按钮的状态
        [tempButton addTarget:self action:@selector(cityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ///添加到滚动框中
        [selectedRootView addSubview:tempButton];
        
        ///如果有对应的选择状态key，则让对应的城市处于选择状态
        if (selectedKey) {
            
            if ([selectedKey intValue] == [tempModel.key intValue]) {
                
                tempButton.selected = YES;
                
                ///保存为当前选择项
                self.currentSelectedCityModel = tempModel;
                
                ///判断是否需要滚动
                if (tempButton.frame.origin.y > selectedRootView.frame.size.height -20.0f) {
                    
                    selectedRootView.contentOffset = CGPointMake(0.0f, tempButton.frame.origin.y - 88.0f);
                    
                }
                
            }
            
        } else if (0 == i) {
            
            tempButton.selected = YES;
            ///保存为当前选择项
            self.currentSelectedCityModel = tempModel;
            
        }
        
    }
    
    ///判断是否需要滚动
    if (VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [cityList count] > selectedRootView.frame.size.height) {
        
        selectedRootView.contentSize = CGSizeMake(selectedRootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [cityList count] + 10.0f);
        
    }

}

#pragma mark - 省份选择框点击事件
/**
 *  @author         yangshengmeng, 15-02-03 12:02:02
 *
 *  @brief          省份按钮点击事件，主要是用来修改选择状态
 *
 *  @param button   当前点击的按钮
 *
 *  @since          1.0.0
 */
- (void)provinceButtonAction:(UIButton *)button
{

    if (button.selected) {
        
        return;
        
    }
    
    UIView *view = objc_getAssociatedObject(self, &HeaderViewKey);
    
    for (UIButton *obj in [view subviews]) {
        
        obj.selected = NO;
        
    }
    
    button.selected = YES;

}

#pragma mark - 城市选择按钮单击时修改选择状态
/**
 *  @author         yangshengmeng, 15-02-03 13:02:06
 *
 *  @brief          城市选择中，选择一个城市后，当前城市高亮，其他变为普通状态
 *
 *  @param button   当前点击的按钮
 *
 *  @since          1.0.0
 */
- (void)cityButtonAction:(UIButton *)button
{

    if (button.selected) {
        
        return;
        
    }
    
    UIView *view = objc_getAssociatedObject(self, &SubViewKey);
    
    for (UIButton *obj in [view subviews]) {
        
        obj.selected = NO;
        
    }
    
    button.selected = YES;

}

@end
