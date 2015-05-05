//
//  QSLoginViewController.m
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSLoginViewController.h"
#import "QSYRegistViewController.h"
#import "QSYForgetPasswordViewController.h"
#import "QSWDeveloperHomeViewController.h"
#import "QSTabBarViewController.h"

#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+Collected.h"
#import "QSCoreDataManager+History.h"

#import "UITextField+CustomField.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "NSDate+Formatter.h"

#import "QSVerticalCodeView.h"
#import "QSCustomHUDView.h"

#import "QSYLoginReturnData.h"
#import "QSUserDataModel.h"
#import "QSCommunityHouseDetailDataModel.h"
#import "QSWCommunityDataModel.h"
#import "QSRentHouseDetailDataModel.h"
#import "QSWRentHouseInfoDataModel.h"
#import "QSNewHouseDetailDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSSecondHouseDetailDataModel.h"
#import "QSWSecondHouseInfoDataModel.h"
#import "QSNewHouseInfoDataModel.h"
#import "QSNewHouseListReturnData.h"
#import "QSCommunityListReturnData.h"
#import "QSSecondHandHouseListReturnData.h"
#import "QSRentHouseListReturnData.h"

#import "QSYHistoryRentHouseListReturnData.h"
#import "QSYHistorySecondHandHouseListReturnData.h"
#import "QSYHistoryNewHouseListReturnData.h"
#import "QSYHistoryListNewHouseDataModel.h"
#import "QSYHistoryListRentHouseDataModel.h"
#import "QSYHistoryListSecondHandHouseDataModel.h"
#import "QSRentHousesDetailReturnData.h"
#import "QSNewHousesDetailReturnData.h"
#import "QSSecondHousesDetailReturnData.h"

#import "QSSocketManager.h"

#import <objc/runtime.h>

///关联
static char InputLoginInfoRootViewKey;//!<所有登录信息输入框的底view

@interface QSLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,copy) void(^loginCallBack)(LOGIN_CHECK_ACTION_TYPE flag); //!<登录后的回调
@property (nonatomic,copy) NSString *verCode;               //!<生成的本地验证码

@end

@implementation QSLoginViewController

#pragma mark - 初始化
///初始化
- (instancetype)initWithCallBack:(void (^)(LOGIN_CHECK_ACTION_TYPE flag))loginCallBack
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
        
        ///进入根据手机设置密码页面
        QSYForgetPasswordViewController *forgetPasswordVC = [[QSYForgetPasswordViewController alloc] init];
        [self.navigationController pushViewController:forgetPasswordVC animated:YES];
        
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
    __block QSCustomHUDView *mbHUD = [QSCustomHUDView showCustomHUDWithTips:@"正在登录"];
    
    ///保存登录之前的用户类型
    __block USER_COUNT_TYPE originalType = [QSCoreDataManager getUserType];
    
    ///参数
    NSDictionary *params = @{@"mobile" : count,
                             @"password" : password};
    
    ///登录
    [QSRequestManager requestDataWithType:rRequestTypeLogin andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///登录成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///通过子线程提交收藏数据/分享数据
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
                ///修改用户登录状态
                [QSCoreDataManager updateLoginStatus:YES andCallBack:^(BOOL flag) {
                    
                    [QSCoreDataManager saveLoginCount:count andCallBack:^(BOOL flag) {
                        
                        [QSCoreDataManager saveLoginPassword:password andCallBack:^(BOOL flag) {
                            
                            QSYLoginReturnData *tempModel = resultData;
                            QSUserDataModel *userModel = tempModel.userInfo;
                            
                            [QSCoreDataManager saveLoginUserData:userModel andCallBack:^(BOOL flag) {
                                
                                ///隐藏HUD
                                dispatch_async(dispatch_get_main_queue(), ^{
                                
                                    [mbHUD hiddenCustomHUDWithFooterTips:@"登录成功" andDelayTime:1.5f andCallBack:^(BOOL flag) {
                                        
                                        ///新的用户类型
                                        USER_COUNT_TYPE newUserType = [userModel.user_type intValue];
                                        if (newUserType == originalType) {
                                            
                                            ///修改配置信息
                                            if (uUserCountTypeDeveloper == newUserType) {
                                                
                                                ///修改默认的用户类型
                                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_develop"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                            } else {
                                                
                                                ///修改默认的用户类型
                                                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_develop"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                            }
                                            
                                            ///回调
                                            if (self.loginCallBack) {
                                                
                                                self.loginCallBack(lLoginCheckActionTypeReLogin);
                                                
                                            }
                                            
                                            [self.navigationController popViewControllerAnimated:YES];
                                            
                                        } else {
                                            
                                            ///新的用户类型为开发商
                                            if (uUserCountTypeDeveloper == newUserType) {
                                                
                                                ///进入开发商模型
                                                QSWDeveloperHomeViewController *developerVC = [[QSWDeveloperHomeViewController alloc] init];
                                                
                                                ///修改默认的用户类型
                                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_develop"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                [self changeWindowRootViewController:developerVC];
                                                
                                            } else {
                                                
                                                if (uUserCountTypeDeveloper == originalType) {
                                                    
                                                    ///修改默认的用户类型
                                                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_develop"];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                    
                                                    ///加载tabbar控制器
                                                    QSTabBarViewController *tabbarVC = [[QSTabBarViewController alloc] initWithCurrentIndex:0];
                                                    
                                                    ///加载到rootViewController上
                                                    [self changeWindowRootViewController:tabbarVC];
                                                    
                                                } else {
                                                    
                                                    ///修改默认的用户类型
                                                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_develop"];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                    
                                                    ///回调
                                                    if (self.loginCallBack) {
                                                        
                                                        self.loginCallBack(lLoginCheckActionTypeReLogin);
                                                        
                                                    }
                                                    
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        ///重新发送上线
                                        [QSSocketManager sendOnLineMessage];
                                        
                                    }];
                                    
                                });
                             
                            }];
                            
                        }];
                        
                    }];
                    
                }];
                
            });
        
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               
                [[self class] loadHistoryDataToServer];
                [[self class] loadCollectedDataToServer];
                
            });
            
        } else {
            
            NSString *tips = @"登录失败，请稍后再试";
            if (resultData) {
                
                tips = [resultData valueForKey:@"info"];
                
            }
            
            ///显示提示信息
            [mbHUD hiddenCustomHUDWithFooterTips:tips andDelayTime:1.5f];
            
            ///修改登录状态
            [QSCoreDataManager updateLoginStatus:NO andCallBack:^(BOOL flag) {
                
                [QSCoreDataManager saveLoginCount:@"" andCallBack:^(BOOL flag) {
                    
                    [QSCoreDataManager saveLoginPassword:@"" andCallBack:^(BOOL flag) {
                        
                        
                        
                    }];
                    
                }];
                
            }];
            
        }
        
    }];
    
}

