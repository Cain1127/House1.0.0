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

@property (nonatomic,assign) BOOL isEditing;//!<是否编辑状态

/**
 *  @author             yangshengmeng, 15-02-06 10:02:42
 *
 *  @brief              根据请求返回的数据模型更新房子信息cell
 *
 *  @param dataModel    数据模型
 *  @param listType     列表的类型
 *
 *  @since              1.0.0
 */
- (void)updateHouseInfoCellUIWithDataModel:(id)dataModel andListType:(FILTER_MAIN_TYPE)listType;

@end
