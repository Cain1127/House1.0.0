//
//  QSYMySettingViewController.m
//  House
//
//  Created by ysmeng on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMySettingViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"
#import "QSImageView+Block.h"

#import <objc/runtime.h>

///不过的自定义按钮tag
typedef enum
{

    sSelfSettingFieldActionTypeName = 99,   //!<姓名
    sSelfSettingFieldActionTypeSex,         //!<性别
    sSelfSettingFieldActionTypePhone,       //!<手机号码
    sSelfSettingFieldActionTypePassword,    //!<账号密码

}SELFSETTING_FIELD_ACTION_TYPE;

///关联
static char IconImageViewKey;   //!<头像关联

@interface QSYMySettingViewController () <UITextFieldDelegate>

@end

@implementation QSYMySettingViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"个人设置"];

}

- (void)createMainShowUI
{
    
    ///头像
    UILabel *msgTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 85.0f / 2.0f + 64.0f - 15.0f, 80.0f, 30.0f)];
    msgTipsLabel.text = @"头       像";
    msgTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    msgTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.view addSubview:msgTipsLabel];
    
    ///头像图片
    UIImageView *iconImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 65.0f - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + 10.0f, 65.0f, 65.0f) andSingleTapCallBack:^{
        
        ///弹出图片选择提示
        [self popPickedImageTipsView];
        
    }];
    iconImageView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_158];
    [self.view addSubview:iconImageView];
    objc_setAssociatedObject(self, &IconImageViewKey, iconImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像六角
    QSImageView *iconSixformImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconImageView.frame.size.width, iconImageView.frame.size.height)];
    iconSixformImageView.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_80];
    [iconImageView addSubview:iconSixformImageView];
    
    ///分隔线
    UILabel *iconSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgTipsLabel.frame.origin.x, iconImageView.frame.origin.y + iconImageView.frame.size.height + 10.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f)];
    iconSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:iconSepLabel];
    
    ///姓名
    UITextField *nameField = [UITextField createCustomTextFieldWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, iconSepLabel.frame.origin.y + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"姓      名" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    nameField.delegate = self;
    nameField.tag = sSelfSettingFieldActionTypeName;
    [self.view addSubview:nameField];
    
    ///分隔线
    UILabel *nameSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameField.frame.origin.x + 5.0f, nameField.frame.origin.y + nameField.frame.size.height + 3.5f, nameField.frame.size.width - 10.0f, 0.25f)];
    nameSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:nameSepLabel];
    
    ///别性
    UITextField *genderField = [UITextField createCustomTextFieldWithFrame:CGRectMake(nameField.frame.origin.x, nameField.frame.origin.y + nameField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, nameField.frame.size.width, nameField.frame.size.height) andPlaceHolder:@"" andLeftTipsInfo:@"性       别" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    genderField.delegate = self;
    genderField.tag = sSelfSettingFieldActionTypeSex;
    [self.view addSubview:genderField];
    
    ///分隔线
    UILabel *genderSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(genderField.frame.origin.x + 5.0f, genderField.frame.origin.y + genderField.frame.size.height + 3.5f, genderField.frame.size.width - 10.0f, 0.25f)];
    genderSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:genderSepLabel];
    
    ///手机
    UITextField *phoneField = [UITextField createCustomTextFieldWithFrame:CGRectMake(genderField.frame.origin.x, genderField.frame.origin.y + genderField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, genderField.frame.size.width, genderField.frame.size.height) andPlaceHolder:@"" andLeftTipsInfo:@"手机号码" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    phoneField.delegate = self;
    phoneField.tag = sSelfSettingFieldActionTypePhone;
    [self.view addSubview:phoneField];
    
    ///分隔线
    UILabel *phoneSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneField.frame.origin.x + 5.0f, phoneField.frame.origin.y + phoneField.frame.size.height + 3.5f, phoneField.frame.size.width - 10.0f, 0.25f)];
    phoneSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:phoneSepLabel];
    
    ///版本检测
    UITextField *passwordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(phoneField.frame.origin.x, phoneField.frame.origin.y + phoneField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, phoneField.frame.size.width, phoneField.frame.size.height) andPlaceHolder:@"" andLeftTipsInfo:@"账户密码" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    passwordField.delegate = self;
    passwordField.tag = sSelfSettingFieldActionTypeName;
    [self.view addSubview:passwordField];
    
    ///分隔线
    UILabel *pswSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x + 5.0f, passwordField.frame.origin.y + passwordField.frame.size.height + 3.5f, passwordField.frame.size.width - 10.0f, 0.25f)];
    pswSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:pswSepLabel];

}

#pragma mark - 点击不同的控件进行不同的过滤
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
            ///姓名
        case sSelfSettingFieldActionTypeName:
        {
        
            APPLICATION_LOG_INFO(@"姓名", @"")
        
        }
            break;
            
            ///性别
        case sSelfSettingFieldActionTypeSex:
        {
            
            APPLICATION_LOG_INFO(@"性别", @"")
            
        }
            break;
            
            ///手机
        case sSelfSettingFieldActionTypePhone:
        {
            
            APPLICATION_LOG_INFO(@"手机", @"")
            
        }
            break;
            
            ///密码
        case sSelfSettingFieldActionTypePassword:
        {
            
            APPLICATION_LOG_INFO(@"密码", @"")
            
        }
            break;
            
        default:
            
            break;
    }
    
    return NO;

}

#pragma mark - 弹出图片选择提示
- (void)popPickedImageTipsView
{

    

}

@end