#pragma mark - 刷新本浏览记录上传服务端
/**
 *  @author yangshengmeng, 15-05-03 20:05:17
 *
 *  @brief  将本地浏览记录和服务端记录合并
 *
 *  @since  1.0.0
 */
+ (void)loadHistoryDataToServer
{

    ///添加
    [self addHistoryDataToServer];
    
    ///删除
    [self deleteHistoryData];
    
    ///下载服务端数据
    [self downloadServerHistoryData];

}

///添加本地浏览数据到服务端
+ (void)addHistoryDataToServer
{
    
    [self addHistoryNewHouseToServer];
    [self addHistorySecondHandHouseToServer];
    [self addHistoryRentHouseToServer];

}

+ (void)addHistoryNewHouseToServer
{
    
    __block NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[QSCoreDataManager getUncommitedHistoryDataSource:fFilterMainTypeNewHouse]];
    
    if (0 >= [tempArray count]) {
        
        return;
        
    }
    
    NSMutableArray *postArray = [NSMutableArray array];
    for (int i = 0; i < [tempArray count]; i++) {
        
        QSNewHouseDetailDataModel *tempModel = tempArray[i];
        NSDictionary *paramsDict = @{@"view_id" : tempModel.loupan.id_,
                                     @"view_time" : [NSDate currentDateTimeStamp],
                                     @"view_type" : @"990103"};
        [postArray addObject:paramsDict];
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"ViewLogArr" : postArray};
    
    [QSRequestManager requestDataWithType:rRequestTypeAddHistoryHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            for (int j = 0; j < [tempArray count]; j++) {
                
                QSNewHouseDetailDataModel *tempModel = tempArray[j];
                tempModel.is_syserver = @"1";
                [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeNewHouse];
                
            }
            
        } else {
        
            for (int j = 0; j < [tempArray count]; j++) {
                
                QSNewHouseDetailDataModel *tempModel = tempArray[j];
                tempModel.is_syserver = @"0";
                [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeNewHouse];
                
            }
        
        }
        
    }];

}

+ (void)addHistorySecondHandHouseToServer
{

    __block NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[QSCoreDataManager getUncommitedHistoryDataSource:fFilterMainTypeSecondHouse]];
    
    if (0 >= [tempArray count]) {
        
        return;
        
    }
    
    NSMutableArray *postArray = [NSMutableArray array];
    for (int i = 0; i < [tempArray count]; i++) {
        
        QSSecondHouseDetailDataModel *tempModel = tempArray[i];
        NSDictionary *paramsDict = @{@"view_id" : tempModel.house.id_,
                                     @"view_time" : [NSDate currentDateTimeStamp],
                                     @"view_type" : @"990105"};
        [postArray addObject:paramsDict];
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"ViewLogArr" : postArray};
    
    [QSRequestManager requestDataWithType:rRequestTypeAddHistoryHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            for (int j = 0; j < [tempArray count]; j++) {
                
                QSSecondHouseDetailDataModel *tempModel = tempArray[j];
                tempModel.is_syserver = @"1";
                [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeSecondHouse];
                
            }
            
        } else {
            
            for (int j = 0; j < [tempArray count]; j++) {
                
                QSSecondHouseDetailDataModel *tempModel = tempArray[j];
                tempModel.is_syserver = @"0";
                [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeSecondHouse];
                
            }
            
        }
        
    }];

}

