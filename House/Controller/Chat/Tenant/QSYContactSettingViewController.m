//
//  QSYContactSettingViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactSettingViewController.h"
#import "QSYContactRemarkSettinViewController.h"
#import "QSYContactComplaintViewController.h"

#import "QSCustomHUDView.h"

#import "UITextField+CustomField.h"
#import "QSBlockButtonStyleModel+Normal.h"

///不过的自定义按钮tag
typedef enum
{
    
    cContactSettingFieldActionTypeComplaint = 99,   //!<投诉举报
    cContactSettingFieldActionTypeMessageDisturb,   //!<消息免打扰
    cContactSettingFieldActionTypeBlacklist,        //!<黑名单
    cContactSettingFieldActionTypeRemark,           //!<备注
    
}CONTACT_SETTING_FIELD_ACTION_TYPE;

@interface QSYContactSettingViewController () <UITextFieldDelegate>

@property (nonatomic,copy) NSString *contactID;     //!<联系人ID
@property (nonatomic,copy) NSString *contactName;   //!<联系人姓名
@property (nonatomic,copy) NSString *isFriends;     //!<是否当前用户的联系人
@property (nonatomic,copy) NSString *isImport;      //!<是否重点联系人

///联系人相关的设置变动时回调
@property (nonatomic,copy) void(^contactInfoChangeCallBack)(CONTACT_SETTING_CALLBACK_ACTION_TYPE actionType,id params);

@end

@implementation QSYContactSettingViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-13 15:04:00
 *
 *  @brief              根据联系人的ID，创建联系人信息设置页面
 *
 *  @param contactID    联系人ID
 *  @param contactName  联系人名
 *  @param isFriend     是否是当前用户的联系人
 *  @param isImport     是否是重点联系人
 *  @param callBack     联系人的部分设置回调：如添加成为联系人
 *
 *  @return             返回当前创建的联系人设置页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID andContactName:(NSString *)contactName isFriends:(NSString *)isFriend isImport:(NSString *)isImport andCallBack:(void(^)(CONTACT_SETTING_CALLBACK_ACTION_TYPE actionType,id params))callBack
{

    if (self = [super init]) {
        
        ///保存投诉人的ID
        self.contactID = contactID;
        self.contactName = contactName;
        self.isFriends = isFriend;
        self.isImport = isImport;
        
        ///保存回调
        if (callBack) {
            
            self.contactInfoChangeCallBack = callBack;
            
        }
        
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"资料设置"];

}

