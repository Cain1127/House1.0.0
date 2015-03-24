//
//  QSAttentionCommunityCell.h
//  House
//
//  Created by ysmeng on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSCommunityHouseDetailDataModel;
@interface QSAttentionCommunityCell : UICollectionViewCell

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

@end
