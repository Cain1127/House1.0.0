//
//  QSYComparisonTipsPopView.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYComparisonTipsPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYComparisonTipsPopView ()

///比一比提示框的回调
@property (nonatomic,copy) void(^comparisonTipsCallBack)(COMPARISION_TIPS_ACTION_TYPE actionType);

@end

@implementation QSYComparisonTipsPopView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建比一比提示说明弹出窗口
 *
 *  @param frame    大小和位置
 *  @param callBack 点击选择后的回调
 *
 *  @return         返回当前创建的比一比提示窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andShareCallBack:(void(^)(COMPARISION_TIPS_ACTION_TYPE actionType))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.comparisonTipsCallBack = callBack;
            
        }
        
        ///搭建UI
        [self createComparisionTipsUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createComparisionTipsUI
{

    ///提示信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f, self.frame.size.width, 30.0f)];
    tipsLabel.text = @"是否将此房进行比一比？";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self addSubview:tipsLabel];
    
    ///按钮相关尺寸
    CGFloat xpoint = 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat width = (self.frame.size.width - 2.0f * xpoint - VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP) / 2.0f;
    
    ///取消按钮
    QSBlockButtonStyleModel *cancelButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
    cancelButtonStyle.title = @"取消";
    
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(xpoint, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 15.0f, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:cancelButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.comparisonTipsCallBack) {
            
            self.comparisonTipsCallBack(cComparisonTipsActionTypeCancel);
            
        }
        
    }];
    [self addSubview:cancelButton];
    
    ///确认按钮
    QSBlockButtonStyleModel *confirmButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    confirmButtonStyle.title = @"确定";
    
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width / 2.0f + 4.0f, cancelButton.frame.origin.y, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:confirmButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.comparisonTipsCallBack) {
            
            self.comparisonTipsCallBack(cComparisonTipsActionTypeConfirm);
            
        }
        
    }];
    [self addSubview:confirmButton];

}

@end
