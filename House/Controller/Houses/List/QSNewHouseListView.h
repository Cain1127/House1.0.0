//
//  QSNewHouseListView.h
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-03-01 16:03:09
 *
 *  @brief  创建新房列表
 *
 *  @since  1.0.0
 */
@interface QSNewHouseListView : UICollectionView

/**
 *  @author             yangshengmeng, 15-04-14 13:04:53
 *
 *  @brief              创建新房列表
 *
 *  @param frame        大小和位置
 *  @param callBack     新房列表相关事件回调
 *
 *  @return             返回当前创建的新房列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack;

@end
