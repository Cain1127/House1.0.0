//
//  QSCommunityCollectionViewCell.h
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-02-12 18:02:12
 *
 *  @brief  小区/新房列表的cell模型
 *
 *  @since  1.0.0
 */
@interface QSCommunityCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) BOOL isEditing;//!<是否编辑状态

/**
 *  @author             yangshengmeng, 15-02-12 18:02:39
 *
 *  @brief              小区或新房每项信息的刷新
 *
 *  @param dataModel    数据模型
 *  @param listType     列表类型
 *
 *  @since              1.0.0
 */
- (void)updateCommunityInfoCellUIWithDataModel:(id)dataModel andListType:(FILTER_MAIN_TYPE)listType;

@end