+ (void)addHistoryRentHouseToServer
{

    __block NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[QSCoreDataManager getUncommitedHistoryDataSource:fFilterMainTypeRentalHouse]];
    
    if (0 >= [tempArray count]) {
        
        return;
        
    }
    
    NSMutableArray *postArray = [NSMutableArray array];
    for (int i = 0; i < [tempArray count]; i++) {
        
        QSRentHouseDetailDataModel *tempModel = tempArray[i];
        NSDictionary *paramsDict = @{@"view_id" : tempModel.house.id_,
                                     @"view_time" : [NSDate currentDateTimeStamp],
                                     @"view_type" : @"990106"};
        [postArray addObject:paramsDict];
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"ViewLogArr" : postArray};
    
    [QSRequestManager requestDataWithType:rRequestTypeAddHistoryHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            for (int j = 0; j < [tempArray count]; j++) {
                
                QSRentHouseDetailDataModel *tempModel = tempArray[j];
                tempModel.house.is_syserver = @"1";
                [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeRentalHouse];
                
            }
            
        } else {
            
            for (int j = 0; j < [tempArray count]; j++) {
                
                QSRentHouseDetailDataModel *tempModel = tempArray[j];
                tempModel.house.is_syserver = @"0";
                [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeRentalHouse];
                
            }
            
        }
        
    }];

}

+ (void)saveHistoryHouseToLocal:(id)model andHouseType:(FILTER_MAIN_TYPE)houseType
{

    [QSCoreDataManager saveHistoryDataWithModel:model andHistoryType:houseType andCallBack:^(BOOL flag) {
        
        if (flag) {
            
            APPLICATION_LOG_INFO(@"浏览记录同步服务端后保存本地", @"成功")
            
        } else {
        
            APPLICATION_LOG_INFO(@"浏览记录同步服务端后保存本地", @"失败")
        
        }
        
    }];

}

///将本地删除浏览数据同步到服务端
+ (void)deleteHistoryData
{
    
    [self deleteHistoryNewHouseData];
    [self deleteHistorySecondHandHouseData];
    [self deleteHistoryRentHouseData];
    
}

+ (void)deleteHistoryNewHouseData
{
    
    ///封装参数
    NSDictionary *params = @{@"log_type" : [NSString stringWithFormat:@"%d",fFilterMainTypeNewHouse]};
    
    [QSRequestManager requestDataWithType:rRequestTypeDeleteHistoryHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///删除成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self deleteHistoryHouseToLocal:YES andHouseType:fFilterMainTypeNewHouse];
            
        } else {
            
            [self deleteHistoryHouseToLocal:NO andHouseType:fFilterMainTypeNewHouse];
            
        }
        
    }];

}

+ (void)deleteHistorySecondHandHouseData
{
    
    ///封装参数
    NSDictionary *params = @{@"log_type" : [NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse]};
    
    [QSRequestManager requestDataWithType:rRequestTypeDeleteHistoryHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///删除成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self deleteHistoryHouseToLocal:YES andHouseType:fFilterMainTypeSecondHouse];
            
        } else {
            
            [self deleteHistoryHouseToLocal:NO andHouseType:fFilterMainTypeSecondHouse];
            
        }
        
    }];
    
}

+ (void)deleteHistoryRentHouseData
{
    
    ///封装参数
    NSDictionary *params = @{@"log_type" : [NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse]};
    
    [QSRequestManager requestDataWithType:rRequestTypeDeleteHistoryHouse andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///删除成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self deleteHistoryHouseToLocal:YES andHouseType:fFilterMainTypeRentalHouse];
            
        } else {
            
            [self deleteHistoryHouseToLocal:NO andHouseType:fFilterMainTypeRentalHouse];
            
        }
        
    }];
    
}

+ (void)deleteHistoryHouseToLocal:(BOOL)isSyServer andHouseType:(FILTER_MAIN_TYPE)houseType
{
    
    [QSCoreDataManager deleteAllHistoryDataWithType:houseType isSysServer:isSyServer];
    
}

///下载服务端浏览记录并合并到本地
+ (void)downloadServerHistoryData
{
    
    [self downloadServerHistoryNewHouseData];
    [self downloadServerHistoryRentHouseData];
    [self downloadServerHistorySecondHandHouseData];
    
}

