//
//  QSYContactListTableViewCell.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactListTableViewCell.h"

#import "NSString+Calculation.h"

#import "QSYContactInfoSimpleModel.h"
#import "QSUserSimpleDataModel.h"

#import <objc/runtime.h>

///关联
static char IconKey;        //!<头像关联
static char UserNameKey;    //!<用户名
static char VIPFlagKey;     //!<vip标识
static char PhoneInfoKey;   //!<联系号码

@implementation QSYContactListTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createContactSimpleInfoUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createContactSimpleInfoUI
{

    ///头像
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f, 40.0f, 40.0f)];
    iconView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    [self.contentView addSubview:iconView];
    objc_setAssociatedObject(self, &IconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///六角
    QSImageView *iconSixForm = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconView.frame.size.width, iconView.frame.size.height)];
    iconSixForm.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_80];
    [iconView addSubview:iconSixForm];
    
    ///姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x + iconView.frame.size.width + 5.0f, iconView.frame.origin.y, 120.0f, 20.0f)];
    nameLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:nameLabel];
    objc_setAssociatedObject(self, &UserNameKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///VIP标识
    QSImageView *vipImage = [[QSImageView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width, nameLabel.frame.origin.y, 20.0f, 20.0f)];
    vipImage.image = [UIImage imageNamed:IMAGE_PUBLIC_VIP];
    [self.contentView addSubview:vipImage];
    vipImage.hidden = YES;
    objc_setAssociatedObject(self, &VIPFlagKey, vipImage, OBJC_ASSOCIATION_ASSIGN);
    
    ///手机号码
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x + iconView.frame.size.width + 5.0f, nameLabel.frame.origin.y + nameLabel.frame.size.height, 240.0f, 20.0f)];
    phoneLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    phoneLabel.text = @"13800000000";
    phoneLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.contentView addSubview:phoneLabel];
    objc_setAssociatedObject(self, &PhoneInfoKey, phoneLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///删除联系人按钮
    UIButton *deleteButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 44.0f, 15.0f, 44.0f, 49.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.deleteConactCallBack) {
            
            self.deleteConactCallBack(YES);
            
        }
        
    }];
    [deleteButton setImage:[UIImage imageNamed:IMAGE_CHAT_CONTACTLIST_DELETE_NORMAL] forState:UIControlStateNormal];
    [deleteButton setImage:[UIImage imageNamed:IMAGE_CHAT_CONTACTLIST_DELETE_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.contentView addSubview:deleteButton];
    
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 80.0f - 0.25f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.contentView addSubview:sepLabel];

}

#pragma mark - 刷新UI
/**
 *  @author         yangshengmeng, 15-04-03 15:04:50
 *
 *  @brief          根据数据模型，更新联系人信息UI
 *
 *  @param model    联系人数据模型
 *
 *  @since          1.0.0
 */
- (void)updateContacterInfoWithModel:(QSYContactInfoSimpleModel *)model
{

    UILabel *nameLabel = objc_getAssociatedObject(self, &UserNameKey);
    UILabel *vipLabel = objc_getAssociatedObject(self, &VIPFlagKey);
    UILabel *phoneLabel = objc_getAssociatedObject(self, &PhoneInfoKey);
    UIImageView *iconView = objc_getAssociatedObject(self, &IconKey);
    
    if ([model.contactUserInfo.username length] > 0) {
        
        nameLabel.text = model.contactUserInfo.username;
        
    } else {
    
        nameLabel.text = @"raixu";
    
    }
    
    if (vipLabel) {
        
        
        
    }
    
    if ([model.contactUserInfo.mobile length] == 11) {
        
        ///判断是否开放
        if ([model.show_phone isEqualToString:@"Y"]) {
            
            phoneLabel.text = model.contactUserInfo.mobile;
            
        } else {
        
            phoneLabel.text = [NSString stringWithFormat:@"%@******%@",[model.contactUserInfo.mobile  substringToIndex:3],[model.contactUserInfo.mobile substringFromIndex:9]];
        
        }
        
    } else {
    
        phoneLabel.text = @"暂无";
    
    }
    
    if ([model.contactUserInfo.avatar length] > 0) {
        
        [iconView loadImageWithURL:[model.contactUserInfo.avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
        
    } else {
    
        iconView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    
    }

}

@end