- (void)createMainShowUI
{

    [super createMainShowUI];
    
    ///投诉举报
    UITextField *complaintField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP + 64.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andPlaceHolder:@"" andLeftTipsInfo:@"举报投诉" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    complaintField.delegate = self;
    complaintField.tag = cContactSettingFieldActionTypeComplaint;
    [self.view addSubview:complaintField];
    
    ///分隔线
    UILabel *complaintSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(complaintField.frame.origin.x + 5.0f, complaintField.frame.origin.y + complaintField.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    complaintSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:complaintSepLabel];
    
    ///重点关注
    UILabel *msgTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, complaintSepLabel.frame.origin.y + complaintSepLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, 80.0f, 44.0f)];
    msgTipsLabel.text = @"重点关注";
    msgTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    msgTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.view addSubview:msgTipsLabel];
    
    ///开关按钮
    UISwitch *tipsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 60.0f, msgTipsLabel.frame.origin.y + 3.0f, 60.0f, 30.0f)];
    tipsSwitch.onTintColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [tipsSwitch addTarget:self action:@selector(setContactImport:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:tipsSwitch];
    
    ///判断是否是当前用户的重点关注人
    if (1 == [self.isImport intValue]) {
        
        tipsSwitch.on = YES;
        
    } else {
    
        tipsSwitch.on = NO;
    
    }
    
    ///分隔线
    UILabel *msgTipsSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgTipsLabel.frame.origin.x + 5.0f, msgTipsLabel.frame.origin.y + msgTipsLabel.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    msgTipsSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:msgTipsSepLabel];
    
    ///消息免打扰
    UITextField *disturbMessageField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, msgTipsLabel.frame.origin.y + msgTipsLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"消息免打扰" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    disturbMessageField.delegate = self;
    disturbMessageField.tag = cContactSettingFieldActionTypeMessageDisturb;
    [self.view addSubview:disturbMessageField];
    
    ///分隔线
    UILabel *disturbMessageSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(disturbMessageField.frame.origin.x + 5.0f, disturbMessageField.frame.origin.y + disturbMessageField.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    disturbMessageSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:disturbMessageSepLabel];
    
    ///黑名单
    UITextField *bloackListField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, disturbMessageField.frame.origin.y + disturbMessageField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"黑名单用户" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    bloackListField.delegate = self;
    bloackListField.tag = cContactSettingFieldActionTypeBlacklist;
    [self.view addSubview:bloackListField];
    
    ///分隔线
    UILabel *bloackListSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(bloackListField.frame.origin.x + 5.0f, bloackListField.frame.origin.y + bloackListField.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    bloackListSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:bloackListSepLabel];
    
    ///备注设置
    UITextField *remarkField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, bloackListField.frame.origin.y + bloackListField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"备注设置" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    remarkField.delegate = self;
    remarkField.tag = cContactSettingFieldActionTypeRemark;
    [self.view addSubview:remarkField];
    
    ///分隔线
    UILabel *remarkSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(remarkField.frame.origin.x + 5.0f, remarkField.frame.origin.y + remarkField.frame.size.height + 3.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
    remarkSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:remarkSepLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///退出按钮
    if ([self.isFriends intValue] > 0) {
        
        buttonStyle.title = @"删除联系人";
        
    } else {
    
        buttonStyle.title = @"添加联系人";
    
    }
    UIButton *logoutButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - VIEW_SIZE_NORMAL_BUTTON_HEIGHT - VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if ([self.isFriends intValue] > 0) {
            
            [self deleteContactAsContact:button];
            
        } else {
        
            [self addContactAsContact:button];
        
        }
        
    }];
    [self.view addSubview:logoutButton];

}

#pragma mark - 设置是否重点联系人开关事件
- (void)setContactImport:(UISwitch *)onView
{

    ///如若不是当前用户的联系人，则不能进行备注操作
    if ([self.isFriends intValue] > 0) {
        
        if ([self.isImport intValue] == 1) {
            
            [self setContactAsUNImprt:onView];
            
        } else {
        
            [self setContactAsImprt:onView];
        
        }
        
    } else {
        
        NSString *tipsString = [NSString stringWithFormat:@"%@ 并不是您的联系人，请先添加联系人",self.contactName];
        TIPS_ALERT_MESSAGE_ANDTURNBACK(tipsString, 1.0f, ^(){})
        
    }

}

#pragma mark - 通过textField的代理，分发不同的事件
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    switch (textField.tag) {
            ///投诉
        case cContactSettingFieldActionTypeComplaint:
        {
        
            QSYContactComplaintViewController *complainVC = [[QSYContactComplaintViewController alloc] initWithContactID:self.contactID andContactName:self.contactName];
            [self.navigationController pushViewController:complainVC animated:YES];
        
        }
            break;
            
            ///消息免打扰
        case cContactSettingFieldActionTypeMessageDisturb:
        {
        
            
        
        }
            break;
            
            ///黑名单
        case cContactSettingFieldActionTypeBlacklist:
        {
        
            
        
        }
            break;
            
            ///备注
        case cContactSettingFieldActionTypeRemark:
        {
        
            ///如若不是当前用户的联系人，则不能进行备注操作
            if ([self.isFriends intValue] > 0) {
                
                QSYContactRemarkSettinViewController *remarkVC = [[QSYContactRemarkSettinViewController alloc] initWithContactID:self.contactID andChangeCallBack:^(BOOL isChange) {
                    
                    if (isChange) {
                        
                        if (self.contactInfoChangeCallBack) {
                            
                            self.contactInfoChangeCallBack(cContactSettingCallBackActionTypeRemarkContact,nil);
                            
                        }
                        
                    }
                    
                }];
                [self.navigationController pushViewController:remarkVC animated:YES];
                
            } else {
            
                NSString *tipsString = [NSString stringWithFormat:@"%@ 并不是您的联系人，无法添加备注",self.contactName];
                TIPS_ALERT_MESSAGE_ANDTURNBACK(tipsString, 1.0f, ^(){})
            
            }
        
        }
            break;
            
        default:
            break;
    }
    return NO;

}

