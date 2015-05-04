//
//  QSYHistorySecondHandHouseListView.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYHistorySecondHandHouseListView : UICollectionView

@property (nonatomic,assign) BOOL isEditing;//!<设置编辑状态

/**
 *  @author         yangshengmeng, 15-05-04 18:05:29
 *
 *  @brief          创建二手房浏览记录列表
 *
 *  @param frame    大小和位置
 *  @param callBack 列表相关事件的回调
 *
 *  @return         返回当前创建的二手房浏览记录列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack;

/**
 *  @author             yangshengmeng, 15-05-04 18:05:35
 *
 *  @brief              设置编辑状态
 *
 *  @param isEditing    编辑状态的标识符
 *
 *  @since              1.0.0
 */
- (void)setIsEditingWithNumber:(NSNumber *)isEditing;

@end
