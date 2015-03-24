//
//  QSCommunityDetailViewCell.h
//  House
//
//  Created by 王树朋 on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSHouseInfoDataModel.h"

@interface QSCommunityDetailViewCell : UITableViewCell

/*!
 *  @author wangshupeng, 15-03-13 12:03:14
 *
 *  @brief  小区推荐列表刷新
 *
 *  @param tempModel cell数据
 *
 *  @since 1.0.0
 */
- (void)updateCommunityInfoCellUIWithDataModel:(QSHouseInfoDataModel *)tempModel;


@end
