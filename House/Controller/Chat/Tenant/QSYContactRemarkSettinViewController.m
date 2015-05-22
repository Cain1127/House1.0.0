//
//  QSYContactRemarkSettinViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactRemarkSettinViewController.h"

#import "QSCustomHUDView.h"

#import "UITextField+CustomField.h"
#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYContactRemarkSettinViewController () <UITextFieldDelegate>

@property (nonatomic,copy) NSString *contactID;                         //!<联系人ID
@property (nonatomic,copy) void(^remarkContactCallBack)(BOOL isChange); //!<回调

@end

@implementation QSYContactRemarkSettinViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-13 16:04:24
 *
 *  @brief              根据联系人的ID创建备注联系人信息的页面
 *
 *  @param contactID    联系人ID
 *
 *  @return             返回当前创建的联系人备注页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID andChangeCallBack:(void(^)(BOOL isChange))callBack
{

    if (self = [super init]) {
        
        ///保存联系人ID
        self.contactID = contactID;
        
        self.remarkContactCallBack = callBack;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"备注信息"];
    
}

- (void)createMainShowUI
{

    ///备注姓名
    __block UITextField *remarkNameField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"备注名" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    remarkNameField.delegate = self;
    remarkNameField.secureTextEntry = YES;
    [self.view addSubview:remarkNameField];
    
    ///分隔线
    UILabel *remarkNameLineLable = [[UILabel alloc] initWithFrame:CGRectMake(remarkNameField.frame.origin.x + 5.0f, remarkNameField.frame.origin.y + remarkNameField.frame.size.height + 3.5f, remarkNameField.frame.size.width - 10.0f, 0.5f)];
    remarkNameLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:remarkNameLineLable];
    
    ///更多备注
    __block UITextField *moreRemarkField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, remarkNameField.frame.origin.y + remarkNameField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"更多备注信息" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    moreRemarkField.delegate = self;
    [self.view addSubview:moreRemarkField];
    
    ///分隔线
    UILabel *moreRemarkLineLable = [[UILabel alloc] initWithFrame:CGRectMake(moreRemarkField.frame.origin.x + 5.0f, moreRemarkField.frame.origin.y + moreRemarkField.frame.size.height + 3.5f, moreRemarkField.frame.size.width - 10.0f, 0.5f)];
    moreRemarkLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:moreRemarkLineLable];
    
    ///提交按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"提交";
    UIButton *loginButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 64.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///备注名
        NSString *name = remarkNameField.text;
        
        ///更多备注
        NSString *moreRemark = moreRemarkField.text;
        
        if ([name length] <= 0 && [moreRemark length] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入备注信息", 1.0f, ^(){})
            return;
            
        }
        
        ///回收键盘
        [remarkNameField resignFirstResponder];
        [moreRemarkField resignFirstResponder];
        
        ///登录事件
        [self remarkContact:name andMoreRemark:moreRemark];
        
    }];
    [self.view addSubview:loginButton];

}

#pragma mark - 备注联系人
- (void)remarkContact:(NSString *)contactName andMoreRemark:(NSString *)moreRemark
{

    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在添加备注"];
    
    ///封装参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:APPLICATION_NSSTRING_SETTING(self.contactID, @"") forKey:@"id_"];
    
    if ([contactName length] > 0) {
        
        [params setObject:contactName forKey:@"remark"];
        
    }
    
    if ([moreRemark length] > 0) {
        
        [params setObject:contactName forKey:@"more_remark"];
        
    }
    
    ///请求
    [QSRequestManager requestDataWithType:rRequestTypeChatContactInfoChange andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///备注成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"备注成功" andDelayTime:1.5f andCallBack:^(BOOL flag) {
                
                if (self.remarkContactCallBack) {
                    
                    self.remarkContactCallBack(YES);
                    
                }
                
                ///返回上一页
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
            
        } else {
        
            NSString *tipsString = @"备注失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
        
        }
        
    }];

}

@end
