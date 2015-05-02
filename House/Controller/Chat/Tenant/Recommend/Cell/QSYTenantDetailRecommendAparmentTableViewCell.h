//
//  QSYTenantDetailRecommendAparmentTableViewCell.h
//  House
//
//  Created by ysmeng on 15/4/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSHouseInfoDataModel;
@interface QSYTenantDetailRecommendAparmentTableViewCell : UICollectionViewCell

/**
 *  @author             yangshengmeng, 15-05-01 12:05:26
 *
 *  @brief              根据给定的数据模型，刷新UI
 *
 *  @param tempModel    房源数据模型
 *
 *  @since              1.0.0
 */
- (void)updateTenantDetailRecommendAparmentUI:(QSHouseInfoDataModel *)tempModel;

@end
