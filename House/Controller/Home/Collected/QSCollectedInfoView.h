//
//  QSCollectedInfoView.h
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///收藏小区的滚动类型
typedef enum
{

    cCollectedInfoViewTypeDefault = 0,  //!<默认无数据类型
    cCollectedInfoViewTypeAcivity       //!<有数据的收藏信息展示类型

}COLLECTED_INFOVIEW_TYPE;

/**
 *  @author yangshengmeng, 15-03-12 16:03:11
 *
 *  @brief  收藏小区信息显示的自定义view
 *
 *  @since  1.0.0
 */
@class QSCollectedCommunityDataModel;
@interface QSCollectedInfoView : UIView

/**
 *  @author         yangshengmeng, 15-03-12 16:03:53
 *
 *  @brief          创建一个收藏小区滚动的视图
 *
 *  @param frame    大小和位置
 *  @param viewType 视图的类型
 *
 *  @return         返回当前创建的收藏信息展示视图
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andViewType:(COLLECTED_INFOVIEW_TYPE)viewType;

/**
 *  @author         yangshengmeng, 15-03-12 16:03:25
 *
 *  @brief          根据收藏小区的数据模型，刷新收藏页面的UI
 *
 *  @param model    收藏小区的数据模型
 *
 *  @since          1.0.0
 */
- (void)updateCollectedInfoViewUI:(QSCollectedCommunityDataModel *)model;

@end
