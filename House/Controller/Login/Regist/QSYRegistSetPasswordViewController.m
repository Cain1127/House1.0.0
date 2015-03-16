//
//  QSYRegistSetPasswordViewController.m
//  House
//
//  Created by ysmeng on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRegistSetPasswordViewController.h"
#import "QSYAgreementViewController.h"

#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

@interface QSYRegistSetPasswordViewController () <UITextFieldDelegate>

@property (nonatomic,copy) NSString *phone;     //!<注册的手机
@property (nonatomic,copy) NSString *verCode;   //!<发送到手机的验证码

///注册请求完成后的回调
@property (nonatomic,copy) void(^registCallBack)(BOOL flag,NSString *count,NSString *psw);

@end

@implementation QSYRegistSetPasswordViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-14 10:03:42
 *
 *  @brief          创建注册设置密码的页面
 *
 *  @param phone    注册的手机
 *  @param verCode  所发送的手机验证码
 *  @param callBack 注册后的回调
 *
 *  @return         返回当前创建的注册设置密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithRegistPhone:(NSString *)phone andVercode:(NSString *)verCode andRegistCallBack:(void(^)(BOOL flag,NSString *count,NSString *psw))callBack
{

    if (self = [super init]) {
        
        ///保存手机
        self.phone = phone;
        
        ///保存验证码
        self.verCode = verCode;
        
        ///保存回调
        if (callBack) {
            
            self.registCallBack = callBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    ///设置标题
    [self setNavigationBarTitle:@"用户注册"];
    
}

- (void)createMainShowUI
{
    
    ///用户名
    __block UITextField *nameField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"输入您的用户名" andLeftTipsInfo:@"用 户 名 ：" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    nameField.delegate = self;
    nameField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:nameField];
    
    ///分隔线
    UILabel *nameLineLable = [[UILabel alloc] initWithFrame:CGRectMake(nameField.frame.origin.x + 5.0f, nameField.frame.origin.y + nameField.frame.size.height + 3.5f, nameField.frame.size.width - 10.0f, 0.5f)];
    nameLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:nameLineLable];
    
    ///密码
    __block UITextField *passwordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, nameField.frame.origin.y + nameField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"输入6-20位登录密码" andLeftTipsInfo:@"设置密码：" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
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
    
    ///登录按钮指针
    __block UIButton *loginButton = nil;
    
    ///协议选择状态提示图片
    UIButton *protocalButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 5.0f, confirmPasswordField.frame.origin.y + confirmPasswordField.frame.size.height + 2.0f * VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, 20.0f, 20.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///按钮状态取反
        if (button.selected) {
            
            button.selected = NO;
            loginButton.userInteractionEnabled = NO;
            loginButton.backgroundColor = COLOR_CHARACTERS_LIGHTGRAY;
            
        } else {
        
            button.selected = YES;
            loginButton.userInteractionEnabled = YES;
            loginButton.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
        
        }
        
    }];
    [protocalButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL] forState:UIControlStateNormal];
    [protocalButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED] forState:UIControlStateSelected];
    protocalButton.selected = YES;
    [self.view addSubview:protocalButton];
    
    ///协议说明文字按钮
    UIButton *protocalTipsButton = [UIButton createBlockButtonWithFrame:CGRectMake(protocalButton.frame.origin.x + protocalButton.frame.size.width + 5.0f, protocalButton.frame.origin.y - 4.0f, 160.0f, 30.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入协议详情页
        QSYAgreementViewController *agreementVC = [[QSYAgreementViewController alloc] init];
        [self.navigationController pushViewController:agreementVC animated:YES];
        
    }];
    [protocalTipsButton setTitle:@"同意用户使用协议" forState:UIControlStateNormal];
    [protocalTipsButton setTitleColor:COLOR_CHARACTERS_LIGHTGRAY forState:UIControlStateNormal];
    [protocalTipsButton setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateHighlighted];
    protocalTipsButton.backgroundColor = [UIColor clearColor];
    protocalTipsButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.view addSubview:protocalTipsButton];
    
    ///注册按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"注册";
    loginButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, protocalButton.frame.origin.y + protocalButton.frame.size.height + 6.0f * VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///有户名有效性数据
        NSString *nameString = nameField.text;
        if ([nameString length] > 0 && [nameString length] < 4) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入4-11个字符", 1.0f, ^(){
            
                [nameField becomeFirstResponder];
            
            })
            return;
            
        }
        
        ///密码有效性检测
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
        [nameField resignFirstResponder];
        [passwordField resignFirstResponder];
        [confirmPasswordField resignFirstResponder];
        
        ///登录事件
        [self beginRegistAction:nameString andPassword:pswString];
        
    }];
    [self.view addSubview:loginButton];
    
}

#pragma mark - 注册
///开始服务端注册
- (void)beginRegistAction:(NSString *)count andPassword:(NSString *)psw
{

    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在注册"];
    
    ///参数
    NSDictionary *params = @{@"mobile" : self.phone,
                             @"password" : psw,
                             @"vercode" : self.verCode,
                             @"username" : ([count length] > 3 ? count : @"")};
    
    ///网络注册
    [QSRequestManager requestDataWithType:rRequestTypeRegistPhone andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"正在注册"];
        
        ///注册成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///回调
            if (self.registCallBack) {
                
                self.registCallBack(YES,self.phone,psw);
                
            }
            
            ///显示提示信息
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"注册成功", 1.5f, ^(){
            
                ///返回登录页面
                APPLICATION_JUMP_BACK_STEPVC(3)
            
            })
            
        } else {
        
            NSString *tips = @"注册失败，请稍后再试";
            if (resultData) {
                
                tips = [resultData valueForKey:@"info"];
                
            }
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(tips, 1.5f, ^(){})
        
        }
        
    }];

}

@end
