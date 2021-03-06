//
//  QSYContactInfoView.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactInfoView.h"

#import "QSCustomHUDView.h"

#import "NSString+Calculation.h"

#import "QSYContactDetailInfoModel.h"

#import "QSRequestManager.h"

#import <objc/runtime.h>

///关联
static char IconKey;        //!<用户头像
static char UserNameKey;    //!<用户名
static char VIPFlagKey;     //!<vip标识
static char CreditTagKey;   //!<信息说明
static char AddContactKey;  //!<添加联系人
static char PhoneInfoKey;   //!<联系信息

@interface QSYContactInfoView ()

@property (nonatomic,copy) NSString *linkManID;//!<联系人ID

@end

@implementation QSYContactInfoView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///创建UI
        [self createContactInfoUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createContactInfoUI
{

    ///头像
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    iconView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    [self addSubview:iconView];
    objc_setAssociatedObject(self, &IconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///六角
    QSImageView *iconSixForm = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconView.frame.size.width, iconView.frame.size.height)];
    iconSixForm.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_80];
    [iconView addSubview:iconSixForm];
    
    ///姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x + iconView.frame.size.width + 5.0f, iconView.frame.origin.y, 80.0f, 20.0f)];
    nameLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:nameLabel];
    objc_setAssociatedObject(self, &UserNameKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///VIP标识
    QSImageView *vipImage = [[QSImageView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width, nameLabel.frame.origin.y, 20.0f, 20.0f)];
    vipImage.image = [UIImage imageNamed:IMAGE_PUBLIC_VIP];
    [self addSubview:vipImage];
    vipImage.hidden = YES;
    objc_setAssociatedObject(self, &VIPFlagKey, vipImage, OBJC_ASSOCIATION_ASSIGN);
    
    ///是否诚信用户
    UILabel *creditTag = [[UILabel alloc] initWithFrame:CGRectMake(vipImage.frame.origin.x + 10.0f, vipImage.frame.origin.y + 5.0f, 60.0f, 15.0f)];
    creditTag.text = @"普通用户";
    creditTag.backgroundColor = COLOR_CHARACTERS_LIGHTGRAY;
    creditTag.textColor = [UIColor whiteColor];
    creditTag.font = [UIFont systemFontOfSize:FONT_BODY_12];
    creditTag.layer.cornerRadius = 4.0f;
    creditTag.layer.masksToBounds = YES;
    creditTag.textAlignment = NSTextAlignmentCenter;
    creditTag.hidden = YES;
    [self addSubview:creditTag];
    objc_setAssociatedObject(self, &CreditTagKey, creditTag, OBJC_ASSOCIATION_ASSIGN);
    
    ///手机号码
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x + iconView.frame.size.width + 5.0f, nameLabel.frame.origin.y + nameLabel.frame.size.height, 240.0f, 20.0f)];
    phoneLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    phoneLabel.text = @"138********(预约成功后开放)";
    phoneLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self addSubview:phoneLabel];
    objc_setAssociatedObject(self, &PhoneInfoKey, phoneLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加联系人按钮
    UIButton *addButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width - 44.0f, 28.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///判断是否是回调
        if (self.contactInfoCallBack) {
            
            self.contactInfoCallBack(button);
            
        } else {
        
            [self addContact:button];
        
        }
        
    }];
    [addButton setImage:[UIImage imageNamed:IMAGE_NAVIGATIONBAR_COLLECT_NORMAL] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:IMAGE_NAVIGATIONBAR_COLLECT_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [addButton setImage:[UIImage imageNamed:IMAGE_NAVIGATIONBAR_COLLECTED_NORMAL]  forState:UIControlStateSelected];
    [self addSubview:addButton];
    objc_setAssociatedObject(self, &AddContactKey, addButton, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 0.25f, self.frame.size.width, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:sepLabel];

}

#pragma mark - 刷新UI
/**
 *  @author             yangshengmeng, 15-04-03 17:04:01
 *
 *  @brief              根据联系人的数据模型，创建一个用户信息页
 *
 *  @param userModel    用户数据模型
 *
 *  @since              1.0.0
 */
