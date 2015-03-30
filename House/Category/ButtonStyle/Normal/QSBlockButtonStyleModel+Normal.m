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
            
            ///圆角浅黄色按钮
        case nNormalButtonTypeCornerLightYellow:
            
            return [self ceateNormalCornerLightYellowButton];
            
            break;
            
            
            ///白字灰底圆角按钮
        case nNormalButtonTypeCornerWhiteGray:
            
            return [self ceateNormalCornerWhiteGrayButton];
            
            break;
            
            ///黑字白底按钮
        case nNormalButtonTypeClear:
            
            return [self createNormalClearButton];
            
            break;
            
            ///灰字白底按钮
        case nNormalButtonTypeClearGray:
            
            return [self createNormalClearGrayButton];
            
            break;
            
            ///淡灰字白底按钮
        case nNormalButtonTypeClearLightGray:
            
            return [self createNormalClearLightGrayButton];
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

+ (QSBlockButtonStyleModel *)createNormalClearGrayButton
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor = [UIColor whiteColor];
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_GRAY;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    return buttonStyle;

}

+ (QSBlockButtonStyleModel *)createNormalClearLightGrayButton
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor = [UIColor whiteColor];
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_LIGHTGRAY;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    return buttonStyle;
    
}

+ (QSBlockButtonStyleModel *)ceateNormalCornerLightYellowButton
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor = COLOR_CHARACTERS_LIGHTYELLOW;
    buttonStyle.cornerRadio = VIEW_SIZE_NORMAL_CORNERADIO;
    buttonStyle.titleNormalColor = [UIColor blackColor];
    buttonStyle.titleHightedColor = [UIColor whiteColor];
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    return buttonStyle;

}
///创建普通白字灰底圆角按钮
+ (QSBlockButtonStyleModel *)ceateNormalCornerWhiteGrayButton
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor = COLOR_CHARACTERS_GRAY;
    buttonStyle.cornerRadio = VIEW_SIZE_NORMAL_CORNERADIO;
    buttonStyle.titleNormalColor = [UIColor whiteColor];
    buttonStyle.titleHightedColor = [UIColor whiteColor];
    buttonStyle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    return buttonStyle;
    
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
