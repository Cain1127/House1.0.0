//
//  QSPOrderDetailBargainingPriceHistoryView.h
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"

@interface QSPOrderDetailBargainingPriceHistoryView : QSPOrderDetalSubBaseView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withOrderData:(id)orderData;

- (instancetype)initWithFrame:(CGRect)frame withOrderData:(id)orderData;

- (void)setOrderData:(id)orderData;

@end
