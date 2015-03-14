//
//  QSYSaleOrRentHouseTipsView.m
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSaleOrRentHouseTipsView.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYSaleOrRentHouseTipsView ()

///点击出售或出租物业时的回调
@property (nonatomic,copy) void(^saleTipsCallBack)(SALE_RENT_HOUSE_TIPS_ACTION_TYPE actionType);

@end

@implementation QSYSaleOrRentHouseTipsView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-13 15:03:35
 *
 *  @brief          创建一个业主出租或出售物业的提示选择信息view
 *
 *  @param frame    大小和位置
 *
 *  @return         返回当前创建的出售或出租物业提示窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(SALE_RENT_HOUSE_TIPS_ACTION_TYPE actionType))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.saleTipsCallBack = callBack;
            
        }
        
        ///创建UI
        [self createSaleRentHouseTipsUI];
        
    }
    
    return self;

}

#pragma mark - 创建UI
///创建UI
- (void)createSaleRentHouseTipsUI
{
    
    ///间隙
    CGFloat gap = (self.frame.size.height - 30.0f - 44.0f) / 3.0f;

    ///说明
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, gap, SIZE_DEFAULT_MAX_WIDTH, 30.0f)];
    tipsLabel.text = @"选择发布需求类型!";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    [self addSubview:tipsLabel];
    
    ///按钮风络
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///出售物业
    buttonStyle.title = @"出售";
    UIButton *saleButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + gap, (self.frame.size.width - 7.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.saleTipsCallBack) {
            
            self.saleTipsCallBack(sSaleRentHouseTipsActionTypeSale);
            
        }
        
    }];
    [self addSubview:saleButton];
    
    ///出租物业
    buttonStyle.title = @"出租";
    UIButton *rentButton = [UIButton createBlockButtonWithFrame:CGRectMake(saleButton.frame.origin.x + saleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, saleButton.frame.origin.y, saleButton.frame.size.width, saleButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.saleTipsCallBack) {
            
            self.saleTipsCallBack(sSaleRentHouseTipsActionTypeRent);
            
        }
        
    }];
    [self addSubview:rentButton];

}

@end
