//
//  QSGuideHeaderView.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///指引页按钮事件
typedef enum
{
    
    gGuideButtonActionTypeFindHouse = 100,          //!<我要找房
    gGuideButtonActionTypeSaleHouse,                //!<我要放盘
    gGuideButtonActionTypeFindHouseSecondHouse,     //!<二手房
    gGuideButtonActionTypeFindHouseRentalHouse      //!<出租房

}GUIDE_BUTTON_ATIONTYPE;                    //!<指引页按钮类型

/**
 *  @author yangshengmeng, 15-01-20 16:01:45
 *
 *  @brief  指引页父视图，主要是将指引页分成两部分：头部和脚部，方便自适应
 *
 *  @since  1.0.0
 */
@interface QSGuideHeaderView : UIView

@property (nonatomic,copy) void(^guideButtonCallBack)(GUIDE_BUTTON_ATIONTYPE);

/**
 *  @author             yangshengmeng, 15-01-20 14:01:28
 *
 *  @brief              在指定的视图中添加顶部相关的子view
 *
 *  @param headerView   顶部视图的底view
 *
 *  @since              1.0.0
 */
- (void)createCustomGuideHeaderSubviewsUI:(UIView *)headerView;

/**
 *  @author     yangshengmeng, 15-01-20 14:01:51
 *
 *  @brief      在给定的视图上添加底部相关控件
 *
 *  @param view 底部控制
 *
 *  @since      1.0.0
 */
- (void)createCustomGuideFooterUI:(UIView *)view;

@end
