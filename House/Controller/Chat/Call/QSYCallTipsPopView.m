//
//  QSYCallTipsPopView.m
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYCallTipsPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYCallTipsPopView ()

@property (nonatomic,copy) NSString *userName;  //!<联系人姓名
@property (nonatomic,copy) NSString *userMobile;//!<联系电话

///联系人提示框回调
@property (nonatomic,copy) void(^contactUserTipsCallBack)(CALL_TIPS_CALLBACK_ACTION_TYPE actionType);

@end

@implementation QSYCallTipsPopView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)userName andPhone:(NSString *)phone andCallBack:(void(^)(CALL_TIPS_CALLBACK_ACTION_TYPE actionType))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.contactUserTipsCallBack = callBack;
            
        }
        
        self.userName = userName;
        self.userMobile = phone;
        
        ///创建UI
        [self createContactUserTipsUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createContactUserTipsUI
{

    ///提示信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 80.0f - 6.0f - 80.0f) / 2.0f, 15.0f, 80.0f, 15.0f)];
    tipsLabel.text = @"联系业主";
    tipsLabel.textAlignment = NSTextAlignmentRight;
    tipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self addSubview:tipsLabel];
    
    ///业主姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipsLabel.frame.origin.x + tipsLabel.frame.size.width + 6.0f, 10.0f, 80.0f, 20.0f)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = COLOR_CHARACTERS_BLACK;
    nameLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    nameLabel.text = self.userName;
    [self addSubview:nameLabel];
    
    ///电话号码
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, nameLabel.frame.origin.y + nameLabel.frame.size.height + 2.0f, self.frame.size.width, 20.0f)];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = COLOR_CHARACTERS_BLACK;
    phoneLabel.font = [UIFont systemFontOfSize:FONT_BODY_20];
    phoneLabel.text = self.userMobile;
    [self addSubview:phoneLabel];
    
    ///按钮相关尺寸
    CGFloat xpoint = 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat width = (self.frame.size.width - 2.0f * xpoint - VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP) / 2.0f;
    
    ///取消按钮
    QSBlockButtonStyleModel *cancelButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
    cancelButtonStyle.title = @"取消";
    
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(xpoint, phoneLabel.frame.origin.y + phoneLabel.frame.size.height + 13.0f, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:cancelButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.contactUserTipsCallBack) {
            
            self.contactUserTipsCallBack(cCallTipsCallBackActionTypeCancel);
            
        }
        
    }];
    [self addSubview:cancelButton];
    
    ///确认按钮
    QSBlockButtonStyleModel *confirmButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    confirmButtonStyle.title = @"确定";
    
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width / 2.0f + 4.0f, cancelButton.frame.origin.y, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:confirmButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.contactUserTipsCallBack) {
            
            self.contactUserTipsCallBack(cCallTipsCallBackActionTypeConfirm);
            
        }
        
    }];
    [self addSubview:confirmButton];

}

@end
