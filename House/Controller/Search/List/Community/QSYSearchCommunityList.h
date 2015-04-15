//
//  QSYSearchCommunityList.h
//  House
//
//  Created by ysmeng on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYSearchCommunityList : UICollectionView

/**
 *  @author             yangshengmeng, 15-04-15 11:04:45
 *
 *  @brief              创建搜索的小区列表
 *
 *  @param frame        大小和位置
 *  @param searchKey    当前的搜索关键字
 *  @param callBack     列表中的回调
 *
 *  @return             返回当前创建的小区列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSearchKey:(NSString *)searchKey andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack;

/**
 *  @author             yangshengmeng, 15-04-15 11:04:54
 *
 *  @brief              根据给定的关键字，重新请求数据
 *
 *  @param searchKey    关键字
 *
 *  @since              1.0.0
 */
- (void)reloadDataWithSearchKey:(NSString *)searchKey;

@end
