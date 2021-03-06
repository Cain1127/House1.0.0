//
//  QSYSystemSettingViewController.m
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSystemSettingViewController.h"
#import "QSOpinionFeedbackViewController.h"
#import "QSYAboutUsInfoViewController.h"

#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSCoreDataManager+User.h"
#import "UIImageView+CacheImage.h"
#import "QSYSendVerticalCodeReturnData.h"

#import "QSSocketManager.h"
#import <SS-BaiduPushSDK/BPush.h>

///不过的自定义按钮tag
typedef enum
{
    
    sSettingFieldActionTypeOpinionFeedback = 99,//!<意见返馈
    sSettingFieldActionTypeRecommendScore,      //!<推荐评分
    sSettingFieldActionTypeAboutus,             //!<关于我们
    sSettingFieldActionTypeCheckVersion,        //!<版本检测
    sSettingFieldActionTypeClearCache,          //!<清空缓存
    
}SETTING_FIELD_ACTION_TYPE;

@interface QSYSystemSettingViewController () <UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation QSYSystemSettingViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"设置"];
    
}

- (void)createMainShowUI
{
    
    ///消息提醒
    UILabel *msgTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP + 64.0f, 80.0f, 44.0f)];
    msgTipsLabel.text = @"消息提醒";
    msgTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    msgTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.view addSubview:msgTipsLabel];
    
    ///开关按钮
    UISwitch *tipsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 60.0f, VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP + 64.0f + 3.0f, 60.0f, 30.0f)];
    tipsSwitch.onTintColor = COLOR_CHARACTERS_LIGHTYELLOW;
    tipsSwitch.on = YES;
    [tipsSwitch addTarget:self action:@selector(acceptSystemMessageSetting:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:tipsSwitch];
    
    ///分隔线
    UILabel *msgTipsSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgTipsLabel.frame.origin.x + 5.0f, msgTipsLabel.frame.origin.y + msgTipsLabel.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    msgTipsSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:msgTipsSepLabel];
    
    ///意见返馈
    UITextField *opinionFeedback = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, msgTipsLabel.frame.origin.y + msgTipsLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"意见返馈" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    opinionFeedback.delegate = self;
    opinionFeedback.tag = sSettingFieldActionTypeOpinionFeedback;
    [self.view addSubview:opinionFeedback];
    
    ///分隔线
    UILabel *opinionFeedbackSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(opinionFeedback.frame.origin.x + 5.0f, opinionFeedback.frame.origin.y + opinionFeedback.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    opinionFeedbackSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:opinionFeedbackSepLabel];
    
    ///推荐评分
    UITextField *recommendScore = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, opinionFeedback.frame.origin.y + opinionFeedback.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"推荐评分" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    recommendScore.delegate = self;
    recommendScore.tag = sSettingFieldActionTypeRecommendScore;
    [self.view addSubview:recommendScore];
    
    ///分隔线
    UILabel *recommendScoreSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(recommendScore.frame.origin.x + 5.0f, recommendScore.frame.origin.y + recommendScore.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    recommendScoreSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:recommendScoreSepLabel];
    
    ///关于我们
    UITextField *aboutUs = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, recommendScore.frame.origin.y + recommendScore.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"关于我们" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    aboutUs.delegate = self;
    aboutUs.tag = sSettingFieldActionTypeAboutus;
    [self.view addSubview:aboutUs];
    
    ///分隔线
    UILabel *aboutusSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(aboutUs.frame.origin.x + 5.0f, aboutUs.frame.origin.y + aboutUs.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    aboutusSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:aboutusSepLabel];
    
#if 0
    ///版本检测
    UITextField *checkVersion = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, aboutUs.frame.origin.y + aboutUs.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"版本检测" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    checkVersion.delegate = self;
    checkVersion.tag = sSettingFieldActionTypeCheckVersion;
    [self.view addSubview:checkVersion];
    
    ///分隔线
    UILabel *checkVersionSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkVersion.frame.origin.x + 5.0f, checkVersion.frame.origin.y + checkVersion.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    checkVersionSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:checkVersionSepLabel];
