//
//  QSYShareChoicesView.m
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYShareChoicesView.h"

#import "UIButton+Factory.h"

@interface QSYShareChoicesView ()

@property (nonatomic,copy) void(^shareChoicesCallBack)(SHARE_CHOICES_TYPE shareType);

@end

@implementation QSYShareChoicesView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建分享选择视图
 *
 *  @param frame    大小和位置
 *  @param callBack 点击选择后的回调
 *
 *  @return         返回当前创建的分享选择窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andShareCallBack:(void(^)(SHARE_CHOICES_TYPE shareType))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.shareChoicesCallBack = callBack;
            
        }
        
        ///创建UI
        [self createShareChoicesUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createShareChoicesUI
{
    
    ///提示信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
    tipsLabel.text = @"分享到";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self addSubview:tipsLabel];
    
    ///间隙
    CGFloat gap = (SIZE_DEVICE_WIDTH - 180.0f) / 4.0f;

    ///微信朋友分享
    UIButton *wechatButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(gap, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 10.0f, 60.0f, 60.0f + 17.0f) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleBottomTitle andTitleSize:15.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.shareChoicesCallBack) {
            
            self.shareChoicesCallBack(sShareChoicesTypeWeChat);
            
        }
        
    }];
    [wechatButton setImage:[UIImage imageNamed:IMAGE_SHARE_WECHAT_NORMAL] forState:UIControlStateNormal];
    [wechatButton setImage:[UIImage imageNamed:IMAGE_SHARE_WECHAT_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [wechatButton setTitle:@"微信好友" forState:UIControlStateNormal];
    [wechatButton setTitleColor:COLOR_CHARACTERS_GRAY forState:UIControlStateNormal];
    [wechatButton setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateHighlighted];
    wechatButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    wechatButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self addSubview:wechatButton];
    
    ///朋友圈分享
    UIButton *friendButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(gap + wechatButton.frame.origin.x + wechatButton.frame.size.width, wechatButton.frame.origin.y, wechatButton.frame.size.width, wechatButton.frame.size.height) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleBottomTitle andTitleSize:15.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.shareChoicesCallBack) {
            
            self.shareChoicesCallBack(sShareChoicesTypeFriends);
            
        }
        
    }];
    [friendButton setImage:[UIImage imageNamed:IMAGE_SHARE_FRIEND_NORMAL] forState:UIControlStateNormal];
    [friendButton setImage:[UIImage imageNamed:IMAGE_SHARE_FRIEND_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [friendButton setTitle:@"朋友圈" forState:UIControlStateNormal];
    [friendButton setTitleColor:COLOR_CHARACTERS_GRAY forState:UIControlStateNormal];
    [friendButton setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateHighlighted];
    friendButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    friendButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self addSubview:friendButton];
    
    ///微博分享
    UIButton *weiboButton = [UIButton createCustomStyleButtonWithFrame:CGRectMake(gap + friendButton.frame.origin.x + friendButton.frame.size.width, wechatButton.frame.origin.y, wechatButton.frame.size.width, wechatButton.frame.size.height) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleBottomTitle andTitleSize:15.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.shareChoicesCallBack) {
            
            self.shareChoicesCallBack(sShareChoicesTypeXinLang);
            
        }
        
    }];
    [weiboButton setImage:[UIImage imageNamed:IMAGE_SHARE_WEIBO_NORMAL] forState:UIControlStateNormal];
    [weiboButton setImage:[UIImage imageNamed:IMAGE_SHARE_WEIBO_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [weiboButton setTitle:@"新浪微博" forState:UIControlStateNormal];
    [weiboButton setTitleColor:COLOR_CHARACTERS_GRAY forState:UIControlStateNormal];
    [weiboButton setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateHighlighted];
    weiboButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    weiboButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self addSubview:weiboButton];

}

@end
