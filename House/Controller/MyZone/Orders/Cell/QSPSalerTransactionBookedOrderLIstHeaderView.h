//
//  QSPSalerTransactionBookedOrderLIstHeaderView.h
//  House
//
//  Created by CoolTea on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//Header Cell宽度
#define MY_ZONE_ORDER_LIST_HEADER_CELL_WIDTH       (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)
//Header Cell高度
#define MY_ZONE_ORDER_LIST_HEADER_CELL_HEIGHT      90.0f


@protocol QSPSalerTransactionBookedOrderLIstHeaderViewDelegate<NSObject>

- (void)clickItemInHeaderViewWithData:(id)data withSection:(NSInteger)section;

@end

@interface QSPSalerTransactionBookedOrderLIstHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) id<QSPSalerTransactionBookedOrderLIstHeaderViewDelegate> delegate;

@property (nonatomic,copy) NSString* orderTypeName;

- (void)updateData:(id)data;

- (void)setShowButtonOpenOrClose:(BOOL)flag;


@end
