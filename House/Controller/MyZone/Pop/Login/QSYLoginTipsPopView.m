//
//  QSYLoginTipsPopView.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYLoginTipsPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYLoginTipsPopView ()

@property (nonatomic,copy) void(^loginTipsCallBack)(LOGIN_TIPS_ACTION_TYPE actionType);

@end

@implementation QSYLoginTipsPopView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-03 10:04:55
 *
 *  @brief          创建登录提示框
 *
 *  @param frame    大小和位置
 *  @param callBack 提示框内的事件回调
 *
 *  @return         返回当前创建的提示框
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(LOGIN_TIPS_ACTION_TYPE actionType))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.loginTipsCallBack = callBack;
            
        }
        
        ///创建UI
        [self createLoginTipsUI];
        
    }
    
    return self;

}

#pragma mark - 创建UI
///创建UI
- (void)createLoginTipsUI
{
    
    ///间隙
    CGFloat gap = (self.frame.size.height - 20.0f - 44.0f) / 3.0f;
    
    ///说明
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, gap, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    tipsLabel.text = @"您还未登录，现在登录？";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    [self addSubview:tipsLabel];
    
    ///按钮风络
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///出售物业
    buttonStyle.title = @"取消";
    UIButton *saleButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + gap, (self.frame.size.width - 7.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.loginTipsCallBack) {
            
            self.loginTipsCallBack(lLoginTipsActionTypeCancel);
            
        }
        
    }];
    [self addSubview:saleButton];
    
    ///出租物业
    buttonStyle.title = @"登录";
    UIButton *rentButton = [UIButton createBlockButtonWithFrame:CGRectMake(saleButton.frame.origin.x + saleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, saleButton.frame.origin.y, saleButton.frame.size.width, saleButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.loginTipsCallBack) {
            
            self.loginTipsCallBack(lLoginTipsActionTypeLogin);
            
        }
        
    }];
    [self addSubview:rentButton];
    
}

@end
