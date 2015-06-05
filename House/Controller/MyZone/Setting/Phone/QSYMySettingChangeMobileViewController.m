//
//  QSYMySettingChangeMobileViewController.m
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMySettingChangeMobileViewController.h"

#import "UITextField+CustomField.h"
#import "QSNetworkVerticalCodeView.h"
#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSCoreDataManager+User.h"

//#define ___VERCODE_AUTOWRITE_TO_FIELD___

@interface QSYMySettingChangeMobileViewController ()<UITextFieldDelegate>

@property (nonatomic,copy) NSString *oldPhone;  //!<原手机
@property (nonatomic,copy) NSString *verCode;   //!<验证码

///手机号码变更后的回调
@property (nonatomic,copy) void(^phoneChangeCallBack)(BOOL isChange,NSString *newPhone);

@end

@implementation QSYMySettingChangeMobileViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-28 14:04:54
 *
 *  @brief          创建一个修改用户手机的页面
 *
 *  @param phone    当前手机号码
 *  @param callBack 修改后的回调
 *
 *  @return         返回当前创建的手机号码变更页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPhone:(NSString *)phone andCallBack:(void(^)(BOOL isChange,NSString *newPhone))callBack
{

    if (self = [super init]) {
        
        self.oldPhone = phone;
        self.phoneChangeCallBack = callBack;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"修改手机号码"];

}

- (void)createMainShowUI
{

    ///手机
    __block UITextField *phoneField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:TITLE_LOGIN_INPUTCOUNT_PLACEHOLD andLeftTipsInfo:TITLE_LOGIN_INPUTCOUNT_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    phoneField.delegate = self;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    if ([self.oldPhone length] == 11) {
        
        phoneField.text = self.oldPhone;
        
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
            
#ifdef ___VERCODE_AUTOWRITE_TO_FIELD___
            vertificationCodeField.text = verCode;
#endif
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
    
    ///确定修改按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"确定";
    UIButton *loginButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
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
        
        ///判断是否是原手机
        if ([phoneString isEqualToString:self.oldPhone]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入新手机号码", 1.0f, ^(){
                
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
        
        ///修改手机
        [self gotoResetPhoneAction:phoneString];
        
    }];
    [self.view addSubview:loginButton];

}

#pragma mark - 修改手机号码
- (void)gotoResetPhoneAction:(NSString *)newPhone
{

    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在修改手机"];
    
    ///封装参数
    NSDictionary *params = @{@"mobile" : APPLICATION_NSSTRING_SETTING(newPhone, @"")};
    
    [QSRequestManager requestDataWithType:rRequestTypeResetMobile andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///修改成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               
                ///重新下载用户信息
                [QSCoreDataManager reloadUserInfoFromServer];
                
            });
            
            ///显示提示
            [hud hiddenCustomHUDWithFooterTips:@"修改成功" andDelayTime:2.5f andCallBack:^(BOOL flag) {
                
                ///返回上一页
                [self.navigationController popToRootViewControllerAnimated:YES];
                
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
