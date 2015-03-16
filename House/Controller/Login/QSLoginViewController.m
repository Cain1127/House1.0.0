//
//  QSLoginViewController.m
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSLoginViewController.h"
#import "QSYRegistViewController.h"

#import "QSCoreDataManager+User.h"

#import "UITextField+CustomField.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "QSVerticalCodeView.h"
#import "QSCustomHUDView.h"

#import "QSYLoginReturnData.h"
#import "QSUserDataModel.h"

#import <objc/runtime.h>

///关联
static char InputLoginInfoRootViewKey;//!<所有登录信息输入框的底view

@interface QSLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,copy) void(^loginCallBack)(BOOL flag); //!<登录后的回调
@property (nonatomic,copy) NSString *verCode;               //!<生成的本地验证码

@end

@implementation QSLoginViewController

#pragma mark - 初始化
///初始化
- (instancetype)initWithCallBack:(void (^)(BOOL))loginCallBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (loginCallBack) {
            
            self.loginCallBack = loginCallBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///设置标题
    [self setNavigationBarTitle:@"登录"];

}

- (void)createMainShowUI
{
    
    ///底view方便弹出键盘时，向上滚动
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_NAVIGATIONBAR_HEIGHT, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    rootView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rootView];
    objc_setAssociatedObject(self, &InputLoginInfoRootViewKey, rootView, OBJC_ASSOCIATION_ASSIGN);

    ///手机
    __block UITextField *phoneField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:TITLE_LOGIN_INPUTCOUNT_PLACEHOLD andLeftTipsInfo:TITLE_LOGIN_INPUTCOUNT_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    phoneField.delegate = self;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [rootView addSubview:phoneField];
    
    ///分隔线
    UILabel *phoneLineLable = [[UILabel alloc] initWithFrame:CGRectMake(phoneField.frame.origin.x + 5.0f, phoneField.frame.origin.y + phoneField.frame.size.height + 3.5f, phoneField.frame.size.width - 10.0f, 0.5f)];
    phoneLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:phoneLineLable];
    
    ///密码
    __block UITextField *passwordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, phoneField.frame.origin.y + phoneField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:TITLE_LOGIN_INPUTPASSWORD_PLACEHOLD andLeftTipsInfo:TITLE_LOGIN_INPUTPASSWORD_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    passwordField.delegate = self;
    passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordField.secureTextEntry = YES;
    [rootView addSubview:passwordField];
    
    ///分隔线
    UILabel *passwordLineLable = [[UILabel alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x + 5.0f, passwordField.frame.origin.y + passwordField.frame.size.height + 3.5f, passwordField.frame.size.width - 10.0f, 0.5f)];
    passwordLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:passwordLineLable];
    
    ///验证码
    __block UITextField *vertificationCodeField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, passwordField.frame.origin.y + passwordField.frame.size.height + 8.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:TITLE_LOGIN_INPUTVERTIFICATIONCODE_PLACEHOLD andLeftTipsInfo:TITLE_LOGIN_INPUTVERTIFICATIONCODE_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    vertificationCodeField.delegate = self;
    phoneField.keyboardType = UIKeyboardTypeASCIICapable;
    [rootView addSubview:vertificationCodeField];
    
    ///验证码生成view
    QSVerticalCodeView *verInfoView = [[QSVerticalCodeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f) andVercodeNum:6 andBackgroudColor:COLOR_HEXCOLOR(0xEBEBEB) andTextColor:COLOR_HEXCOLOR(0xFB7503) andTextFont:16.0f andVerCodeChangeCallBack:^(NSString *verCode) {
        
        ///保存验证码
        if ([verCode length] > 0) {
            
            self.verCode = verCode;
            
        }
        
    }];
    vertificationCodeField.rightViewMode = UITextFieldViewModeAlways;
    vertificationCodeField.rightView = verInfoView;
    
    ///分隔线
    UILabel *vertificationCodeLineLable = [[UILabel alloc] initWithFrame:CGRectMake(vertificationCodeField.frame.origin.x + 5.0f, vertificationCodeField.frame.origin.y + vertificationCodeField.frame.size.height + 3.5f, vertificationCodeField.frame.size.width - 10.0f, 0.5f)];
    vertificationCodeLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:vertificationCodeLineLable];
    
    ///登录按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = TITLE_LOGIN_BUTTON;
    UIButton *loginButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, vertificationCodeField.frame.origin.y + vertificationCodeField.frame.size.height + 6.0f * VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///手机有效性数据
        NSString *phoneString = phoneField.text;
        if ([phoneString length] <= 0) {
            
            [phoneField becomeFirstResponder];
            return;
            
        }
        
        if (![NSString isValidateMobile:phoneString]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"手机号码应为11位数字，以13/14/15/17/18开头", 1.0f, ^(){
            
                [phoneField becomeFirstResponder];
            
            })
            return;
        }
        
        ///密码有效性校验
        NSString *psw = passwordField.text;
        if ([psw length] <= 0) {
            
            [passwordField becomeFirstResponder];
            return;
        }
        
        if ([psw length] < 6) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入6位有效密码", 1.0f, ^(){
            
                [passwordField becomeFirstResponder];
            
            })
            return;
            
        }
        
        ///验证码有效性检测
        NSString *verCode = vertificationCodeField.text;
        if ([verCode length] <= 0) {
            
            [vertificationCodeField becomeFirstResponder];
            return;
            
        }
        
        if (!(NSOrderedSame == [verCode compare:self.verCode options:NSCaseInsensitiveSearch])) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入正确的验证码", 1.0f, ^(){
                
                [vertificationCodeField becomeFirstResponder];
                
            })
            return;
            
        }
        
        ///回收键盘
        [phoneField resignFirstResponder];
        [passwordField resignFirstResponder];
        [vertificationCodeField resignFirstResponder];
        
        ///登录事件
        [self beginLoginAction:phoneString andPassword:psw];
        
    }];
    [rootView addSubview:loginButton];
    
    ///普通用户注册
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = TITLE_LOGIN_NORMALUSER_REGIST_BUTTON;
    UIButton *normalUserRegistButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, loginButton.frame.origin.y + loginButton.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入注册页面
        QSYRegistViewController *registVC = [[QSYRegistViewController alloc] initWithRegistCallBack:^(BOOL flag, NSString *count, NSString *psw) {
            
           ///注册成功
            if (flag) {
                
                phoneField.text = count;
                passwordField.text = psw;
                
            }
            
        }];
        [self.navigationController pushViewController:registVC animated:YES];
        
    }];
    [rootView addSubview:normalUserRegistButton];
    
    ///忘记密码
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClear];
    buttonStyle.title = TITLE_LOGIN_FORGETPASSWORD_BUTTON;
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_14];
    UIButton *forgetPasswordButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, normalUserRegistButton.frame.origin.y + normalUserRegistButton.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, 80.0f, 30.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        
        
    }];
    [rootView addSubview:forgetPasswordButton];

}

