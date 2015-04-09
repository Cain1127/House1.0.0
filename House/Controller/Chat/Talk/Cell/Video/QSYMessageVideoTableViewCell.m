//
//  QSYMessageVideoTableViewCell.m
//  House
//
//  Created by ysmeng on 15/4/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMessageVideoTableViewCell.h"

#import "NSString+Calculation.h"

#import "QSYSendMessageVideo.h"

#import <objc/runtime.h>

///关联
static char UserIconKey;//!<头像关联
static char SecondKey;  //!<秒数关联

@interface QSYMessageVideoTableViewCell ()

@property (nonatomic,assign) MESSAGE_FROM_TYPE messageType;//!<消息的归属类型

@end

@implementation QSYMessageVideoTableViewCell

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-04-06 13:04:23
 *
 *  @brief                  创建音频聊天显示框
 *
 *  @param style            风格
 *  @param reuseIdentifier  复用标签
 *  @param isMyMessage      消息是当前用户的还是其他人发送过来的
 *
 *  @return                 返回当前创建的文字聊天信息展示框
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMessageType:(MESSAGE_FROM_TYPE)isMyMessage
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///保存消息类型
        self.messageType = isMyMessage;
        
        ///搭建UI
        [self createMessageVideoUI];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createMessageVideoUI
{

    ///根据消息的类型，计算不同控件的坐标
    CGFloat xpointIcon = SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat xpointArrow = xpointIcon + 40.0f + 3.0f;
    CGFloat xpointMessage = xpointArrow + 5.0f;
    CGFloat widthMessage = 120.0f;
    CGFloat xpointSecond = xpointMessage + widthMessage + 2.0f;
    CGFloat widthSecond = 40.0f;
    CGFloat xpointIndicator = 10.0f;
    if (mMessageFromTypeMY == self.messageType) {
        
        xpointIcon = SIZE_DEVICE_WIDTH - 40.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
        xpointArrow = xpointIcon - 3.0f - 5.0f;
        xpointMessage = xpointArrow - widthMessage;
        xpointSecond = xpointMessage - 2.0f - widthSecond;
        xpointIndicator = widthMessage - 40.0f;
        
    }
    
    ///头像
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(xpointIcon, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 40.0f, 40.0f)];
    iconView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    [self.contentView addSubview:iconView];
    objc_setAssociatedObject(self, &UserIconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像六角
    QSImageView *iconSixformView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconView.frame.size.width, iconView.frame.size.height)];
    iconSixformView.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_80];
    [iconView addSubview:iconSixformView];
    
    ///指示三角
    QSImageView *arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(xpointArrow, iconView.frame.origin.y + 20.0f - 7.5f, 5.0f, 15.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHAT_MESSAGE_SENDER_ARROW_NORMAL];
    if (mMessageFromTypeMY == self.messageType) {
        
        arrowIndicator.image = [UIImage imageNamed:IMAGE_CHAT_MESSAGE_MY_ARROW_NORMAL];;
        
    }
    [self.contentView addSubview:arrowIndicator];
    
    ///秒数
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpointSecond, iconView.frame.origin.y, widthSecond, 50.0f)];
    secondLabel.textAlignment = NSTextAlignmentRight;
    secondLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    secondLabel.text = @"7''";
    [self.contentView addSubview:secondLabel];
    objc_setAssociatedObject(self, &SecondKey, secondLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///消息图片底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(xpointMessage, iconView.frame.origin.y, widthMessage, 50.0f)];
    rootView.layer.cornerRadius = 4.0f;
    rootView.backgroundColor = COLOR_CHARACTERS_GRAY;
    if (mMessageFromTypeMY == self.messageType) {
        
        rootView.backgroundColor = COLOR_CHARACTERS_YELLOW;
        
    }
    [self.contentView addSubview:rootView];
    
    ///语音图片
    UIButton *indicatorView = [UIButton createBlockButtonWithFrame:CGRectMake(xpointIndicator, 0.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    [indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_SENDER_INDICATOR_NORMAL] forState:UIControlStateNormal];
    [indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_SENDER_INDICATOR_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_SENDER_INDICATOR_SELECTED] forState:UIControlStateSelected];
    if (mMessageFromTypeMY) {
        
        [indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_MY_INDICATOR_NORMAL] forState:UIControlStateNormal];
        [indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_MY_INDICATOR_HIGHLIGHTED] forState:UIControlStateHighlighted];
        [indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_MY_INDICATOR_SELECTED] forState:UIControlStateSelected];
        
    }
    [rootView addSubview:indicatorView];

}

#pragma mark - 刷新UI
- (void)updateMessageWordUI:(QSYSendMessageVideo *)model
{
    
    ///更新头像
    UIImageView *icontView = objc_getAssociatedObject(self, &UserIconKey);
    if (icontView && [model.f_avatar length] > 0) {
        
        [icontView loadImageWithURL:[model.f_avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
        
    }
    
    ///更新音频秒数
    UILabel *secondLabel = objc_getAssociatedObject(self, &SecondKey);
    if (secondLabel) {
        
        
        
    }
    
}

@end
