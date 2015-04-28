//
//  QSYMySettingChangeUserReadNameTipsPopView.m
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMySettingChangeUserReadNameTipsPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYMySettingChangeUserReadNameTipsPopView () <UITextFieldDelegate>

///修改用户真名后的回调
@property (nonatomic,copy) void(^changeRealNameCallBack)(MYSETTING_CHANGE_NAME_ACTION_TYPE actionType,id parmas);

@property (nonatomic,assign) CGFloat ypoint;

@end

@implementation QSYMySettingChangeUserReadNameTipsPopView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-12 12:04:23
 *
 *  @brief          创建一个修改用户真姓名的提示框
 *
 *  @param frame    大小和位置
 *  @param callBack 确认或者取消时的回调
 *
 *  @return         返回当前创建的提示框
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(MYSETTING_CHANGE_NAME_ACTION_TYPE actionType,id parmas))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///白色背景
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.changeRealNameCallBack = callBack;
            
        }
        
        ///保存y坐标
        self.ypoint = frame.origin.y;
        
        ///搭建UI
        [self createChangeUserRealNameTipsUI];
        
    }
    
    return self;

}

#pragma mark - 创建UI
///创建UI
- (void)createChangeUserRealNameTipsUI
{
    
    ///说明
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    tipsLabel.text = @"修改姓名";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    [self addSubview:tipsLabel];
    
    ///输入框
    __block UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 15.0f, SIZE_DEVICE_WIDTH - 6.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
    inputField.layer.borderColor = [COLOR_CHARACTERS_LIGHTYELLOW CGColor];
    inputField.layer.borderWidth = 0.5f;
    inputField.layer.cornerRadius = 6.0f;
    inputField.delegate = self;
    [self addSubview:inputField];
    
    ///按钮风络
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
    
    ///取消
    buttonStyle.title = @"取消";
    UIButton *saleButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f, self.frame.size.height - 44.0f - 20.0f, (self.frame.size.width - 7.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.changeRealNameCallBack) {
            
            self.changeRealNameCallBack(mMysettingChangeNameActionTypeCancel,nil);
            
        }
        
    }];
    [self addSubview:saleButton];
    
    ///保存
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"保存";
    UIButton *rentButton = [UIButton createBlockButtonWithFrame:CGRectMake(saleButton.frame.origin.x + saleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, saleButton.frame.origin.y, saleButton.frame.size.width, saleButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.changeRealNameCallBack) {
            
            self.changeRealNameCallBack(mMysettingChangeNameActionTypeConfirm,inputField.text);
            
        }
        
    }];
    [self addSubview:rentButton];
    
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    for (UIView *obj in [self subviews]) {
        
        if ([obj isKindOfClass:[UITextField class]]) {
            
            UITextField *textField = (UITextField *)obj;
            [textField resignFirstResponder];
            
        }
        
    }

}

@end
