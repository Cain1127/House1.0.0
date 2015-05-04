//
//  QSYCollectedRentHouseListView.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYCollectedRentHouseListView : UICollectionView

@property (nonatomic,assign) BOOL isEditing;//!<设置编辑状态

/**
 *  @author         yangshengmeng, 15-01-30 08:01:06
 *
 *  @brief          创建收藏出租房列表，并且点击出租房时，回调
 *
 *  @param frame    大小和位置
 *  @param callBack 点击出租房时的回调
 *
 *  @return         返回当前创建的出租房列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack;

/**
 *  @author             yangshengmeng, 15-05-03 12:05:28
 *
 *  @brief              通过给定的数字设置当前的编辑状态
 *
 *  @param isEditing    0-未编辑状态；1-编辑状态
 *
 *  @since              1.0.0
 */
- (void)setIsEditingWithNumber:(NSNumber *)isEditing;

@end
