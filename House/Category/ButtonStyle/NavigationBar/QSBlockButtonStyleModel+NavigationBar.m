//
//  QSBlockButtonStyleModel+NavigationBar.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockButtonStyleModel+NavigationBar.h"

@implementation QSBlockButtonStyleModel (NavigationBar)

#pragma mark - 导航栏按钮过滤器
/**
 *  @author yangshengmeng, 15-01-17 21:01:11
 *
 *  @brief  创建给定位置和类型的导航栏按钮风格
 *
 *  @return 返回导航栏按钮的风格模型
 *
 *  @since  1.0.0
 */
+ (QSBlockButtonStyleModel *)createNavigationBarButtonStyleWithType:(NAVIGATIONBAR_BUTTON_LOCAL_TYPE)buttonLocal andButtonType:(NAVIGATIONBAR_BUTTON_TYPE)buttonType
{

    switch (buttonLocal) {
            
            ///左侧按钮
        case nNavigationBarButtonLocalTypeLeft:
            
            return [self createNavigationBarLeftButtonStyleWithType:buttonType];
            
            break;
            
            ///右侧按钮
        case nNavigationBarButtonLocalTypeRight:
            
            return [self createNavigationBarRightButtonStyleWithType:buttonType];
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

///左侧按钮的创建
+ (QSBlockButtonStyleModel *)createNavigationBarLeftButtonStyleWithType:(NAVIGATIONBAR_BUTTON_TYPE)buttonType
{

    switch (buttonType) {
            
            ///返回按钮
        case nNavigationBarButtonTypeTurnBack:
            
            break;
            
            ///设置按钮
        case nNavigationBarButtonTypeSetting:
            
            return [self createNavigationBarSettingButtonStyle];
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

///右侧按钮的创建
+ (QSBlockButtonStyleModel *)createNavigationBarRightButtonStyleWithType:(NAVIGATIONBAR_BUTTON_TYPE)buttonType
{
    
    switch (buttonType) {
            
            ///搜索按钮
        case nNavigationBarButtonTypeSearch:
            
            return [self createNavigationBarSearchButtonStyle];
            
            break;
            
            ///消息按钮
        case nNavigationBarButtonTypeMessage:
            
            return [self createNavigationBarMessageButtonStyle];
            
            break;
            
            ///工具按钮
        case nNavigationBarButtonTypeTool:
            
            return [self createNavigationBarToolButtonStyle];
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

#pragma mark - 工具按钮
+ (QSBlockButtonStyleModel *)createNavigationBarToolButtonStyle
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_TOOL_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_TOOL_HIGHLIGHTED;
    
    return buttonStyle;
    
}

#pragma mark - 导航栏设置按钮
+ (QSBlockButtonStyleModel *)createNavigationBarSettingButtonStyle
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_SETTING_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_SETTING_HIGHLIGHTED;
    
    return buttonStyle;

}

#pragma mark - 导航栏消息按钮
+ (QSBlockButtonStyleModel *)createNavigationBarMessageButtonStyle
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_MESSAGE_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_MESSAGE_HIGHLIGHTED;
    
    return buttonStyle;

}

#pragma mark - 导航栏搜索按钮
+ (QSBlockButtonStyleModel *)createNavigationBarSearchButtonStyle
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_SEARCH_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_SEARCH_HIGHLIGHTED;
    
    return buttonStyle;

}

@end
