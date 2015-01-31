//
//  QSHouseListTitleCollectionViewCell.h
//  House
//
//  Created by ysmeng on 15/1/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-01-31 14:01:54
 *
 *  @brief  自定义房子列表中，标题信息的cell
 *
 *  @since  1.0.0
 */
@interface QSHouseListTitleCollectionViewCell : UICollectionViewCell

/**
 *  @author         yangshengmeng, 15-01-31 14:01:29
 *
 *  @brief          根据给定的标题信息，更新标题
 *
 *  @param title    标题信息
 *
 *  @since          1.0.0
 */
- (void)updateTitleInfoWithTitle:(NSString *)title;

@end