#pragma mark - 删除联系人
- (void)deleteContactAsContact:(UIButton *)addButton
{

    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在删除"];
    
    ///封装参数
    NSDictionary *params = @{@"id_" : APPLICATION_NSSTRING_SETTING(self.isFriends, @"")};
    
    ///添加联系人
    [QSRequestManager requestDataWithType:rRequestTypeChatContactDelete andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///添加成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改按钮状态
            [addButton setTitle:@"添加联系人" forState:UIControlStateNormal];
            [hud hiddenCustomHUDWithFooterTips:@"删除成功" andDelayTime:1.5f];
            
            ///回调
            if (self.contactInfoChangeCallBack) {
                
                self.isFriends = @"0";
                self.contactInfoChangeCallBack(cContactSettingCallBackActionTypeDeleteContact,nil);
                
            }
            
        } else {
            
            NSString *tipsString = @"删除失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [addButton setTitle:@"删除联系人" forState:UIControlStateNormal];
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];

}

#pragma mark - 添加联系人
- (void)addContactAsContact:(UIButton *)addButton
{

    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在添加"];
    
    ///封装参数
    NSDictionary *params = @{@"linkman_id" : APPLICATION_NSSTRING_SETTING(self.contactID, @""),
                             @"remark" : @"",
                             @"more_remark" : @""};
    
    ///添加联系人
    [QSRequestManager requestDataWithType:rRequestTypeChatContactAdd andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///添加成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改按钮状态
            [addButton setTitle:@"删除联系人" forState:UIControlStateNormal];
            [hud hiddenCustomHUDWithFooterTips:@"添加成功" andDelayTime:1.5f];
            
            ///回调
            if (self.contactInfoChangeCallBack) {
                
                self.isFriends = [resultData valueForKey:@"msg"];
                self.contactInfoChangeCallBack(cContactSettingCallBackActionTypeAddContact,[resultData valueForKey:@"msg"]);
                
            }
            
        } else {
            
            NSString *tipsString = @"添加失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [addButton setTitle:@"添加联系人" forState:UIControlStateNormal];
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];

}

#pragma mark - 将联系人设置为重点联系人
- (void)setContactAsImprt:(UISwitch *)onSwitch
{
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在添加"];
    
    ///封装参数
    NSDictionary *params = @{@"id_" : APPLICATION_NSSTRING_SETTING(self.isFriends, @""),
                             @"is_import" : @"1"};
    
    ///添加联系人
    [QSRequestManager requestDataWithType:rRequestTypeChatContactInfoChange andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///添加成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改按钮状态
            onSwitch.on = YES;
            self.isImport = @"1";
            [hud hiddenCustomHUDWithFooterTips:@"添加成功" andDelayTime:1.5f];
            
            if (self.contactInfoChangeCallBack) {
                
                self.contactInfoChangeCallBack(cContactSettingCallBackActionTypeSetImport,nil);
                
            }
            
        } else {
            
            NSString *tipsString = @"添加失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            onSwitch.on = NO;
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];
    
}

- (void)setContactAsUNImprt:(UISwitch *)onView
{

    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在删除"];
    
    ///封装参数
    NSDictionary *params = @{@"id_" : APPLICATION_NSSTRING_SETTING(self.isFriends, @""),
                             @"is_import" : @"0"};
    
    ///添加联系人
    [QSRequestManager requestDataWithType:rRequestTypeChatContactInfoChange andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///添加成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改按钮状态
            onView.on = NO;
            self.isImport = @"0";
            [hud hiddenCustomHUDWithFooterTips:@"删除成功" andDelayTime:1.5f];
            
            if (self.contactInfoChangeCallBack) {
                
                self.contactInfoChangeCallBack(cContactSettingCallBackActionTypeSetUNImport,nil);
                
            }
            
        } else {
            
            NSString *tipsString = @"删除失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];

}

@end
