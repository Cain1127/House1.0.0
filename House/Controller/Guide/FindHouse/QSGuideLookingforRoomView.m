//
//  QSGuideLookingforRoomView.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideLookingforRoomView.h"
#import "QSBlockButtonStyleModel+Normal.h"

@implementation QSGuideLookingforRoomView

/**
 *  @author     yangshengmeng, 15-01-20 14:01:51
 *
 *  @brief      在给定的视图上添加底部相关控件
 *
 *  @param view 底部控制
 *
 *  @since      1.0.0
 */
- (void)createCustomGuideFooterUI:(UIView *)view
{
    
    ///二手房
    QSBlockButtonStyleModel *yellowButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    yellowButtonStyle.title = TITLE_GUIDE_SUMMARY_FINDHOUSE_BUTTON;
    UIButton *secondHouseButton = [UIButton createBlockButtonWithButtonStyle:yellowButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.guideButtonCallBack) {
            
            self.guideButtonCallBack(gGuideButtonActionTypeFindHouseSecondHouse);
            
        }
        
    }];
    secondHouseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:secondHouseButton];
    
    ///出租房
    QSBlockButtonStyleModel *whiteButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    whiteButtonStyle.title = TITLE_GUIDE_SUMMARY_SALEHOUSE_BUTTON;
    UIButton *rentalHouseButton = [UIButton createBlockButtonWithButtonStyle:whiteButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.guideButtonCallBack) {
            
            self.guideButtonCallBack(gGuideButtonActionTypeFindHouseRentalHouse);
            
        }
        
    }];
    rentalHouseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:rentalHouseButton];
    
    ///计算间隙
    CGFloat gap = (SIZE_DEVICE_HEIGHT > 480.0f) ? ((SIZE_DEVICE_WIDTH > 320.0f) ? ((SIZE_DEVICE_WIDTH > 350.0f) ? 40.0f : 30.0f) : 30.0f) : 20.0f;
    CGFloat width = (SIZE_DEVICE_WIDTH > 320.0f) ? ((SIZE_DEVICE_WIDTH > 350.0f) ? 300.0f : 240.0f) : 200.0f;
    NSDictionary *___VFLSizeDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",gap],@"gap",[NSString stringWithFormat:@"%.2f",width],@"width",nil];
    
    ///添加约束
    NSString *___hVFL_secondButton = @"H:[secondHouseButton(width)]";
    NSString *___hVFL_rentalButton = @"H:[rentalHouseButton(width)]";
    NSString *___vVFL_all = @"V:|-gap-[secondHouseButton]-10-[rentalHouseButton(==secondHouseButton)]-gap-|";
    
    ///约束参数字典
    NSDictionary *___VFLViewsDict = NSDictionaryOfVariableBindings(secondHouseButton,rentalHouseButton);
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_secondButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:secondHouseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_rentalButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_all options:NSLayoutFormatAlignAllCenterX metrics:___VFLSizeDict views:___VFLViewsDict]];
    
}

@end
