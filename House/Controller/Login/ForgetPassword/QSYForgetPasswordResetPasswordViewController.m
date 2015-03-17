//
//  QSYForgetPasswordResetPasswordViewController.m
//  House
//
//  Created by ysmeng on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYForgetPasswordResetPasswordViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

@interface QSYForgetPasswordResetPasswordViewController () <UITextFieldDelegate>

@property (nonatomic,copy) NSString *phone;     //!<手机号码
@property (nonatomic,copy) NSString *verCode;   //!<验证码

@end

@implementation QSYForgetPasswordResetPasswordViewController

/**
 *  @author         yangshengmeng, 15-03-16 11:03:17
 *
 *  @brief          根据手机和验证码，创建一个忘记密码并重置密码的页面
 *
 *  @param phone    手机号码
 *  @param verCode  验证码
 *
 *  @return         返回当前创建的重置密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPhone:(NSString *)phone andVerCode:(NSString *)verCode
{

    if (self = [super init]) {
        
        ///保存信息
        self.phone = phone;
        self.verCode = verCode;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    ///设置标题
    [self setNavigationBarTitle:@"忘记密码"];
    
}

- (void)createMainShowUI
{
    
    ///密码
    __block UITextField *passwordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"输入6-20位登录密码" andLeftTipsInfo:@"设置密码：" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    passwordField.delegate = self;
    passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    
    ///分隔线
    UILabel *pswLineLable = [[UILabel alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x + 5.0f, passwordField.frame.origin.y + passwordField.frame.size.height + 3.5f, passwordField.frame.size.width - 10.0f, 0.5f)];
    pswLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:pswLineLable];
    
    ///确认密码
    __block UITextField *confirmPasswordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, passwordField.frame.origin.y + passwordField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"再次输入设置密码" andLeftTipsInfo:@"确认密码：" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    confirmPasswordField.delegate = self;
    confirmPasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    confirmPasswordField.secureTextEntry = YES;
    [self.view addSubview:confirmPasswordField];
    
    ///分隔线
    UILabel *confirmPswLineLable = [[UILabel alloc] initWithFrame:CGRectMake(confirmPasswordField.frame.origin.x + 5.0f, confirmPasswordField.frame.origin.y + confirmPasswordField.frame.size.height + 3.5f, passwordField.frame.size.width - 10.0f, 0.5f)];
    confirmPswLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:confirmPswLineLable];
    
    ///重置按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"确认修改";
    UIButton *loginButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, confirmPasswordField.frame.origin.y + confirmPasswordField.frame.size.height + 6.0f * VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
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
        [self resetLoginPassword:pswString];
        
    }];
    [self.view addSubview:loginButton];
    
}

#pragma mark - 修改登录密码
- (void)resetLoginPassword:(NSString *)pswString
{
    
    

}

@end
