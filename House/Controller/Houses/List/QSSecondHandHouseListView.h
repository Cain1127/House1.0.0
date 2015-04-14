//
//  QSSecondHandHouseListView.h
//  House
//
//  Created by ysmeng on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSSecondHandHouseListView : UICollectionView

/**
 *  @author         yangshengmeng, 15-04-14 13:04:50
 *
 *  @brief          创建二手房列表
 *
 *  @param frame    大小和位置
 *  @param callBack 列表中的回调
 *
 *  @return         返回当前创建的二手房列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack;

@end
