//
//  QSCustomPickerView.m
//  House
//
//  Created by ysmeng on 15/1/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomPickerView.h"
#import "QSCoreDataManager+User.h"
#import "QSCustomSingleSelectedPopView.h"
#import "QSCoreDataManager+App.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSCoreDataManager+House.h"
#import "QSDistrictPickerView.h"

#import <objc/runtime.h>

///关联
static char InfoLabelKey;       //!<显示信息labelKey
static char LeftArrowViewKey;   //!<左侧箭头
static char CurrentPopViewKey;  //!<当前弹出框的关联key

@interface QSCustomPickerView ()

///选择完成后的回调
@property (nonatomic,copy) void(^pickedCallBack)(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey,NSString *pickedVal);
@property (nonatomic,assign) CUSTOM_PICKER_TYPE pickerType;                         //!<选择器类型
@property (nonatomic,assign) CUSTOM_PICKER_STYLE pickerStyle;                       //!<选择风格
@property (nonatomic,assign) BOOL isPicking;                                        //!<选择view的状态
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentPickedModel;    //!<当前选择项模型
@property (nonatomic,assign) CGFloat indicatorCenterXPoint;                         //!<指示三角中心x

@end

@implementation QSCustomPickerView

/**
 *  @author             yangshengmeng, 15-01-30 11:01:11
 *
 *  @brief              创建一个选择view
 *
 *  @param frame        大小和位置
 *  @param pickerType   选择器的类型
 *  @param pickerStyle  选择器的风格
 *  @param callBack     选择内容后的回调
 *
 *  @return             返回当前创建的选择view
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andPickerType:(CUSTOM_PICKER_TYPE)pickerType andPickerViewStyle:(CUSTOM_PICKER_STYLE)pickerStyle  andIndicaterCenterXPoint:(CGFloat)xpoint andPickedCallBack:(void(^)(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *pickedKey,NSString *pickedVal))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        ///保存类型
        self.pickerType = pickerType;
        
        ///保存风格
        self.pickerStyle = pickerStyle;
        
        ///保存指示器的中心x坐标
        self.indicatorCenterXPoint = xpoint;
        
        ///初始化状态
        self.isPicking = NO;
        
        ///保存回调
        if (callBack) {
            
            self.pickedCallBack = callBack;
            
        }
        
        ///创建UI
        [self createCustomPickerUI];
        
        ///添加单击事件
        [self addCustomPickerSingleTap];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///创建城市选择UI
- (void)createCustomPickerUI
{
    
    ///中间信息
    UILabel *tipsLabel = [[QSLabel alloc] initWithGap:2.0f];
    tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tipsLabel.text = [self getDefaultTypeInfo];
    tipsLabel.font = [self getInfoTextFont];
    tipsLabel.textColor = [self getInfoTextColor];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:tipsLabel];
    objc_setAssociatedObject(self, &InfoLabelKey, tipsLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///获取最小的长度
    CGFloat mixWidth = (self.pickerType >= cCustomPickerTypeChannelBarDistrict) ? 32.0f : 45.0f;
    NSDictionary *___sizeVFL_info = @{@"mixWidth" : [NSString stringWithFormat:@"%.2f",mixWidth]};
    
    ///约束
    NSString *___HVFL_tipsLabel = @"H:|-(>=5)-[tipsLabel(>=mixWidth,<=125)]-(>=5)-|";
    NSString *___vVFL_tipsLabel = @"V:|-[tipsLabel]-|";
    
    ///将信息放在中间
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___HVFL_tipsLabel options:NSLayoutFormatAlignAllCenterX metrics:___sizeVFL_info views:NSDictionaryOfVariableBindings(tipsLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_tipsLabel options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(tipsLabel)]];
    //水平居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    ///图片
    if (cCustomPickerStyleRightLocal == self.pickerStyle) {
        
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
    
    if (cCustomPickerStyleLeftArrow == self.pickerStyle) {
        
        QSImageView *arrowImageView = [[QSImageView alloc] init];
        arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
        arrowImageView.image = [self getRightArrowNormalImage];
        arrowImageView.highlightedImage = [self getRightArrowHighLightedImage];
        [self addSubview:arrowImageView];
        objc_setAssociatedObject(self, &LeftArrowViewKey, arrowImageView, OBJC_ASSOCIATION_ASSIGN);
        
        ///默认高度
        CGFloat height = self.frame.size.height;
        NSDictionary *___sizeVFL_arrow = @{@"height" : [NSString stringWithFormat:@"%.2f",height]};
        
        ///添加约束
        NSString *___hVFL_local = @"H:[tipsLabel][arrowImageView(14)]";
        NSString *___vVFL_local = @"V:[arrowImageView(height)]";
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_local options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(arrowImageView,tipsLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_local options:0 metrics:___sizeVFL_arrow views:NSDictionaryOfVariableBindings(arrowImageView)]];
        
    }
    
}

#pragma mark - 返回右侧三角图片
///返回右侧三角的普通状态图片
- (UIImage *)getRightArrowNormalImage
{

    switch (self.pickerType) {
            ///导航栏三角图形
        case cCustomPickerTypeNavigationBarHouseMainType:
            
            return [UIImage imageNamed:IMAGE_NAVIGATIONBAR_DISPLAY_ARROW_NORMAL];
            
            break;
            
            ///频道栏三角图形
        case cCustomPickerTypeChannelBarDistrict:
            
            ///频道栏三角图形
        case cCustomPickerTypeChannelBarHouseType:
            
            ///频道栏三角图形
        case cCustomPickerTypeChannelBarTotalPrice:
            
            return [UIImage imageNamed:IMAGE_CHANNELBAR_ARROW_NORMAL];
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

///返回右侧三角的选择状态图片
- (UIImage *)getRightArrowHighLightedImage
{
    
    switch (self.pickerType) {
            ///导航栏三角图形
        case cCustomPickerTypeNavigationBarHouseMainType:
            
            return [UIImage imageNamed:IMAGE_NAVIGATIONBAR_DISPLAY_ARROW_HIGHLIGHTED];
            
            break;
            
            ///频道栏三角图形
        case cCustomPickerTypeChannelBarDistrict:
            
            ///频道栏三角图形
        case cCustomPickerTypeChannelBarHouseType:
            
            ///频道栏三角图形
        case cCustomPickerTypeChannelBarTotalPrice:
            
            return [UIImage imageNamed:IMAGE_CHANNELBAR_ARROW_HIGHLIGHTED];
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

#pragma mark - 返回当前类型的字体颜色
///返回不同类型的选择器标题字体颜色
- (UIColor *)getInfoTextColor
{

    switch (self.pickerType) {
            ///导航栏城市选择
        case cCustomPickerTypeNavigationBarCity:
            
            ///导航栏房子主类型选择
        case cCustomPickerTypeNavigationBarHouseMainType:
            
            return COLOR_CHARACTERS_GRAY;
            
            break;
        
            ///其他类型
        default:
            
            return COLOR_CHARACTERS_BLACK;
            
            break;
            
    }
    
    return COLOR_CHARACTERS_BLACK;

}

#pragma mark - 返回当前类型的选择器信息字体
///返回不同类型的选择器标题字体大小
- (UIFont *)getInfoTextFont
{

    switch (self.pickerType) {
            ///导航栏城市选择
        case cCustomPickerTypeNavigationBarCity:
            
            ///导航栏房子主类型选择
        case cCustomPickerTypeNavigationBarHouseMainType:
            
            return [UIFont boldSystemFontOfSize:FONT_NAVIGATIONBAR_TITLE];
            
            break;
            
            ///其他类型
        default:
            
            return [UIFont systemFontOfSize:FONT_BODY_14];;
            
            break;
            
    }
    
    return [UIFont systemFontOfSize:FONT_BODY_14];

}

#pragma mark - 返回当前选择器的默认选择项
///返回选择器当前默认显示信息
- (NSString *)getDefaultTypeInfo
{
    
    switch (self.pickerType) {
            ///城市选择：返回当前用户的位置
        case cCustomPickerTypeNavigationBarCity:
            
            return ([QSCoreDataManager getCurrentUserCity]) ? ([QSCoreDataManager getCurrentUserCity]) : @"广州";
            
            break;
            
            ///房子列表类型选择：返回上次的选择，或者默认二手房
        case cCustomPickerTypeNavigationBarHouseMainType:
            
            return @"二手房";
            
            break;
            
            ///频道栏-区域选择
        case cCustomPickerTypeChannelBarDistrict:
            
            return @"区域";
            
            break;
            
            ///频道栏-户型选择
        case cCustomPickerTypeChannelBarHouseType:
            
            return @"户型";
            
            break;
            
            ///频道栏-总价选择
        case cCustomPickerTypeChannelBarTotalPrice:
            
            return @"总价";
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

#pragma mark - 转换选择器的状态
///重写选择器当前状态，不同状态更换不同的风格
- (void)setIsPicking:(BOOL)isPicking
{

    ///保存当前状态
    _isPicking = isPicking;
    
    ///更新当前的选择状态
    if (isPicking) {
        
        ///修改字段颜色
        UILabel *infoLabel = objc_getAssociatedObject(self, &InfoLabelKey);
        if (infoLabel) {
            
            infoLabel.textColor = COLOR_CHARACTERS_YELLOW;
            
        }
        
        ///旋转三角形
        UIImageView *arrowImageView = objc_getAssociatedObject(self, &LeftArrowViewKey);
        if (arrowImageView) {
            
            arrowImageView.image = [UIImage imageNamed:IMAGE_NAVIGATIONBAR_DISPLAY_ARROW_HIGHLIGHTED];
            arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            
        }
        
    } else {
        
        ///修改字段颜色
        UILabel *infoLabel = objc_getAssociatedObject(self, &InfoLabelKey);
        if (infoLabel) {
            
            infoLabel.textColor = [self getInfoTextColor];
            
        }
    
        ///旋转三角形
        UIImageView *arrowImageView = objc_getAssociatedObject(self, &LeftArrowViewKey);
        if (arrowImageView) {
            
            arrowImageView.image = [UIImage imageNamed:IMAGE_NAVIGATIONBAR_DISPLAY_ARROW_NORMAL];
            arrowImageView.transform = CGAffineTransformIdentity;
            
        }
    
    }

}

#pragma mark - 为选择器添加单击事件
///为导航栏选择器添加单击事件
- (void)addCustomPickerSingleTap
{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customPickerSingleTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
}

#pragma mark - 点击选择器弹出选择项
///点击选择按钮时回收/弹出选择框
- (void)customPickerSingleTapAction:(UITapGestureRecognizer *)tap
{
    
    ///判断当前的弹出状态
    if (self.isPicking) {
        
        ///回调
        if (self.pickedCallBack) {
            
            self.pickedCallBack(pPickerCallBackActionTypeUnPickedHidden,nil,nil);
            
        }
        
        ///移除弹出框
        [self removePickerView];
        
        return;
        
    }
    
    ///回调
    if (self.pickedCallBack) {
        
        self.pickedCallBack(pPickerCallBackActionTypeShow,nil,nil);
        
    }
    
    ///当前未弹出，则弹出对应的视图
    switch (self.pickerType) {
            ///导航栏城市选择窗口
        case cCustomPickerTypeNavigationBarCity:
            
            ///列表房子主类型选择窗口
        case cCustomPickerTypeNavigationBarHouseMainType:
            
            [self showPickerViewWithActionSheetAnimination];
            
            break;
            
        default:
            
            [self showPickerViewWithHorizontalLeftToRightAnimination];
            
            break;
    }
    
}

///根据当前的选择器类型，返回不同的选择列表
- (NSArray *)getPickerListDataSource
{
    
    ///房子的列表主要类型
    if (cCustomPickerTypeNavigationBarCity == self.pickerType) {
        
        return [QSCoreDataManager getCityList];
        
    }
    
    ///城市选择类型
    if (cCustomPickerTypeNavigationBarHouseMainType == self.pickerType) {
        
        return [QSCoreDataManager getHouseListMainType];
        
    }
    
    return nil;
    
}

#pragma mark - 从下往上弹出一个选择窗框
/**
 *  @author yangshengmeng, 15-01-30 12:01:08
 *
 *  @brief  从下往上弹出一个选择窗框
 *
 *  @since  1.0.0
 */