+ (void)downloadServerHistoryNewHouseData
{

    ///封装参数
    NSDictionary *params = @{@"view_type" : @"990103",
                             @"key" : @"",
                             @"page_num" : @"9999",
                             @"now_page" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeHistoryNewHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///下载成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYHistoryNewHouseListReturnData *tempModel = resultData;
            if ([tempModel.headerData.dataList count] > 0) {
                
                for (int i = 0; i < [tempModel.headerData.dataList count]; i++) {
                    
                    QSYHistoryListNewHouseDataModel *newHouseModel = tempModel.headerData.dataList[i];
                    
                    BOOL isSave = [QSCoreDataManager checkDataIsSaveToLocal:newHouseModel.houseInfo.loupan_id andHouseType:fFilterMainTypeNewHouse];
                    
                    if (!isSave) {
                        
                        [self downloadServerHistoryNewHouseDetailData:newHouseModel.houseInfo.loupan_id andBuildingID:newHouseModel.houseInfo.loupan_building_id];
                        
                    }
                    
                }
                
            } else {
            
                APPLICATION_LOG_INFO(@"下载服务端浏览新房信息", @"服务端数据为空")
            
            }
            
        } else {
        
            APPLICATION_LOG_INFO(@"下载服务端浏览新房信息", @"失败")
        
        }
        
    }];

}

+ (void)downloadServerHistoryNewHouseDetailData:(NSString *)detailID andBuildingID:(NSString *)buildingID
{

    ///封装参数
    NSDictionary *params = @{@"loupan_id" : detailID,
                             @"loupan_building_id" : buildingID};
    
    [QSRequestManager requestDataWithType:rRequestTypeNewHouseDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSNewHousesDetailReturnData *returnModel = resultData;
            QSNewHouseDetailDataModel *tempModel = returnModel.detailInfo;
            tempModel.is_syserver = @"1";
            [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeNewHouse];
            
        } else {
        
            APPLICATION_LOG_INFO(@"下载新房详情", @"失败")
        
        }
        
    }];

}

+ (void)downloadServerHistoryRentHouseData
{
    
    ///封装参数
    NSDictionary *params = @{@"view_type" : @"990106",
                             @"key" : @"",
                             @"page_num" : @"9999",
                             @"now_page" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeHistoryRentHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///下载成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYHistoryRentHouseListReturnData *tempModel = resultData;
            if ([tempModel.headerData.dataList count] > 0) {
                
                for (int i = 0; i < [tempModel.headerData.dataList count]; i++) {
                    
                    QSYHistoryListRentHouseDataModel *rentHouseModel = tempModel.headerData.dataList[i];
                    
                    BOOL isSave = [QSCoreDataManager checkDataIsSaveToLocal:rentHouseModel.view_id andHouseType:fFilterMainTypeRentalHouse];
                    
                    if (!isSave) {
                        
                        [self downloadServerHistoryRentHouseDetailData:rentHouseModel.view_id];
                        
                    }
                
                }
                
            } else {
                
                APPLICATION_LOG_INFO(@"下载服务端浏览出租房信息", @"服务端数据为空")
                
            }
            
        } else {
            
            APPLICATION_LOG_INFO(@"下载服务端浏览出租房信息", @"失败")
            
        }
        
    }];
    
}

+ (void)downloadServerHistoryRentHouseDetailData:(NSString *)detailID
{

    ///封装参数
    NSDictionary *params = @{@"id_" : detailID};
    
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouseDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSRentHousesDetailReturnData *returnModel = resultData;
            QSRentHouseDetailDataModel *tempModel = returnModel.detailInfo;
            tempModel.house.is_syserver = @"1";
            [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeRentalHouse];
            
        } else {
            
            APPLICATION_LOG_INFO(@"下载出租房详情", @"失败")
            
        }
        
    }];

}

+ (void)downloadServerHistorySecondHandHouseData
{
    
    ///封装参数
    NSDictionary *params = @{@"view_type" : @"990105",
                             @"key" : @"",
                             @"page_num" : @"9999",
                             @"now_page" : @"1"};
    
    [QSRequestManager requestDataWithType:rRequestTypeHistorySecondHandHouseList andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///下载成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYHistorySecondHandHouseListReturnData *tempModel = resultData;
            if ([tempModel.headerData.dataList count] > 0) {
                
                for (int i = 0; i < [tempModel.headerData.dataList count]; i++) {
                    
                    QSYHistoryListSecondHandHouseDataModel *secondHouseModel = tempModel.headerData.dataList[i];
                    
                    BOOL isSave = [QSCoreDataManager checkDataIsSaveToLocal:secondHouseModel.view_id andHouseType:fFilterMainTypeSecondHouse];
                    
                    if (!isSave) {
                        
                        [self downloadServerHistorySecondHandHouseDetailData:secondHouseModel.view_id];
                        
                    }
                    
                }
                
            } else {
                
                APPLICATION_LOG_INFO(@"下载服务端浏览二手房信息", @"服务端数据为空")
                
            }
            
        } else {
            
            APPLICATION_LOG_INFO(@"下载服务端浏览新二手房信息", @"失败")
            
        }
        
    }];
    
}

