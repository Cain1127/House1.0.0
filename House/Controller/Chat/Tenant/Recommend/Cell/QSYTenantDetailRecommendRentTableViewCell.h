//
//  QSYTenantDetailRecommendRentTableViewCell.h
//  House
//
//  Created by ysmeng on 15/4/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSRentHouseInfoDataModel;
@interface QSYTenantDetailRecommendRentTableViewCell : UICollectionViewCell

/**
 *  @author             yangshengmeng, 15-05-01 12:05:38
 *
 *  @brief              刷新UI
 *
 *  @param tempModel    数据模型
 *
 *  @since              1.0.0
 */
- (void)updateTenantDetailRecommendRentUI:(QSRentHouseInfoDataModel *)tempModel;

@end
