//
//  QSBlockButtonStyleModel+NavigationBar.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockButtonStyleModel+NavigationBar.h"

@implementation QSBlockButtonStyleModel (NavigationBar)

/**
 *  @author yangshengmeng, 15-01-17 21:01:11
 *
 *  @brief  创建导航栏搜索按钮的风格
 *
 *  @return 返回导航栏超索按钮的风格模型
 *
 *  @since  1.0.0
 */
+ (QSBlockButtonStyleModel *)createNavigationBarSearchButtonStyle
{

    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    
    ///搜索按钮的普通状态和高亮状态图片
    buttonStyle.imagesNormal = IMAGE_NAVIGATIONBAR_SEARCH_NORMAL;
    buttonStyle.imagesHighted = IMAGE_NAVIGATIONBAR_SEARCH_HIGHLIGHTED;
    
    return buttonStyle;

}

@end
