//
//  QSPBuyerBookedOrderListsTableViewCell.h
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//Cell宽度
#define MY_ZONE_ORDER_LIST_CELL_WIDTH       (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)
//Cell高度
#define MY_ZONE_ORDER_LIST_CELL_HEIGHT      115.0f

@interface QSPBuyerBookedOrderListsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIViewController *parentViewController;

- (void)updateCellWith:(id)Data;

@end
