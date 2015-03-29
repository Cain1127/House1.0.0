//
//  QSYHistoryHouseCollectionViewCell.h
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSYHistoryHouseCollectionViewCell : UICollectionViewCell

///刷新UI
- (void)updateHouseInfoCellUIWithDataModel:(id)model andHouseType:(FILTER_MAIN_TYPE)filterType;

@end
