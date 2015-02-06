//
//  QSHouseCollectionViewCell.h
//  House
//
//  Created by ysmeng on 15/1/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-01-31 14:01:36
 *
 *  @brief  自定义的房子信息cell
 *
 *  @since  1.0.0
 */
@interface QSHouseCollectionViewCell : UICollectionViewCell

/**
 *  @author             yangshengmeng, 15-02-06 10:02:42
 *
 *  @brief              根据请求返回的数据模型更新房子信息cell
 *
 *  @param dataModel    数据模型
 *
 *  @since              1.0.0
 */
- (void)updateHouseInfoCellUIWithDataModel:(id)dataModel;

@end