+ (void)downloadServerHistorySecondHandHouseDetailData:(NSString *)detailID
{

    ///封装参数
    NSDictionary *params = @{@"id_" : detailID,};
    
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSSecondHousesDetailReturnData *returnModel = resultData;
            QSSecondHouseDetailDataModel *tempModel = returnModel.detailInfo;
            tempModel.is_syserver = @"1";
            [self saveHistoryHouseToLocal:tempModel andHouseType:fFilterMainTypeSecondHouse];
            
        } else {
            
            APPLICATION_LOG_INFO(@"下载二手房详情", @"失败")
            
        }
        
    }];

}

#pragma mark - 将本地的收藏/分享数据上传服务端
///将本地的收藏/分享数据上传服务端
+ (void)loadCollectedDataToServer
{
    
    ///添加
    [self addCollectedDataToServer];
    
    ///删除
    [self deleteCollectedData];
    
    ///下载同步服务端数据：保证本地的数据先上传服务端再获取最新数据，所以放在本地数据上传服务端之后再执行
    [self downloadServerCollectedData];
    
}

///下载服务端收藏信息
+ (void)downloadServerCollectedData
{
    
    dispatch_group_t downloadGroup = dispatch_group_create();
    dispatch_apply(4, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i){
        
        ///参数
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"999" forKey:@"page_num"];
        [params setObject:@"1" forKey:@"now_page"];
        
        ///请求类型
        __block REQUEST_TYPE requestType;
        
        switch (i) {
                ///新房
            case 0:
            {
                
                [params setObject:[NSString stringWithFormat:@"%d",fFilterMainTypeNewHouse] forKey:@"type"];
                requestType = rRequestTypeMyZoneCollectedNewHouseList;
                
            }
                break;
                
                ///小区
            case 1:
            {
                
                [params setObject:[NSString stringWithFormat:@"%d",fFilterMainTypeCommunity] forKey:@"type"];
                requestType = rRequestTypeMyZoneIntentionCommunityList;
                
            }
                break;
                
                ///二手房
            case 2:
            {
                
                [params setObject:[NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse] forKey:@"type"];
                requestType = rRequestTypeMyZoneCollectedSecondHouseList;
                
            }
                break;
                
                ///出租房
            case 3:
            {
                
                [params setObject:[NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse] forKey:@"type"];
                requestType = rRequestTypeMyZoneCollectedRentHouseList;
                
            }
                break;
                
            default:
                break;
                
        }
        
        dispatch_group_enter(downloadGroup);
        
        ///下载数据
        [QSRequestManager requestDataWithType:requestType andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///判断请求
            switch (requestType) {
                    ///新房请求
                case rRequestTypeMyZoneCollectedNewHouseList:
                {
                
                    if (rRequestResultTypeSuccess == resultStatus) {
                        
                        QSNewHouseListReturnData *tempModel = resultData;
                        [self saveServerCollectedNewHouse:tempModel.headerData.houseList];
                        
                    } else {
                    
                        APPLICATION_LOG_INFO(@"下载服务端收藏新房数据", @"失败")
                    
                    }
                
                }
                    break;
                    
                    ///小区请求
                case rRequestTypeMyZoneIntentionCommunityList:
                {
                    
                    if (rRequestResultTypeSuccess == resultStatus) {
                        
                        QSCommunityListReturnData *tempModel = resultData;
                        [self saveServerIntentionCommunity:tempModel.communityListHeaderData.communityList];
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"下载服务端关注小区数据", @"失败")
                        
                    }
                    
                }
                    break;
                    
                    ///二手房请求
                case rRequestTypeMyZoneCollectedSecondHouseList:
                {
                    
                    if (rRequestResultTypeSuccess == resultStatus) {
                        
                        QSSecondHandHouseListReturnData *tempModel = resultData;
                        [self saveServerCollectedSecondHandHouse:tempModel.secondHandHouseHeaderData.houseList];
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"下载服务端收藏二手房数据", @"失败")
                        
                    }
                    
                }
                    break;
                    
                    ///出租房请求
                case rRequestTypeMyZoneCollectedRentHouseList:
                {
                    
                    if (rRequestResultTypeSuccess == resultStatus) {
                        
                        QSRentHouseListReturnData *tempModel = resultData;
                        [self saveServerCollectedRentHouse:tempModel.headerData.rentHouseList];
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"下载服务端收藏出租房数据", @"失败")
                        
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            ///离开队列
            dispatch_group_leave(downloadGroup);
            
        }];
        
    });
    
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        
        ///所有任务完成
        APPLICATION_LOG_INFO(@"同步网络上的收藏数据", @"同步完成")
        
    });

}