- (void)showPickerViewWithActionSheetAnimination
{

    ///更换状态
    self.isPicking = YES;
    
    ///获取列表源
    NSArray *dataSource = [self getPickerListDataSource];
    
    ///转换
    NSMutableArray *tempDataSource = [[NSMutableArray alloc] init];
    for (QSCDBaseConfigurationDataModel *obj in dataSource) {
        
        [tempDataSource addObject:obj.val];
        
    }
    
    ///弹出选择窗口
    [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:tempDataSource andCurrentSelectedIndex:0 andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
        
        ///更换状态
        self.isPicking = NO;
        
        if (cCustomPopviewActionTypeSingleSelected == actionType) {
            
            ///更换状态
            self.currentPickedModel = dataSource[selectedIndex];
            
            ///更换显示信息
            UILabel *infoLabel = objc_getAssociatedObject(self, &InfoLabelKey);
            infoLabel.text = params;
            
            ///回调
            if (self.pickedCallBack) {
                
                self.pickedCallBack(pPickerCallBackActionTypePicked,[NSString stringWithFormat:@"%@",self.currentPickedModel.key],self.currentPickedModel.val);
                
            }
            
        }
        
    }];

}

#pragma mark - 从左往右弹出一个选择框
/**
 *  @author yangshengmeng, 15-01-30 12:01:44
 *
 *  @brief  从左往右弹出一个选择框
 *
 *  @since  1.0.0
 */
