//
//  QSBlockButtonStyleModel+NavigationBar.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockButtonStyleModel.h"

///导航栏左右按钮类型
typedef enum
{
    
    nNavigationBarButtonLocalTypeLeft = 0,  //!<导航栏左侧按钮
    nNavigationBarButtonLocalTypeRight      //!<导航栏右侧按钮

}NAVIGATIONBAR_BUTTON_LOCAL_TYPE;           //!<导航栏按钮位置类型：左右

///不同的页面导航栏类型
typedef enum
{

    nNavigationBarButtonTypeTurnBack = 0,       //!<返回按钮
    nNavigationBarButtonTypeSearch,             //!<导航栏搜索按钮
    nNavigationBarButtonTypeSetting,            //!<我的页面：设置按钮
    nNavigationBarButtonTypeMessage,            //!<我的页面：消息按钮
    nNavigationBarButtonTypeTool,               //!<发现：工具
    nNavigationBarButtonTypeMapList             //!<找房：地图列表按钮
    
}NAVIGATIONBAR_BUTTON_TYPE;                     //!<导航栏按钮的类型：搜索、消息、设置乖乖

@interface QSBlockButtonStyleModel (NavigationBar)

/**
 *  @author yangshengmeng, 15-01-17 21:01:11
 *
 *  @brief  创建给定位置和类型的导航栏按钮风格
 *
 *  @return 返回导航栏按钮的风格模型
 *
 *  @since  1.0.0
 */
+ (QSBlockButtonStyleModel *)createNavigationBarButtonStyleWithType:(NAVIGATIONBAR_BUTTON_LOCAL_TYPE)buttonLocal andButtonType:(NAVIGATIONBAR_BUTTON_TYPE)buttonType;

@end