#pragma mark - 回调键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    
    return YES;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    UIView *rootView = objc_getAssociatedObject(self, &InputLoginInfoRootViewKey);
    for (UIView *obj in [rootView subviews]) {
        
        if ([obj isKindOfClass:[UITextField class]]) {
            
            [((UITextField *)obj) resignFirstResponder];
            
        }
        
    }

}

#pragma mark - 开始登录
///开始登录
- (void)beginLoginAction:(NSString *)count andPassword:(NSString *)password
{

    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在登录"];
    
    ///参数
    NSDictionary *params = @{@"mobile" : count,
                             @"password" : password};
    
    ///登录
    [QSRequestManager requestDataWithType:rRequestTypeLogin andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"正在登录"];
        
        ///登录成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改用户登录状态
            [QSCoreDataManager updateLoginStatus:YES andCallBack:^(BOOL flag) {
                
                ///保存用户信息
                QSYLoginReturnData *tempModel = resultData;
                QSUserDataModel *userModel = tempModel.userInfo;
                
                [QSCoreDataManager saveLoginUserData:userModel andCallBack:^(BOOL flag) {
                    
                    
                    ///显示提示信息
                    TIPS_ALERT_MESSAGE_ANDTURNBACK(@"登录成功", 1.5f, ^(){
                    
                        [self.navigationController popViewControllerAnimated:YES];
                    
                    })
                    
                }];
                
            }];
            
        } else {
        
            NSString *tips = @"登录失败，请稍后再试";
            if (resultData) {
                
                tips = [resultData valueForKey:@"info"];
                
            }
            
            ///显示提示信息
            TIPS_ALERT_MESSAGE_ANDTURNBACK(tips, 1.5f, ^(){})
            
        }
        
    }];

}

@end
