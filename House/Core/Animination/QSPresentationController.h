//
//  QSPresentationController.h
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///自定义动画类型
typedef enum
{

    cCustomModalPresentationDefault = 0,//!<默认的动画类型

}CUSTOM_MODALPRESENTATION_STYLE;

/**
 *  @author yangshengmeng, 15-01-27 21:01:59
 *
 *  @brief  自定义动画切换VC容器
 *
 *  @since  1.0.0
 */
@interface QSPresentationController : UIPresentationController

@end