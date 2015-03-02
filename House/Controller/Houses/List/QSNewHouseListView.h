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
@class QSFilterDataModel;
@interface QSNewHouseListView : UICollectionView

/**
 *  @author             yangshengmeng, 15-02-27 10:02:57
 *
 *  @brief              根据大小、位置、列表类型、当前过滤条件及单击时的回调，创建新房
 *
 *  @param frame        大小和位置
 *  @param listType     列表类型
 *  @param filterModel  当前过滤器
 *  @param callBack     单击时的回调
 *
 *  @return             返回当前创建的房子瀑布流列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andHouseListType:(FILTER_MAIN_TYPE)listType andCurrentFilter:(QSFilterDataModel *)filterModel andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack;

@end