///保存服务端关注小区
+ (void)saveServerIntentionCommunity:(NSArray *)tempServerArray
{

    if ([tempServerArray count] <= 0) {
        
        return;
        
    }
    
    ///查找本地是否已存在对应收藏
    for (int i = 0;i < [tempServerArray count];i++) {
        
        QSCommunityDataModel *serverModel = tempServerArray[i];
        serverModel.is_syserver = @"1";
        [QSCoreDataManager saveCollectedDataWithModel:serverModel andCollectedType:fFilterMainTypeCommunity andCallBack:^(BOOL flag) {
            
            ///保存成功
            if (flag) {
                
                APPLICATION_LOG_INFO(@"添加关注小区->服务端数据更新本地数据", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加关注小区->服务端数据更新本地数据", @"失败")
                
            }
            
        }];
        
    }

}

///保存服务端收藏出租房
+ (void)saveServerCollectedRentHouse:(NSArray *)tempServerArray
{

    if ([tempServerArray count] <= 0) {
        
        return;
        
    }
    
    ///查找本地是否已存在对应收藏
    for (int i = 0;i < [tempServerArray count];i++) {
        
        QSRentHouseInfoDataModel *serverModel = tempServerArray[i];
        serverModel.is_syserver = @"1";
        [QSCoreDataManager saveCollectedDataWithModel:serverModel andCollectedType:fFilterMainTypeRentalHouse andCallBack:^(BOOL flag) {
            
            ///保存成功
            if (flag) {
                
                APPLICATION_LOG_INFO(@"添加出租房收藏->服务端数据更新本地数据", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加出租房收藏->服务端数据更新本地数据", @"失败")
                
            }
            
        }];
        
    }

}

///保存服务端收藏二手房
+ (void)saveServerCollectedSecondHandHouse:(NSArray *)tempServerArray
{

    if ([tempServerArray count] <= 0) {
        
        return;
        
    }
    
    ///查找本地是否已存在对应收藏
    for (int i = 0;i < [tempServerArray count];i++) {
        
        QSHouseInfoDataModel *serverModel = tempServerArray[i];
        serverModel.is_syserver = @"1";
        [QSCoreDataManager saveCollectedDataWithModel:serverModel andCollectedType:fFilterMainTypeSecondHouse andCallBack:^(BOOL flag) {
            
            ///保存成功
            if (flag) {
                
                APPLICATION_LOG_INFO(@"添加二手房收藏->服务端数据更新本地数据", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加二手房收藏->服务端数据更新本地数据", @"失败")
                
            }
            
        }];
        
    }

}

///保存服务端新房
+ (void)saveServerCollectedNewHouse:(NSArray *)tempServerArray
{

    if ([tempServerArray count] <= 0) {
        
        return;
        
    }
    
    ///查找本地是否已存在对应收藏
    for (int i = 0;i < [tempServerArray count];i++) {
        
        QSNewHouseInfoDataModel *serverModel = tempServerArray[i];
        serverModel.is_syserver = @"1";
        [QSCoreDataManager saveCollectedDataWithModel:serverModel andCollectedType:fFilterMainTypeNewHouse andCallBack:^(BOOL flag) {
            
            ///保存成功
            if (flag) {
                
                APPLICATION_LOG_INFO(@"添加新房收藏->服务端数据更新本地数据", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加新房收藏->服务端数据更新本地数据", @"失败")
                
            }
            
        }];
        
    }

}

///将本地未删除的记录，重新提交删除
+ (void)deleteCollectedData
{
    
    [self deleteCollectedCommunity];
    [self deleteCollectedNewHouse];
    [self deleteCollectedRentHouse];
    [self deleteCollectedSecondHandHouse];
    
}

///删除收藏的出租房
+ (void)deleteCollectedRentHouse
{
    
    NSArray *deleteArray = [QSCoreDataManager getDeleteUnCommitedCollectedDataSoucre:fFilterMainTypeRentalHouse];
    
    for (QSRentHouseDetailDataModel *obj in deleteArray) {
        
        ///封装参数
        NSDictionary *params = @{@"obj_id" : obj.house.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse]};
        
        [QSRequestManager requestDataWithType:rRequestTypeRentalHouseDeleteCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///同步服务端成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                APPLICATION_LOG_INFO(@"取消出租房收藏->同步服务端", @"成功")
                
                [QSCoreDataManager deleteCollectedDataWithID:obj.house.id_ isSyServer:YES andCollectedType:fFilterMainTypeRentalHouse andCallBack:^(BOOL flag) {
                    
                    ///保存成功
                    if (flag) {
                        
                        APPLICATION_LOG_INFO(@"取消出租房收藏->同步服务端->删除本地记录", @"成功")
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"取消出租房收藏->同步服务端->删除本地记录", @"失败")
                        
                    }
                    
                }];
                
            } else {
                
                APPLICATION_LOG_INFO(@"取消出租房收藏->同步服务端", @"失败")
                
            }
            
        }];
        
    }
    
}

