//
//  QSYAskRentAndSecondHandHouseTipsPopView.m
//  House
//
//  Created by ysmeng on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskRentAndSecondHandHouseTipsPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYAskRentAndSecondHandHouseTipsPopView ()

///求租求购的回调
@property (nonatomic,copy) void(^askRentAndBuyCallBack)(ASK_RENTANDSECONDHOUSE_TIPS_ACTION_TYPE actionType);

@end

@implementation QSYAskRentAndSecondHandHouseTipsPopView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-31 15:03:25
 *
 *  @brief          创建一个将要发布求租，求购的询问页面
 *
 *  @param frame    大小和位置
 *  @param callBack 询问问事件回调
 *
 *  @return         返回当前创建的询问页
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(ASK_RENTANDSECONDHOUSE_TIPS_ACTION_TYPE actionType))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.askRentAndBuyCallBack = callBack;
            
        }
        
        ///创建UI
        [self createAskRentAndBuyUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createAskRentAndBuyUI
{

    ///提示信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f, self.frame.size.width, 20.0f)];
    tipsLabel.text = @"选择发布需求类型";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_18];
    [self addSubview:tipsLabel];
    
    ///按钮相关尺寸
    CGFloat xpoint = 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat width = (self.frame.size.width - 2.0f * xpoint - VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP) / 2.0f;
    
    ///取消按钮
    QSBlockButtonStyleModel *cancelButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
    cancelButtonStyle.title = @"求租";
    
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(xpoint, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 15.0f, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:cancelButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.askRentAndBuyCallBack) {
            
            self.askRentAndBuyCallBack(aAskRentAndSecondHouseTipsActionTypeRent);
            
        }
        
    }];
    [self addSubview:cancelButton];
    
    ///确认按钮
    QSBlockButtonStyleModel *confirmButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    confirmButtonStyle.title = @"求购";
    
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width / 2.0f + 4.0f, cancelButton.frame.origin.y, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:confirmButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.askRentAndBuyCallBack) {
            
            self.askRentAndBuyCallBack(aAskRentAndSecondHouseTipsActionTypeBuy);
            
        }
        
    }];
    [self addSubview:confirmButton];

}

@end
