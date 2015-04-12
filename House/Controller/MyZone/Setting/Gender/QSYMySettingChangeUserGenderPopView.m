//
//  QSYMySettingChangeUserGenderPopView.m
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMySettingChangeUserGenderPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UIButton+Factory.h"

@interface QSYMySettingChangeUserGenderPopView ()

@property (nonatomic,copy) NSString *selectedKey;//!<当前选择的key

///改变用户性别时的回调
@property (nonatomic,copy) void(^changeGenderCallBack)(MYSETTING_CHANGE_GENDER_ACTION_TYPE actionType,id parmas);

@end

@implementation QSYMySettingChangeUserGenderPopView

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-12 12:04:03
 *
 *  @brief              创建性别设置页
 *
 *  @param frame        大小和位置
 *  @param selectedKey  当前的性别
 *  @param callBack     选择并确认后的回调
 *
 *  @return             返回当前创建的性别设置
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedGender:(NSString *)selectedKey andCallBack:(void(^)(MYSETTING_CHANGE_GENDER_ACTION_TYPE actionType,id parmas))callBack
{
    
    if (self = [super initWithFrame:frame]) {
        
        ///白色背景
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.changeGenderCallBack = callBack;
            
        }
        
        ///保存y坐标
        self.selectedKey = [selectedKey length] > 0 ? selectedKey : @"0";
        
        ///搭建UI
        [self createChangeUserGenderTipsUI];
        
    }
    
    return self;
    
}

#pragma mark - 创建UI
///创建UI
- (void)createChangeUserGenderTipsUI
{
    
    ///说明
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    tipsLabel.text = @"选择您的性别";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    [self addSubview:tipsLabel];
    
    ///指针
    __block UIButton *femaleButton;
    __block UIButton *maleButton;
    
    ///选择项
    CGFloat widthOfSelected = (self.frame.size.width - 7.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    femaleButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 15.0f, widthOfSelected, 20.0f) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleRightTitle andTitleSize:(widthOfSelected - 23.0f) andMiddleGap:3.0f andCallBack:^(UIButton *button) {
        
        if (button.selected) {
            
            return;
            
        }
        
        maleButton.selected = NO;
        button.selected = YES;
        self.selectedKey = @"0";
        
    }];
    [femaleButton setTitle:@"女" forState:UIControlStateNormal];
    [femaleButton setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [femaleButton setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateSelected];
    [femaleButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL] forState:UIControlStateNormal];
    [femaleButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED] forState:UIControlStateSelected];
    [self addSubview:femaleButton];
    
    maleButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(femaleButton.frame.origin.x, femaleButton.frame.origin.y + femaleButton.frame.size.height + 15.0f, femaleButton.frame.size.width, femaleButton.frame.size.height) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleRightTitle andTitleSize:(widthOfSelected - 23.0f) andMiddleGap:3.0f andCallBack:^(UIButton *button) {
        
        if (button.selected) {
            
            return;
            
        }
        
        femaleButton.selected = NO;
        button.selected = YES;
        self.selectedKey = @"1";
        
    }];
    [maleButton setTitle:@"男" forState:UIControlStateNormal];
    [maleButton setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [maleButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateSelected];
    [maleButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL] forState:UIControlStateNormal];
    [maleButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED] forState:UIControlStateSelected];
    [self addSubview:maleButton];
    
    ///默认选择
    if ([self.selectedKey isEqualToString:@"0"]) {
        
        femaleButton.selected = YES;
        
    }
    
    if ([self.selectedKey isEqualToString:@"1"]) {
        
        maleButton.selected = YES;
        
    }
    
    ///按钮风络
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
    
    ///取消
    buttonStyle.title = @"取消";
    UIButton *saleButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f, self.frame.size.height - 44.0f - 20.0f, (self.frame.size.width - 7.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.changeGenderCallBack) {
            
            self.changeGenderCallBack(mMysettingChangeGenderActionTypeCancel,nil);
            
        }
        
    }];
    [self addSubview:saleButton];
    
    ///保存
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"保存";
    UIButton *rentButton = [UIButton createBlockButtonWithFrame:CGRectMake(saleButton.frame.origin.x + saleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, saleButton.frame.origin.y, saleButton.frame.size.width, saleButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.changeGenderCallBack) {
            
            self.changeGenderCallBack(mMysettingChangeGenderActionTypeConfirm,self.selectedKey);
            
        }
        
    }];
    [self addSubview:rentButton];
    
}

@end
