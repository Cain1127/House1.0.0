//
//  QSCommunityListView.h
//  House
//
//  Created by ysmeng on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-02-27 15:02:11
 *
 *  @brief  小区/新房列表
 *
 *  @since  1.0.0
 */
@interface QSCommunityListView : UICollectionView

/**
 *  @author         yangshengmeng, 15-04-14 14:04:02
 *
 *  @brief          创建小区列表
 *
 *  @param frame    大小和位置
 *  @param callBack 小区列表相关事件的回调
 *
 *  @return         返回当前创建的小区列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack;

@end