- (void)updateContactInfoUI:(QSYContactDetailInfoModel *)userModel
{
    
    ///保存用户ID
    self.linkManID = userModel.linkman_id;
    
    ///更新用户名
    [self updateUserName:APPLICATION_NSSTRING_SETTING(userModel.remark, userModel.username)];
    
    ///更新vip标识
    [self updateUserVIPTag:userModel.level];
    
    ///更新诚信用户
    [self updateUserLevel:userModel.level];
    
    ///更新用户联系方式
    [self updatePhoneInfo:userModel.mobile andStatus:userModel.is_order];
    
    ///更新添加按钮
    [self updateAddContactButton:userModel.id_];

    ///更新头像
    [self updateUserIcon:userModel.avatar];

}

- (void)updateUserLevel:(NSString *)level
{

    UILabel *textLabel = objc_getAssociatedObject(self, &CreditTagKey);
    if ([level intValue] == 1) {
        
        textLabel.text = @"普通用户";
        textLabel.hidden = NO;
        
    } else if ([level intValue] == 2) {
    
        textLabel.text = @"诚信用户";
        textLabel.hidden = NO;
    
    } else if ([level intValue] == -1) {
        
        textLabel.text = @"低诚信";
        textLabel.hidden = NO;
    
    } else if ([level intValue] == -2) {
    
        textLabel.text = @"中介";
        textLabel.hidden = NO;
    
    } else {
    
        textLabel.hidden = YES;
    
    }

}

- (void)updatePhoneInfo:(NSString *)phone andStatus:(NSString *)status
{

    UILabel *phoneLabel = objc_getAssociatedObject(self, &PhoneInfoKey);
    if (phoneLabel && [phone length] > 0) {
        
        if ([status isEqualToString:@"true"]) {
            
            phoneLabel.text = phone;
            
        } else {
        
            phoneLabel.text = [NSString stringWithFormat:@"%@******%@(预约成功后开放)",[phone substringWithRange:NSMakeRange(0, 3)],[phone substringWithRange:NSMakeRange(9, 2)]];
        
        }
        
    } else {
    
        phoneLabel.text = @"暂无";
    
    }

}

///更新头像
- (void)updateUserIcon:(NSString *)avatar
{

    UIImageView *iconView = objc_getAssociatedObject(self, &IconKey);
    if (iconView && [avatar length] > 0) {
        
        [iconView loadImageWithURL:[avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_HOLLOW_80]];
        
    }

}

///更新用户名
- (void)updateUserName:(NSString *)userName
{

    UILabel *labeName = objc_getAssociatedObject(self, &UserNameKey);
    if (labeName && [userName length] > 0) {
        
        labeName.text = userName;
        
    }

}

///更新vip标识
- (void)updateUserVIPTag:(NSString *)flag
{

    UILabel *vipLabel = objc_getAssociatedObject(self, &VIPFlagKey);
    if ([flag intValue] == 3) {
        
        vipLabel.hidden = NO;
        
    } else {
    
        vipLabel.hidden = YES;
    
    }

}

///更新添加联系人按钮
- (void)updateAddContactButton:(NSString *)flag
{

    UIButton *addButton = objc_getAssociatedObject(self, &AddContactKey);
    if (addButton) {
        
        if ([flag intValue] > 0) {
            
            addButton.selected = YES;
            
        } else {
        
            addButton.selected = NO;
        
        }
        
    }

}

#pragma mark - 添加联系人
- (void)addContact:(UIButton *)button
{
    
    ///如果本来已添加，则不动作
    if (button.selected) {
        
        return;
        
    }
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在添加"];
    
    ///封装参数
    NSDictionary *params = @{@"linkman_id" : APPLICATION_NSSTRING_SETTING(self.linkManID, @""),
                             @"remark" : @"",
                             @"more_remark" : @""};

    ///添加联系人
    [QSRequestManager requestDataWithType:rRequestTypeChatContactAdd andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///添加成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改按钮状态
            UIButton *addButton = objc_getAssociatedObject(self, &AddContactKey);
            addButton.selected = YES;
            [hud hiddenCustomHUDWithFooterTips:@"添加成功" andDelayTime:1.5f];
            
        } else {
        
            NSString *tipsString = @"添加失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];

}

@end
