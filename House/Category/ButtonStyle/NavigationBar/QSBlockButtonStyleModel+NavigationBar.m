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
            
            return [self createNavigationBarTurnBackButtonStyle];
            
            break;
            
            ///设置按钮
        case nNavigationBarButtonTypeSetting:
            
            return [self createNavigationBarSettingButtonStyle];
            
            break;
            
            ///地图列表按钮
        case nNavigationBarButtonTypeMapList:
            
            return [self createNavigationBarMapListButtonStyle];
            
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
            
            ///收藏按钮
        case nNavigationBarButtonTypeCollected:
            
            return [self createNavigationBarCollectedButtonStyle];
            
            break;
            
            ///分享按钮
        case nNavigationBarButtonTypeShare:
            
            return [self createNavigationBarShareButtonStyle];
            
            break;
            
            ///编辑按钮
        case nNavigationBarButtonTypeEdit:
            
            return [self createNavigationBarEditButtonStyle];
            
            break;
            
            ///提交确认按钮
        case nNavigationBarButtonTypeCommit:
            
            return [self createNavigationBarCommitButtonStyle];
            
            break;
            
            ///添加按钮
        case nNavigationBarButtonTypeAdd:
            
            return [self createNavigationBarAddButtonStyle];
            
            break;
            
            ///叉叉取消按钮
        case nNavigationBarButtonTypeCancel:
            
            return [self createNavigationBarCancelButtonStyle];
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

#pragma mark - 交叉图片取消按钮
+ (QSBlockButtonStyleModel *)createNavigationBarCancelButtonStyle
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_CANCEL_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_CANCEL_HIGHLIGHTED;
    return buttonStyle;
    
}

#pragma mark - 提交确认按钮
+ (QSBlockButtonStyleModel *)createNavigationBarAddButtonStyle
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_ADD_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_ADD_HIGHLIGHTED;
    return buttonStyle;
    
}

#pragma mark - 提交确认按钮
+ (QSBlockButtonStyleModel *)createNavigationBarCommitButtonStyle
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_CONFIRM_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_CONFIRM_HIGHLIGHTED;
    return buttonStyle;

}

#pragma mark - 编辑按钮
+ (QSBlockButtonStyleModel *)createNavigationBarEditButtonStyle
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.title = @"编辑";
    buttonStyle.titleSelected = @"完成";
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_GRAY;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_14];
    
    return buttonStyle;
    
}

#pragma mark - 分享按钮
+ (QSBlockButtonStyleModel *)createNavigationBarShareButtonStyle
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_SHARE_NORMAL;
    buttonStyle.imagesSelected = IMAGE_NAVIGATIONBAR_SHARE_HIGHLIGHTED;
    
    return buttonStyle;

}

#pragma mark - 收藏按钮
+ (QSBlockButtonStyleModel *)createNavigationBarCollectedButtonStyle
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_COLLECT_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_COLLECT_HIGHLIGHTED;
    buttonStyle.imagesSelected = IMAGE_NAVIGATIONBAR_COLLECTED_NORMAL;
    
    return buttonStyle;

}

#pragma mark - 返回按钮
+ (QSBlockButtonStyleModel *)createNavigationBarTurnBackButtonStyle
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_TURNBACK_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_TURNBACK_HIGHLIGHTED;
    
    return buttonStyle;
    
}

#pragma mark - 地图列表按钮
+ (QSBlockButtonStyleModel *)createNavigationBarMapListButtonStyle
{
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_MAPLIST_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_MAPLIST_HIGHLIGHTED;
    
    return buttonStyle;
    
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
