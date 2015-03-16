//
//  QSYForgetPasswordViewController.m
//  House
//
//  Created by ysmeng on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYForgetPasswordViewController.h"
#import "QSYForgetPasswordResetPasswordViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSNetworkVerticalCodeView.h"

#import "QSCoreDataManager+User.h"

@interface QSYForgetPasswordViewController () <UITextFieldDelegate>

@property (nonatomic,copy) NSString *verCode;//!<手机验证码

@end

@implementation QSYForgetPasswordViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    ///设置标题
    [self setNavigationBarTitle:@"忘记密码"];
    
}

- (void)createMainShowUI
{
    
    ///获取本地用户的手机
    NSString *localPhone = [QSCoreDataManager getCurrentUserPhone];
    
    ///手机
    __block UITextField *phoneField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:TITLE_LOGIN_INPUTCOUNT_PLACEHOLD andLeftTipsInfo:TITLE_LOGIN_INPUTCOUNT_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    phoneField.delegate = self;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    if ([localPhone length] == 11) {
        
        phoneField.text = localPhone;
        
    }
    [self.view addSubview:phoneField];
    
    ///分隔线
    UILabel *phoneLineLable = [[UILabel alloc] initWithFrame:CGRectMake(phoneField.frame.origin.x + 5.0f, phoneField.frame.origin.y + phoneField.frame.size.height + 3.5f, phoneField.frame.size.width - 10.0f, 0.5f)];
    phoneLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:phoneLineLable];
    
    ///验证码
    __block UITextField *vertificationCodeField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, phoneField.frame.origin.y + phoneField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:TITLE_LOGIN_INPUTVERTIFICATIONCODE_PLACEHOLD andLeftTipsInfo:TITLE_LOGIN_INPUTVERTIFICATIONCODE_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    vertificationCodeField.delegate = self;
    vertificationCodeField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:vertificationCodeField];
    
    ///获取验证码的UI
    QSNetworkVerticalCodeView *sendVerView = [[QSNetworkVerticalCodeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 30.0f) andVerticalSendNetworkType:rRequestTypeSendPhoneVertical andPhoneField:phoneField andAttachParams:@{@"sign" : @"2"} andImageName:nil andBackgroudColor:COLOR_CHARACTERS_LIGHTYELLOW andTextColor:[UIColor blackColor] andTextFontSize:14.0f andGapSecond:60 andSendResultCallBack:^(SEND_PHONE_VERTICALCODE_ACTION_TYPE actionType, NSString *verCode) {
        
        ///手机号码无效
        if (sSendPhoneVerticalCodeActionTypeInvalidPhone == actionType) {
            
            self.verCode = nil;
            [phoneField becomeFirstResponder];
            return;
            
        }
        
        ///非法手机号码
        if (sSendPhoneVerticalCodeActionTypePhoneError == actionType) {
            
            self.verCode = nil;
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"手机号码应为11位数字，以13/14/15/17/18开头", 1.0f, ^(){
                
                [phoneField becomeFirstResponder];
                
            })
            
            return;
            
        }
        
        ///发送失败
        if (sSendPhoneVerticalCodeActionTypeFail == actionType) {
            
            self.verCode = nil;
            TIPS_ALERT_MESSAGE_ANDTURNBACK(verCode, 1.0f, ^(){})
            return;
            
        }
        
        ///发送成功
        if (sSendPhoneVerticalCodeActionTypeSuccess == actionType) {
            
            self.verCode = verCode;
            [phoneField resignFirstResponder];
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"验证码已发到你手机，请注意查收", 1.0f, ^(){})
            APPLICATION_LOG_INFO(@"手机验证码",verCode)
            return;
            
        }
        
    }];
    sendVerView.layer.cornerRadius = 6.0f;
    vertificationCodeField.rightViewMode = UITextFieldViewModeAlways;
    vertificationCodeField.rightView = sendVerView;
    
    ///分隔线
    UILabel *vercodeLineLable = [[UILabel alloc] initWithFrame:CGRectMake(vertificationCodeField.frame.origin.x + 5.0f, vertificationCodeField.frame.origin.y + vertificationCodeField.frame.size.height + 3.5f, vertificationCodeField.frame.size.width - 10.0f, 0.5f)];
    vercodeLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:vercodeLineLable];
    
    ///注册按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"下一步";
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
        
        ///验证码有效性检测
        NSString *verCode = vertificationCodeField.text;
        if ([verCode length] <= 0) {
            
            [vertificationCodeField becomeFirstResponder];
            return;
            
        }
        
        if (![verCode isEqualToString:self.verCode]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入正确的验证码", 1.0f, ^(){
                
                [vertificationCodeField becomeFirstResponder];
                
            })
            return;
            
        }
        
        ///回收键盘
        [phoneField resignFirstResponder];
        [vertificationCodeField resignFirstResponder];
        
        ///登录事件
        [self gotoResetPasswordAction:phoneString andVerCode:verCode];
        
    }];
    [self.view addSubview:loginButton];
    
}

#pragma mark - 进入重置密码页面
- (void)gotoResetPasswordAction:(NSString *)phone andVerCode:(NSString *)verCode
{

    QSYForgetPasswordResetPasswordViewController *resetPasswordVC = [[QSYForgetPasswordResetPasswordViewController alloc] initWithPhone:phone andVerCode:verCode];
    [self.navigationController pushViewController:resetPasswordVC animated:YES];

}

@end
