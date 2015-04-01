//
//  QSYHistoryHouseCollectionViewCell.h
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYHistoryHouseCollectionViewCell : UICollectionViewCell

///刷新UI
- (void)updateHouseInfoCellUIWithDataModel:(id)model andHouseType:(FILTER_MAIN_TYPE)filterType;

///个人中心的浏览历史使用的刷新方法
- (void)updateHouseInfoCellUIWithDataModel:(id)model andHouseType:(FILTER_MAIN_TYPE)filterType andPickedBoxStatus:(BOOL)isShowPickedBox;

///刷新是否处于选择状态
- (void)setPickedTipsStatus:(BOOL)flag;

@end
