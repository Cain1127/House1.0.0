//
//  QSNavigationBarPickerView.m
//  House
//
//  Created by ysmeng on 15/1/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNavigationBarPickerView.h"
#import "QSCoreDataManager+User.h"
#import "QSCustomSingleSelectedPopView.h"
#import "QSCoreDataManager+App.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSCoreDataManager+House.h"

#import <objc/runtime.h>

///关联
static char CityInfoLabelKey;//!<显示信息labelKey
static char LeftArrowViewKey;//!<左侧箭头

@interface QSNavigationBarPickerView ()

///选择完成后的回调
@property (nonatomic,copy) void(^pickedCallBack)(NSString *pickedKey,NSString *pickedVal);
@property (nonatomic,assign) NAVIGATIONBAR_PICKER_TYPE pickerType;      //!<选择器类型
@property (nonatomic,assign) NAVIGATIONBAR_PICKER_STYLE pickerStyle;    //!<城市选择风格
@property (nonatomic,assign) BOOL isPicking;                            //!<选择view的状态
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentCity; //!<当前选择项模型

@end

@implementation QSNavigationBarPickerView

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-01-29 14:01:47
 *
 *  @brief              创建一个导航栏的选择器
 *
 *  @param frame        大小和位置
 *  @param pickerType   选择器的类型
 *  @param pickerStyle  选择器的风格
 *  @param callBack     选择后的回调
 *
 *  @return             返回当前创建的选择器
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andPickerType:(NAVIGATIONBAR_PICKER_TYPE)pickerType andPickerViewStyle:(NAVIGATIONBAR_PICKER_STYLE)pickerStyle andPickedCallBack:(void(^)(NSString *cityKey,NSString *cityVal))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        ///保存类型
        self.pickerType = pickerType;
        
        ///保存风格
        self.pickerStyle = pickerStyle;
        
        ///初始化状态
        self.isPicking = NO;
        
        ///保存回调
        if (callBack) {
            
            self.pickedCallBack = callBack;
            
        }
        
        ///创建UI
        [self createNaigationBarPickerUI];
        
        ///添加单击事件
        [self addNavigationBarPickerSingleTap];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///创建城市选择UI
- (void)createNaigationBarPickerUI
{
    
    ///中间信息
    UILabel *tipsLabel = [[QSLabel alloc] initWithGap:2.0f];
    tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tipsLabel.text = [QSCoreDataManager getCurrentUserCity] ? [QSCoreDataManager getCurrentUserCity] : @"广州";
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_NAVIGATIONBAR_TITLE];
    tipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:tipsLabel];
    objc_setAssociatedObject(self, &CityInfoLabelKey, tipsLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///约束
    NSString *___HVFL_tipsLabel = @"H:|-(>=5)-[tipsLabel(>=45,<=105)]-(>=5)-|";
    NSString *___vVFL_tipsLabel = @"V:|-[tipsLabel]-|";
    
    ///将信息放在中间
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___HVFL_tipsLabel options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(tipsLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_tipsLabel options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(tipsLabel)]];
    //水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    ///图片
    if (nNavigationBarPickerStyleRightLocal == self.pickerStyle) {
        
        QSImageView *localImageView = [[QSImageView alloc] init];
        localImageView.translatesAutoresizingMaskIntoConstraints = NO;
        localImageView.image = [UIImage imageNamed:IMAGE_PUBLIC_LOCAL_GRAY];
        localImageView.highlightedImage = [UIImage imageNamed:IMAGE_PUBLIC_LOCAL_HIGHLIGHTED];
        [self addSubview:localImageView];
        
        ///添加约束
        NSString *___hVFL_local = @"H:[localImageView(30)][tipsLabel]";
        NSString *___vVFL_local = @"V:[localImageView(30)]";
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_local options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(localImageView,tipsLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_local options:0 metrics:nil views:NSDictionaryOfVariableBindings(localImageView)]];
        
    }
    
    if (nNavigationBarPickerStyleLeftArrow == self.pickerStyle) {
        
        QSImageView *arrowImageView = [[QSImageView alloc] init];
        arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
        arrowImageView.image = [UIImage imageNamed:IMAGE_NAVIGATIONBAR_DISPLAY_ARROW_NORMAL];
        arrowImageView.highlightedImage = [UIImage imageNamed:IMAGE_NAVIGATIONBAR_DISPLAY_ARROW_HIGHLIGHTED];
        [self addSubview:arrowImageView];
        objc_setAssociatedObject(self, &LeftArrowViewKey, arrowImageView, OBJC_ASSOCIATION_ASSIGN);
        
        ///添加约束
        NSString *___hVFL_local = @"H:[tipsLabel][arrowImageView(14)]";
        NSString *___vVFL_local = @"V:[arrowImageView(40)]";
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_local options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(arrowImageView,tipsLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_local options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(arrowImageView)]];
        
    }
    
}

#pragma mark - 为选择器添加单击事件
///为导航栏选择器添加单击事件
- (void)addNavigationBarPickerSingleTap
{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarCityPickerSingleTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
}

#pragma mark - 点击选择器弹出选择项
///点击城市选择
- (void)navigationBarCityPickerSingleTapAction:(UITapGestureRecognizer *)tap
{
    
    ///更换状态
    self.isPicking = YES;
    
    ///获取城市列表
    NSArray *cityList = [QSCoreDataManager getCityList];
    
    ///转换
    NSMutableArray *tempCityList = [[NSMutableArray alloc] init];
    for (QSCDBaseConfigurationDataModel *obj in cityList) {
        
        [tempCityList addObject:obj.val];
        
    }
    
    if (nNavigationBarPickerStyleLeftArrow == self.pickerStyle) {
        
        ///旋转三角形
        UIImageView *arrowImageView = objc_getAssociatedObject(self, &LeftArrowViewKey);
        arrowImageView.image = [UIImage imageNamed:IMAGE_NAVIGATIONBAR_DISPLAY_ARROW_HIGHLIGHTED];
        arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        
    }
    
    ///弹出选择窗口
    [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:tempCityList andCurrentSelectedIndex:0 andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
        
        ///更换状态
        self.isPicking = NO;
        
        if (cCustomPopviewActionTypeSingleSelected == actionType) {
            
            ///更换状态
            self.currentCity = cityList[selectedIndex];
            
            ///更换显示信息
            UILabel *infoLabel = objc_getAssociatedObject(self, &CityInfoLabelKey);
            infoLabel.text = params;
            
            ///回调
            if (self.pickedCallBack) {
                
                self.pickedCallBack([NSString stringWithFormat:@"%@",self.currentCity.key],self.currentCity.val);
                
            }
            
        }
        
        ///如果是左侧带有三角图片的选择框，则还原图片
        if (nNavigationBarPickerStyleLeftArrow == self.pickerStyle) {
            
            ///旋转三角形
            UIImageView *arrowImageView = objc_getAssociatedObject(self, &LeftArrowViewKey);
            arrowImageView.image = [UIImage imageNamed:IMAGE_NAVIGATIONBAR_DISPLAY_ARROW_NORMAL];
            arrowImageView.transform = CGAffineTransformIdentity;
            
        }
        
    }];
    
}

///根据当前的选择器类型，返回不同的选择列表
- (NSArray *)getPickerListDataSource
{

    ///房子的列表主要类型
    if (nNavigationBarPickerStyleTypeHouseMainType == self.pickerType) {
        
        return [QSCoreDataManager getHouseListMainType];
        
    }
    
    ///城市选择类型
    if (nNavigationBarPickerStyleTypeCity == self.pickerType) {
        
        return [QSCoreDataManager getCityList];
        
    }
    
    return nil;

}

@end