///删除收藏的新房
+ (void)deleteCollectedNewHouse
{
    
    NSArray *deleteArray = [QSCoreDataManager getDeleteUnCommitedCollectedDataSoucre:fFilterMainTypeNewHouse];
    
    for (QSNewHouseDetailDataModel *obj in deleteArray) {
        
        ///封装参数
        NSDictionary *params = @{@"obj_id" : obj.loupan.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeNewHouse]};
        
        [QSRequestManager requestDataWithType:rRequestTypeNewHouseDeleteCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///同步服务端成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                APPLICATION_LOG_INFO(@"取消新房收藏->同步服务端", @"成功")
                
                [QSCoreDataManager deleteCollectedDataWithID:obj.loupan.id_ isSyServer:YES andCollectedType:fFilterMainTypeNewHouse andCallBack:^(BOOL flag) {
                    
                    ///保存成功
                    if (flag) {
                        
                        APPLICATION_LOG_INFO(@"取消新房收藏->同步服务端->删除本地记录", @"成功")
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"取消新房收藏->同步服务端->删除本地记录", @"失败")
                        
                    }
                    
                }];
                
            } else {
                
                APPLICATION_LOG_INFO(@"取消新房收藏->同步服务端", @"失败")
                
            }
            
        }];
        
    }
    
}

///删除收藏的二手房
+ (void)deleteCollectedSecondHandHouse
{
    
    NSArray *deleteArray = [QSCoreDataManager getDeleteUnCommitedCollectedDataSoucre:fFilterMainTypeSecondHouse];
    
    for (QSSecondHouseDetailDataModel *obj in deleteArray) {
        
        ///封装参数
        NSDictionary *params = @{@"obj_id" : obj.house.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse]};
        
        [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseDeleteCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///同步服务端成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                APPLICATION_LOG_INFO(@"取消二手房收藏->同步服务端", @"成功")
                
                [QSCoreDataManager deleteCollectedDataWithID:obj.house.id_ isSyServer:YES andCollectedType:fFilterMainTypeSecondHouse andCallBack:^(BOOL flag) {
                    
                    ///保存成功
                    if (flag) {
                        
                        APPLICATION_LOG_INFO(@"取消二手房收藏->同步服务端->删除本地记录", @"成功")
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"取消二手房收藏->同步服务端->删除本地记录", @"失败")
                        
                    }
                    
                }];
                
            } else {
                
                APPLICATION_LOG_INFO(@"取消二手房收藏->同步服务端", @"失败")
                
            }
            
        }];
        
    }
    
}

///删除关注的小区
+ (void)deleteCollectedCommunity
{
    
    NSArray *deleteArray = [QSCoreDataManager getDeleteUnCommitedCollectedDataSoucre:fFilterMainTypeCommunity];
    
    for (QSCommunityHouseDetailDataModel *obj in deleteArray) {
        
        ///封装参数
        NSDictionary *params = @{@"obj_id" : obj.village.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeCommunity]};
        
        [QSRequestManager requestDataWithType:rRequestTypeCommunityDeleteIntention andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///同步服务端成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                APPLICATION_LOG_INFO(@"取消小区关注->同步服务端", @"成功")
                
                [QSCoreDataManager deleteCollectedDataWithID:obj.village.id_ isSyServer:YES andCollectedType:fFilterMainTypeCommunity andCallBack:^(BOOL flag) {
                    
                    ///保存成功
                    if (flag) {
                        
                        APPLICATION_LOG_INFO(@"取消小区关注->同步服务端->删除本地记录", @"成功")
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"取消小区关注->同步服务端->删除本地记录", @"失败")
                        
                    }
                    
                }];
                
            } else {
                
                APPLICATION_LOG_INFO(@"取消小区关注->同步服务端", @"失败")
                
            }
            
        }];
        
    }
    
}

///将本地未提交服务端的收藏/分享上传服务端
+ (void)addCollectedDataToServer
{
    
    [self addInttentionCommunityToServer];
    [self addCollectedNewHouseToServer];
    [self addCollectedRentHouseToServer];
    [self addCollectedSecondHandHouseToServer];
    
}

