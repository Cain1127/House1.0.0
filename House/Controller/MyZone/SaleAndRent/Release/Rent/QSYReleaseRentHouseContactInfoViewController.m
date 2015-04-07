//
//  QSYReleaseRentHouseContactInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseRentHouseContactInfoViewController.h"
#import "QSYReleaseRentHouseDateInfoViewController.h"

#import "QSNetworkVerticalCodeView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSReleaseRentHouseDataModel.h"

#define ___VERCODE_AUTOWRITE_TO_FIELD___

@interface QSYReleaseRentHouseContactInfoViewController () <UITextFieldDelegate>

///发布出租房时的暂存模型
@property (nonatomic,retain) QSReleaseRentHouseDataModel *rentHouseReleaseModel;
@property (nonatomic,copy) NSString *verCode;//!<验证码

@end

@implementation QSYReleaseRentHouseContactInfoViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-26 09:03:39
 *
 *  @brief              创建发布出租物业时的联系信息填写窗口
 *
 *  @param saleModel    发布出租物业时的填写数据模型
 *
 *  @return             返回当前创建的联系信息窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRentHouseModel:(QSReleaseRentHouseDataModel *)model
{
    
    if (self = [super init]) {
        
        ///保存数据模型
        self.rentHouseReleaseModel = model;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"发布出租物业"];
    
}

- (void)createMainShowUI
{
    
    ///姓名
    __block UITextField *nameField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"请输入您的联系姓名" andLeftTipsInfo:@"姓       名" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    nameField.delegate = self;
    [self.view addSubview:nameField];
    if ([self.rentHouseReleaseModel.userName  length] > 0) {
        
        nameField.text = self.rentHouseReleaseModel.userName;
        
    }
    
    ///分隔线
    UILabel *nameLineLable = [[UILabel alloc] initWithFrame:CGRectMake(nameField.frame.origin.x + 5.0f, nameField.frame.origin.y + nameField.frame.size.height + 3.5f, nameField.frame.size.width - 10.0f, 0.5f)];
    nameLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:nameLineLable];
    
    ///手机
    __block UITextField *phoneField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, nameField.frame.origin.y + nameField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"请输入您的手机号码" andLeftTipsInfo:@"手       机" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    phoneField.delegate = self;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneField];
    
    if ([self.rentHouseReleaseModel.phone length] > 0) {
        
        phoneField.text = self.rentHouseReleaseModel.phone;
        
    }
    
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
    
    UILabel *vercodeLineLable = [[UILabel alloc] initWithFrame:CGRectMake(vertificationCodeField.frame.origin.x + 5.0f, vertificationCodeField.frame.origin.y + vertificationCodeField.frame.size.height + 3.5f, phoneField.frame.size.width - 10.0f, 0.5f)];
    vercodeLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:vercodeLineLable];
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 44.0f - 25.0f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLineLabel];
    
    ///底部确定按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"下一步";
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///用户名校验
        NSString *userName = nameField.text;
        if ([userName length] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入您的姓名", 1.0f, ^(){
                
                [nameField becomeFirstResponder];
                
            })
            return;
            
        }
        
        if ([userName length] < 2) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入4-11个字符", 1.0f, ^(){
                
                [nameField becomeFirstResponder];
                
            })
            return;
            
        }
        
        ///手机校验
        NSString *phoneNum = phoneField.text;
        if ([phoneNum length] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入您的手机号码", 1.0f, ^(){
                
                [phoneField becomeFirstResponder];
                
            })
            return;
            
        }
        
        if (![NSString isValidateMobile:phoneNum]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"手机号码应为11位数字，以13/14/15/17/18开头", 1.0f, ^(){
                
                [phoneField becomeFirstResponder];
                
            })
            return;
            
        }
        
        ///验证码校验
        NSString *inputVercode = vertificationCodeField.text;
        if ([inputVercode length] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"验证码是6位数字，请重新输入", 1.0f, ^(){
                
                [vertificationCodeField becomeFirstResponder];
                
            })
            return;
            
        }
        
        if (![inputVercode isEqualToString:self.verCode]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"验证码不正确，请重新输入", 1.0f, ^(){
                
                [vertificationCodeField becomeFirstResponder];
                
            })
            return;
            
        }
        
        ///保存信息
        self.rentHouseReleaseModel.userName = userName;
        self.rentHouseReleaseModel.phone = phoneNum;
        self.rentHouseReleaseModel.verCode = inputVercode;
        
        ///回收键盘
        [nameField resignFirstResponder];
        [phoneField resignFirstResponder];
        [vertificationCodeField resignFirstResponder];
        
        ///进入联系信息填写窗口
        QSYReleaseRentHouseDateInfoViewController *pictureAddVC = [[QSYReleaseRentHouseDateInfoViewController alloc] initWithRentHouseModel:self.rentHouseReleaseModel];
        [self.navigationController pushViewController:pictureAddVC animated:YES];
        
    }];
    [self.view addSubview:commitButton];
    
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    ///回收键盘
    for (UIView *obj in [self.view subviews]) {
        
        if ([obj isKindOfClass:[UITextField class]]) {
            
            UITextField *tempField = (UITextField *)obj;
            [tempField resignFirstResponder];
            
        }
        
    }
    
}

@end