- (void)showPickerViewWithHorizontalLeftToRightAnimination
{
    
    ///更换状态
    self.isPicking = YES;
    
    ///获取需要弹出的view
    UIView *popView = [self createHorizontalLeftToRightAniminationView];
    
    ///弹出时的底view
    UIView *popRootView = [[UIView alloc] initWithFrame:CGRectMake(-SIZE_DEVICE_WIDTH, 104.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 104.0f)];
    popRootView.alpha = 0.0f;
    popRootView.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [popRootView addSubview:popView];
    objc_setAssociatedObject(self, &CurrentPopViewKey, popRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///指示三角形
    QSImageView *indicateArrow = [[QSImageView alloc] initWithFrame:CGRectMake(self.indicatorCenterXPoint - 15.0f, 0.0f, 30.0f, 10.0f)];
    indicateArrow.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [popRootView addSubview:indicateArrow];
    
    ///获取当前底viewController
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC.view addSubview:popRootView];
    [rootVC.view bringSubviewToFront:popRootView];
    
    ///动画推出选择框
    [UIView animateWithDuration:0.3 animations:^{
        
        popRootView.frame = CGRectMake(0.0f, 104.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 104.0f);
        popRootView.alpha = 1.0f;
        
    }];

}

///根据当前选择器的类型创建从左向右滑动的选择窗口
- (UIView *)createHorizontalLeftToRightAniminationView
{

    switch (self.pickerType) {
            ///地区选择
        case cCustomPickerTypeChannelBarDistrict:
        {
        
            QSDistrictPickerView *districtPickerView = [[QSDistrictPickerView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 114.0f) andSelectedDistrcitKey:nil andSelectedStreetKey:nil andDistrictPickeredCallBack:^(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType, QSCDBaseConfigurationDataModel *distictModel,QSCDBaseConfigurationDataModel *streetModel) {
                
                ///更换状态
                self.isPicking = NO;
                
                ///保存当前选择模型
                self.currentPickedModel = distictModel;
                
                ///更换显示信息
                UILabel *infoLabel = objc_getAssociatedObject(self, &InfoLabelKey);
                infoLabel.text = self.currentPickedModel.val;
                
                ///回调
                if (self.pickedCallBack) {
                    
                    self.pickedCallBack(pPickerCallBackActionTypePicked,[NSString stringWithFormat:@"%@",self.currentPickedModel.key],self.currentPickedModel.val);
                    
                }
                
            }];
            
            return districtPickerView;
        
        }
            break;
            
        default:
            
            return nil;
            
            break;
    }
    
    return nil;

}

#pragma mark - 移聊当前弹出框
/**
 *  @author yangshengmeng, 15-01-30 13:01:48
 *
 *  @brief  移聊当前弹出的选择框
 *
 *  @since  1.0.0
 */
- (void)removePickerView
{
    
    if (!self.isPicking) {
        
        return;
        
    }

    ///更换状态
    self.isPicking = NO;
    
    ///判断是否有弹出框
    UIView *currentPopView = objc_getAssociatedObject(self, &CurrentPopViewKey);
    if (currentPopView) {
        
        [currentPopView removeFromSuperview];
        
    }

}

@end
