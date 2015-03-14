//
//  QSNetworkVerticalCodeView.m
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNetworkVerticalCodeView.h"

#import "QSRequestManager.h"

#import "QSYSendVerticalCodeReturnData.h"

@interface QSNetworkVerticalCodeView ()

@property (nonatomic,unsafe_unretained) UITextField *phoneField;//!<手机号码输入框
@property (nonatomic,assign) REQUEST_TYPE requestType;          //!<获取验证码的请求类型
@property (nonatomic,assign) int limitedTimaGap;                //!<验证码发送的时间间隔:默认60
@property (nonatomic,assign) int countDown;                     //!<倒计时
@property (nonatomic,retain) UIColor *textColor;                //!<文本颜色
@property (nonatomic,assign) CGFloat textFontSize;              //!<文本大小

///发送验证码之后的回调
@property (nonatomic,copy) void(^sendVerticalCodeCallBack)(SEND_PHONE_VERTICALCODE_ACTION_TYPE actionType,NSString *verCode);

@property (nonatomic,strong) UILabel *infoLabel;                    //!<信息展示
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;//!<指示器
@property (nonatomic,assign) BOOL isCanSend;                        //!<当前是否可以发送

@end

@implementation QSNetworkVerticalCodeView

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-13 19:03:02
 *
 *  @brief              创建一个发送手机验证码的控件，需要绑定手机号码输入框及其他重新属性
 *
 *  @param frame        大小和位置
 *  @param sendCodeType 对应的请求枚举类型，需要配合QSRequestManager使用
 *  @param textField    绑定的手机号码输入框，用以判断当前手机号码是否有效
 *  @param imageName    背景图片
 *  @param bgColor      背景颜色
 *  @param textColor    文本的颜色
 *  @param textSize     文本的字体大小
 *  @param gapSecond    发送间隔：默认60秒
 *  @param callBack     发送后的回调
 *
 *  @return             返回当前创建的发送手机验证码view
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andVerticalSendNetworkType:(REQUEST_TYPE)sendCodeType andPhoneField:(UITextField *)textField andImageName:(NSString *)imageName andBackgroudColor:(UIColor *)bgColor andTextColor:(UIColor *)textColor andTextFontSize:(CGFloat)textSize andGapSecond:(int)gapSecond andSendResultCallBack:(void(^)(SEND_PHONE_VERTICALCODE_ACTION_TYPE actionType,NSString *verCode))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
        ///保存请求类型
        self.requestType = sendCodeType;
        
        ///保存字体颜色
        self.textColor = textColor ? textColor : [UIColor blackColor];
        
        ///保存字体大小
        self.textFontSize = textSize >= 12.0f ? textSize : 12.0f;
        
        ///保存手机号码输入框
        self.phoneField = textField;
        
        ///保存最小间隔后可以再次发送验证码
        self.limitedTimaGap = gapSecond >= 60 ? gapSecond : 60;
        
        ///初始化时，发送状态可以发送
        self.isCanSend = YES;
        
        ///设置背景颜色
        if (bgColor) {
            
            self.backgroundColor = bgColor;
            
        }
        
        ///设置图片
        if (imageName) {
            
            self.image = [UIImage imageNamed:imageName];
            
        }
        
        ///保存回调
        if (callBack) {
            
            self.sendVerticalCodeCallBack = callBack;
            
        }
        
        ///创建UI
        [self createSendPhoneVerticalViewUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createSendPhoneVerticalViewUI
{

    ///提示框
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f, 2.0f, self.frame.size.width - 4.0f, self.frame.size.height - 4.0f)];
    self.infoLabel.text = @"获取验证码";
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.textColor = self.textColor;
    self.infoLabel.font = [UIFont systemFontOfSize:self.textFontSize];
    [self addSubview:self.infoLabel];
    
    ///指示器
    CGFloat width = self.frame.size.height >= 30.0f ? 30.0f : self.frame.size.height;
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicatorView.frame = CGRectMake(self.frame.size.width / 2.0f - 15.0f, (self.frame.size.height - width) / 2.0f, width, width);
    self.indicatorView.hidden = YES;
    [self addSubview:self.indicatorView];
    
    ///添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSendPhoneVerticalCode)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];

}

#pragma mark - 发送一个手机验证码
///发送一个手机验证码
- (void)reSendPhoneVerticalCode
{

    ///判断当前是否可以发送
    if (!self.isCanSend) {
        
        return;
        
    }
    
    ///验证手机
    NSString *phone = self.phoneField.text;
    
    if ([phone length] <= 0) {
        
        if (self.sendVerticalCodeCallBack) {
            
            self.sendVerticalCodeCallBack(sSendPhoneVerticalCodeActionTypeInvalidPhone,nil);
            
        }
        return;
    }
    
    if (![NSString isValidateMobile:phone]) {
        
        if (self.sendVerticalCodeCallBack) {
            
            self.sendVerticalCodeCallBack(sSendPhoneVerticalCodeActionTypePhoneError,nil);
            
        }
        return;
        
    }
    
    ///更换状态
    self.isCanSend = NO;
    
    ///显示指示器
    self.infoLabel.hidden = YES;
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    
    ///发送验证码
    [self sendPhoneVertical:phone];

}

///发送验证码
- (void)sendPhoneVertical:(NSString *)phone
{

    ///封装参数
    NSDictionary *params = @{@"mobile" : phone,
                             @"sign" : @"1"};
    ///1是表示注册验证码，2是表示找回登录密码，3是找回支付密码验证码
    
    ///网络请求
    [QSRequestManager requestDataWithType:self.requestType andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///发送成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYSendVerticalCodeReturnData *tempModel = resultData;
            
            ///回调
            if (self.sendVerticalCodeCallBack) {
                
                self.sendVerticalCodeCallBack(sSendPhoneVerticalCodeActionTypeSuccess,tempModel.msg);
                
            }
            
            ///设置发送状态为不可再发送
            self.isCanSend = NO;
            
            ///倒计时
            [self startLimitedSecond];
            
        } else {
        
            ///回调
            if (self.sendVerticalCodeCallBack) {
                
                NSString *tipsInfo = @"发送失败";
                if (resultData) {
                    
                    tipsInfo = [resultData valueForKey:@"info"];
                    
                }
                self.sendVerticalCodeCallBack(sSendPhoneVerticalCodeActionTypeFail,tipsInfo);
                
            }
            
            ///设置发送状态为可再发送
            self.isCanSend = YES;
            
            ///显示提示信息
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            self.infoLabel.text = @"重新获取";
            self.infoLabel.hidden = NO;
        
        }
        
    }];

}

#pragma mark - 开始倒计时
- (void)startLimitedSecond
{

    ///隐藏指示
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
    
    ///显示信息
    self.infoLabel.hidden = NO;
    self.infoLabel.text = [NSString stringWithFormat:@"%d秒",self.limitedTimaGap];
    self.countDown = self.limitedTimaGap;
    
    ///开启定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [timer fire];

}

///更新倒计时
- (void)countDown:(NSTimer *)timer
{
    
    ///倒计时结束
    if (self.countDown <= 0) {
        
        [timer invalidate];
        self.infoLabel.text = @"获取验证码";
        self.isCanSend = YES;
        return;
        
    }

    self.countDown = self.countDown - 1;
    self.infoLabel.text = [NSString stringWithFormat:@"%d秒",self.countDown];
    

}

@end
