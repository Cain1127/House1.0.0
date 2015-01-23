//
//  QSBlockButtonStyleModel+Normal.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockButtonStyleModel+Normal.h"

@implementation QSBlockButtonStyleModel (Normal)

/**
 *  @author             yangshengmeng, 15-01-20 11:01:19
 *
 *  @brief              根据按钮的类型，返回
 *
 *  @param buttonType   按钮类型
 *
 *  @return             返回一个指定类型的风格
 *
 *  @since              1.0.0
 */
+ (QSBlockButtonStyleModel *)createNormalButtonWithType:(NORMAL_BUTTON_TYPE)buttonType
{

    switch (buttonType) {
            
            ///圆角白色按钮
        case nNormalButtonTypeCornerWhite:
            
            return [self ceateNormalCornerWhiteButton];
            
            break;
            
            ///圆角黄色按钮
        case nNormalButtonTypeCornerYellow:
            
            return [self ceateNormalCornerYellowButton];
            
            break;
            
            ///黑字白底按钮
        case nNormalButtonTypeClear:
            
            return [self createNormalClearButton];
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

///创建普通黑字白底按钮
+ (QSBlockButtonStyleModel *)createNormalClearButton
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor = [UIColor whiteColor];
    buttonStyle.titleNormalColor = [UIColor blackColor];
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    return buttonStyle;

}

///创建普通白色圆角按钮
+ (QSBlockButtonStyleModel *)ceateNormalCornerYellowButton
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.cornerRadio = VIEW_SIZE_NORMAL_CORNERADIO;
    buttonStyle.titleNormalColor = [UIColor blackColor];
    buttonStyle.titleHightedColor = [UIColor whiteColor];
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    return buttonStyle;

}

///创建普通黄色圆角按钮
+ (QSBlockButtonStyleModel *)ceateNormalCornerWhiteButton
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor = [UIColor whiteColor];
    buttonStyle.cornerRadio = VIEW_SIZE_NORMAL_CORNERADIO;
    buttonStyle.titleNormalColor = [UIColor blackColor];
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    buttonStyle.borderColor = COLOR_CHARACTERS_GRAY;
    buttonStyle.borderWith = 0.5f;
    return buttonStyle;
    
}

@end
