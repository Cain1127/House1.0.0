//
//  QSYHomeRecommendHouseHeaderCollectionViewCell.h
//  House
//
//  Created by ysmeng on 15/4/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSHouseInfoDataModel;
@interface QSYHomeRecommendHouseHeaderCollectionViewCell : UICollectionViewCell

/**
 *  @author yangshengmeng, 15-04-27 15:04:24
 *
 *  @brief  刷新头信息UI
 *
 *  @param  tempModel 数据模型
 *
 *  @since  1.0.0
 */
- (void)updateRecommendHouseUIWithModel:(QSHouseInfoDataModel *)tempModel;

@end