#endif
    
    ///清空缓存
    UITextField *clearCaches = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, aboutUs.frame.origin.y + aboutUs.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"清空缓存" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    clearCaches.delegate = self;
    clearCaches.tag = sSettingFieldActionTypeClearCache;
    [self.view addSubview:clearCaches];
    
    ///分隔线
    UILabel *clearCachesSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(clearCaches.frame.origin.x + 5.0f, clearCaches.frame.origin.y + clearCaches.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    clearCachesSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:clearCachesSepLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///退出按钮
    LOGIN_CHECK_ACTION_TYPE loginStatus = [self checkLogin];
    buttonStyle.bgColorSelected = buttonStyle.bgColor;
    buttonStyle.title = (lLoginCheckActionTypeLogined == loginStatus) ? @"退出" : @"登录";
    UIButton *logoutButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - VIEW_SIZE_NORMAL_BUTTON_HEIGHT - VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (button.selected) {
            
            [self logoutAction:button];
            
        } else {
        
            [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                
                switch (flag) {
                        ///登录后
                    case lLoginCheckActionTypeLogined:
                        
                    case lLoginCheckActionTypeReLogin:
                    {
                    
                        button.selected = YES;
                        [button setTitle:@"退出" forState:UIControlStateNormal];
                    
                    }
                        break;
                        
                    case lLoginCheckActionTypeUnLogin:
                        
                    case lLoginCheckActionTypeOffLine:
                    {
                        
                        button.selected = NO;
                        [button setTitle:@"登录" forState:UIControlStateNormal];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
        
        }
        
    }];
    logoutButton.selected = (lLoginCheckActionTypeLogined == loginStatus) ? YES : NO;
    [self.view addSubview:logoutButton];
    
}

#pragma mark - 点击不同的控件进行不同的过滤
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
            ///意见返馈
        case sSettingFieldActionTypeOpinionFeedback:
        {
            
            QSOpinionFeedbackViewController *obVC = [[QSOpinionFeedbackViewController alloc]init];
            [self.navigationController pushViewController:obVC animated:YES];
            
        }
            break;
            
            ///推荐评分
        case sSettingFieldActionTypeRecommendScore:
        {
            
            TIPS_ALERT_MESSAGE_CONFIRMBUTTON(nil,@"去给'房当家'打分吧！\n您的评价对我们很重要",@"稍后评价",@"去评价",^(int buttonIndex) {
                
                ///判断按钮事件:0取消
                if (1 == buttonIndex) {
                    
                    NSString *url = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=997682840";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    
                }
                
            })
            
        }
            break;
            
            ///关于我们
        case sSettingFieldActionTypeAboutus:
        {
            
            QSYAboutUsInfoViewController *aboutUSVC = [[QSYAboutUsInfoViewController alloc] init];
            [self.navigationController pushViewController:aboutUSVC animated:YES];
            
        }
            break;
            
            ///版本检测
        case sSettingFieldActionTypeCheckVersion:
        {
            
            __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正要检测"];
            [QSRequestManager requestDataWithType:rRequestTypeApplicationVersion andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
                
                if (rRequestResultTypeSuccess == resultStatus) {
                    
                    QSYSendVerticalCodeReturnData *tempModel = resultData;
                    
                    ///判断版本
                    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                    NSString *localVersion = [infoDic objectForKey:@"CFBundleVersion"];
                    if (![localVersion isEqualToString:tempModel.msg]) {
                        
                        ///隐藏hud
                        [hud hiddenCustomHUDWithFooterTips:@"检测完成"];
                        NSString *tipsMessage = [NSString stringWithFormat:@"发现新版本：%@",tempModel.msg];
                        TIPS_ALERT_MESSAGE_CONFIRMBUTTON(nil, tipsMessage, @"以后再说", @"立即去更新", ^(int index){
                        
                            ///马上更新
                            if (index == 1) {
                                
                                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
                                
                            }
                        
                        })
                        
                    } else {
                    
                        [hud hiddenCustomHUDWithFooterTips:@"当前已是最新版本" andDelayTime:1.5f];
                    
                    }
                    
                } else {
                
                    [hud hiddenCustomHUDWithFooterTips:@"检测失败，请稍后再试" andDelayTime:1.0f];
                
                }
                
            }];
            
        }
            break;
            
            ///清空缓存
        case sSettingFieldActionTypeClearCache:
        {
            
            ///显示HUD
            __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在清除缓存"];
            
            [UIImageView clearLoadImageCache:^(BOOL isClear) {
                
                [hud hiddenCustomHUDWithFooterTips:@"已清除" andDelayTime:1.5f];
                
            }];
            
        }
            break;
            
        default:
            
            break;
    }
    
    return NO;
    
}

#pragma mark - 是否接收系统抢着消息设置
- (void)acceptSystemMessageSetting:(UISwitch *)switchUI
{

    if (switchUI.on) {
        
        
        
    } else {
    
        
    
    }

}

#pragma mark - 退出登录
- (void)logoutAction:(UIButton *)button
{
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在退出"];
    
    ///退出登录状态
    [QSRequestManager requestDataWithType:rRequestTypeLogout andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///退出登录成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///发送退出消息
            [QSSocketManager sendOffLineMessage];
            
            [QSCoreDataManager updateLoginStatus:NO andCallBack:^(BOOL flag) {
                
                if (flag) {
                    
                    [hud hiddenCustomHUDWithFooterTips:@"退出成功"];
                    
                    if (self.systemSettingCallBack) {
                        
                        self.systemSettingCallBack(sSystemSettingActionTypeLogout,nil);
                        
                    }
                    
                    button.selected = NO;
                    [button setTitle:@"登录" forState:UIControlStateNormal];
                    
                    ///通知关注小区改变
                    [QSCoreDataManager performCoredataChangeCallBack:cCoredataDataTypeCommunityIntention andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                    
#if 1
                    ///更新百度推送的tag
                    NSString *oldUserID = [QSCoreDataManager getUserID];
                    if ([oldUserID intValue] > 0) {
                        
                        NSString *oldUseUserID = [NSString stringWithFormat:@"%@_",oldUserID];
                        [BPush delTag:APPLICATION_NSSTRING_SETTING(oldUseUserID, @"-1")];
                        [BPush setTag:@"-1"];
                        
                    }
#endif
                    
                }
                
            }];
            
        } else {
        
            NSString *tipsString = @"退出失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.0f];
        
        }
        
    }];
    
}

@end