///将添加收藏的出租房，同步服务端
+ (void)addCollectedRentHouseToServer
{
    
    ///出租房
    NSArray *communityList = [QSCoreDataManager getUncommitedCollectedDataSource:fFilterMainTypeRentalHouse];
    
    ///发送到服务端
    for (QSRentHouseDetailDataModel *obj in communityList) {
        
        ///参数
        NSDictionary *params = @{@"obj_id" : obj.house.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse]};
        
        [QSRequestManager requestDataWithType:rRequestTypeRentalHouseCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///添加成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                APPLICATION_LOG_INFO(@"添加出租房收藏->同步服务端", @"成功")
                
                obj.house.is_syserver = @"1";
                [QSCoreDataManager saveCollectedDataWithModel:obj andCollectedType:fFilterMainTypeRentalHouse andCallBack:^(BOOL flag) {
                    
                    ///保存成功
                    if (flag) {
                        
                        APPLICATION_LOG_INFO(@"添加出租房收藏->同步服务端->更新本地状态", @"成功")
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"添加出租房收藏->同步服务端->更新本地状态", @"失败")
                        
                    }
                    
                }];
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加出租房收藏->同步服务端", @"失败")
                
            }
            
        }];
        
    }
    
}

///将收藏的新房同步服务端
+ (void)addCollectedNewHouseToServer
{
    
    NSArray *communityList = [QSCoreDataManager getUncommitedCollectedDataSource:fFilterMainTypeNewHouse];
    
    ///发送到服务端
    for (QSNewHouseDetailDataModel *obj in communityList) {
        
        ///参数
        NSDictionary *params = @{@"obj_id" : obj.loupan.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeNewHouse]};
        
        [QSRequestManager requestDataWithType:rRequestTypeNewHouseCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///添加成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                APPLICATION_LOG_INFO(@"添加新房收藏->同步服务端", @"成功")
                
                obj.is_syserver = @"1";
                [QSCoreDataManager saveCollectedDataWithModel:obj andCollectedType:fFilterMainTypeNewHouse andCallBack:^(BOOL flag) {
                    
                    ///保存成功
                    if (flag) {
                        
                        APPLICATION_LOG_INFO(@"添加新房收->同步服务端->更新本地状态", @"成功")
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"添加新房收->同步服务端->更新本地状态", @"失败")
                        
                    }
                    
                }];
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加新房收->同步服务端", @"失败")
                
            }
            
        }];
        
    }
    
}

///将新收藏的二手房同步服务端
+ (void)addCollectedSecondHandHouseToServer
{
    
    NSArray *communityList = [QSCoreDataManager getUncommitedCollectedDataSource:fFilterMainTypeSecondHouse];
    
    ///发送到服务端
    for (QSSecondHouseDetailDataModel *obj in communityList) {
        
        ///参数
        NSDictionary *params = @{@"obj_id" : obj.house.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeSecondHouse]};
        
        [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///添加成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                APPLICATION_LOG_INFO(@"添加二手房收藏->同步服务端", @"成功")
                
                obj.is_syserver = @"1";
                [QSCoreDataManager saveCollectedDataWithModel:obj andCollectedType:fFilterMainTypeSecondHouse andCallBack:^(BOOL flag) {
                    
                    ///保存成功
                    if (flag) {
                        
                        APPLICATION_LOG_INFO(@"添加二手房收藏->同步服务端->更新本地状态", @"成功")
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"添加二手房收藏->同步服务端->更新本地状态", @"失败")
                        
                    }
                    
                }];
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加二手房收藏->同步服务端", @"失败")
                
            }
            
        }];
        
    }
    
}

///将添加的关注小区，同步服务端
+ (void)addInttentionCommunityToServer
{
    
    ///小区
    NSArray *communityList = [QSCoreDataManager getUncommitedCollectedDataSource:fFilterMainTypeCommunity];
    
    ///发送到服务端
    for (QSCommunityHouseDetailDataModel *obj in communityList) {
        
        ///参数
        NSDictionary *params = @{@"obj_id" : obj.village.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeCommunity]};
        
        [QSRequestManager requestDataWithType:rRequestTypeCommunityIntention andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///添加成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                APPLICATION_LOG_INFO(@"添加关注小区->同步服务端", @"成功")
                
                obj.is_syserver = @"1";
                [QSCoreDataManager saveCollectedDataWithModel:obj andCollectedType:fFilterMainTypeCommunity andCallBack:^(BOOL flag) {
                    
                    ///保存成功
                    if (flag) {
                        
                        APPLICATION_LOG_INFO(@"添加关注小区->同步服务端->更新本地状态", @"成功")
                        
                    } else {
                        
                        APPLICATION_LOG_INFO(@"添加关注小区->同步服务端->更新本地状态", @"失败")
                        
                    }
                    
                }];
                
            } else {
                
                APPLICATION_LOG_INFO(@"添加关注小区->同步服务端", @"失败")
                
            }
            
        }];
        
    }
    
}

@end
