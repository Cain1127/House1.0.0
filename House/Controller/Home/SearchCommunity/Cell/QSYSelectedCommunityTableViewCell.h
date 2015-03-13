//
//  QSYSelectedCommunityTableViewCell.h
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-03-13 09:03:32
 *
 *  @brief  选择小区列表中的cell
 *
 *  @since  1.0.0
 */
@class QSCommunityDataModel;
@interface QSYSelectedCommunityTableViewCell : UITableViewCell

///刷新UI
- (void)updateSelectedCommunityCellUI:(QSCommunityDataModel *)model;

@end
