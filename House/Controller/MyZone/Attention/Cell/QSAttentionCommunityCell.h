//
//  QSAttentionCommunityCell.h
//  House
//
//  Created by ysmeng on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSCommunityHouseDetailDataModel;
@class QSNewHouseDetailDataModel;
@interface QSAttentionCommunityCell : UICollectionViewCell

@property (nonatomic,assign) BOOL isEditing;//!<是否编辑状态

/**
 *  @author         yangshengmeng, 15-03-24 22:03:51
 *
 *  @brief          更新收藏小区的cell
 *
 *  @param model    小区详情数据模型
 *
 *  @since          1.0.0
 */
- (void)updateIntentionCommunityInfoCellUIWithDataModel:(QSCommunityHouseDetailDataModel *)model;

/**
 *  @author         yangshengmeng, 15-04-13 09:04:11
 *
 *  @brief          刷新新房UI
 *
 *  @param model    收藏的数据模型
 *
 *  @since          1.0.0
 */
- (void)updateHistoryNewHouseInfoCellUIWithDataModel:(QSNewHouseDetailDataModel *)model;

@end
