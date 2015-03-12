//
//  QSPBookingOrderListsTableViewCell.h
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//距离屏幕左右边距
#define MY_ZONE_ORDER_LIST_CELL_GAP         (SIZE_DEVICE_WIDTH > 320.0f ? 25.0f : 15.0f)
//Cell宽度
#define MY_ZONE_ORDER_LIST_CELL_WIDTH       (SIZE_DEVICE_WIDTH - 2.0f * MY_ZONE_ORDER_LIST_CELL_GAP)
//Cell高度
#define MY_ZONE_ORDER_LIST_CELL_HEIGHT      115.0f

@interface QSPBookingOrderListsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIViewController *parentViewController;

- (void)updateCellWith:(id)Data;

@end
