//
//  QSYMySettingChangePasswordViewController.m
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMySettingChangePasswordViewController.h"

#import "UITextField+CustomField.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "QSCustomHUDView.h"

#import "QSCoreDataManager+User.h"

@interface QSYMySettingChangePasswordViewController () <UITextFieldDelegate>

@property (nonatomic,copy) NSString *oldPassword;//!<原密码

///密码修改后的回调
@property (nonatomic,copy) void(^passwordChangeCallBack)(BOOL isChange,NSString *newPsw);

@end

@implementation QSYMySettingChangePasswordViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-28 14:04:59
 *
 *  @brief          创建一个密码修改页面
 *
 *  @param psw      原密码
 *  @param callBack 修改后的回调
 *
 *  @return         返回当前创建的修改密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPassword:(NSString *)psw andCallBack:(void(^)(BOOL isChange,NSString *newPsw))callBack
{

    if (self = [super init]) {
        
        self.oldPassword = psw;
        self.passwordChangeCallBack = callBack;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"修改账户密码"];

}

- (void)createMainShowUI
{
    
    ///原密码
    __block UITextField *oldPasswordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"输入旧密码" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    oldPasswordField.delegate = self;
    oldPasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    oldPasswordField.secureTextEntry = YES;
    [self.view addSubview:oldPasswordField];
    
    ///分隔线
    UILabel *oldPswLineLable = [[UILabel alloc] initWithFrame:CGRectMake(oldPasswordField.frame.origin.x + 5.0f, oldPasswordField.frame.origin.y + oldPasswordField.frame.size.height + 3.5f, oldPasswordField.frame.size.width - 10.0f, 0.5f)];
    oldPswLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:oldPswLineLable];

    ///密码
    __block UITextField *passwordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, oldPasswordField.frame.origin.y + oldPasswordField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"输入新密码" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    passwordField.delegate = self;
    passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    
    ///分隔线
    UILabel *pswLineLable = [[UILabel alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x + 5.0f, passwordField.frame.origin.y + passwordField.frame.size.height + 3.5f, passwordField.frame.size.width - 10.0f, 0.5f)];
    pswLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:pswLineLable];
    
    ///确认密码
    __block UITextField *confirmPasswordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, passwordField.frame.origin.y + passwordField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"确定新密码" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    confirmPasswordField.delegate = self;
    confirmPasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    confirmPasswordField.secureTextEntry = YES;
    [self.view addSubview:confirmPasswordField];
    
    ///分隔线
    UILabel *confirmPswLineLable = [[UILabel alloc] initWithFrame:CGRectMake(confirmPasswordField.frame.origin.x + 5.0f, confirmPasswordField.frame.origin.y + confirmPasswordField.frame.size.height + 3.5f, confirmPasswordField.frame.size.width - 10.0f, 0.5f)];
    confirmPswLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:confirmPswLineLable];
    
    ///重置按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"确认";
    UIButton *loginButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 64.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///密码有效性数据
        NSString *pswString = passwordField.text;
        if ([pswString length] <= 0) {
            
            [passwordField becomeFirstResponder];
            return;
            
        }
        
        if ([pswString length] < 6) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入6-16位数字、字母或常用符合，字母区分大小写", 1.0f, ^(){
                
                [passwordField becomeFirstResponder];
                
            })
            return;
        }
        
        ///再次输入的密码校验
        NSString *confirmPswString = confirmPasswordField.text;
        if ([confirmPswString length] <= 0) {
            
            [confirmPasswordField becomeFirstResponder];
            return;
            
        }
        
        if (![confirmPswString isEqualToString:pswString]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"与设置密码输入不相符，请重新输入", 1.0f, ^(){})
            return;
            
        }
        
        ///回收键盘
        [passwordField resignFirstResponder];
        [confirmPasswordField resignFirstResponder];
        
        ///登录事件
        [self resetLoginPassword:pswString andOldPhone:nil];
        
    }];
    [self.view addSubview:loginButton];

}

#pragma mark - 重置密码
- (void)resetLoginPassword:(NSString *)newPsw andOldPhone:(NSString *)oldPhone
{
    
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在修改"];

    NSDictionary *params = @{@"old_psw " : APPLICATION_NSSTRING_SETTING(oldPhone, @""),
                             @"new_psw" : APPLICATION_NSSTRING_SETTING(newPsw, @"")};
    
    [QSRequestManager requestDataWithType:rRequestTypeResetLoginPassword andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///修改成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改本地登录密码
            [QSCoreDataManager saveLoginPassword:newPsw andCallBack:^(BOOL flag) {
                
                [hud hiddenCustomHUDWithFooterTips:@"修改成功" andDelayTime:1.5f andCallBack:^(BOOL flag) {
                    
                    ///返回登录
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }];
                
            }];
            
        } else {
            
            NSString *tipsString = @"修改失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];

}

@end
