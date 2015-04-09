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

#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+Collected.h"

#import "UITextField+CustomField.h"
#import "QSBlockButtonStyleModel+Normal.h"

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
            
            ///通过子线程提交收藏数据/分享数据
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self loadCollectedDataToServer];
                
            });
            
            ///修改用户登录状态
            [QSCoreDataManager updateLoginStatus:YES andCallBack:^(BOOL flag) {
                
                [QSCoreDataManager saveLoginCount:count andCallBack:^(BOOL flag) {
                    
                    [QSCoreDataManager saveLoginPassword:password andCallBack:^(BOOL flag) {
                        
                        QSYLoginReturnData *tempModel = resultData;
                        QSUserDataModel *userModel = tempModel.userInfo;
                        
                        [QSCoreDataManager saveLoginUserData:userModel andCallBack:^(BOOL flag) {
                            
                            ///显示提示信息
                            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"登录成功", 1.5f, ^(){
                                
                                ///回调
                                if (self.loginCallBack) {
                                    
                                    self.loginCallBack(lLoginCheckActionTypeReLogin);
                                    
                                }
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                
                            })
                            
                        }];
                        
                    }];
                    
                }];
                
            }];
            
        } else {
        
            NSString *tips = @"登录失败，请稍后再试";
            if (resultData) {
                
                tips = [resultData valueForKey:@"info"];
                
            }
            
            ///显示提示信息
            TIPS_ALERT_MESSAGE_ANDTURNBACK(tips, 1.5f, ^(){})
            
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

#pragma mark - 将本地的收藏/分享数据上传服务端
///将本地的收藏/分享数据上传服务端
- (void)loadCollectedDataToServer
{

    ///添加
    [self addCollectedDataToServer];
    
    ///删除
    [self deleteCollectedData];
    
}

///将本地未删除的记录，重新提交删除
- (void)deleteCollectedData
{

    [self deleteCollectedCommunity];
    [self deleteCollectedNewHouse];
    [self deleteCollectedRentHouse];
    [self deleteCollectedSecondHandHouse];

}

///删除收藏的出租房
- (void)deleteCollectedRentHouse
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
- (void)deleteCollectedNewHouse
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
- (void)deleteCollectedSecondHandHouse
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
- (void)deleteCollectedCommunity
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
- (void)addCollectedDataToServer
{

    [self addInttentionCommunityToServer];
    [self addCollectedNewHouseToServer];
    [self addCollectedRentHouseToServer];
    [self addCollectedSecondHandHouseToServer];

}

///将添加收藏的出租房，同步服务端
- (void)addCollectedRentHouseToServer
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
- (void)addCollectedNewHouseToServer
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
- (void)addCollectedSecondHandHouseToServer
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
- (void)addInttentionCommunityToServer
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
