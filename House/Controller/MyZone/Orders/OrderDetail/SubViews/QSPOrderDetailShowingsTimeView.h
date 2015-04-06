//
//  QSPOrderDetailShowingsTimeView.h
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"

@interface QSPOrderDetailShowingsTimeView : QSPOrderDetalSubBaseView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withTimeData:(NSArray*)timeArray;

- (instancetype)initWithFrame:(CGRect)frame withTimeData:(NSArray*)timeArray;

- (void)setTimeData:(NSArray*)timeArray;

- (void)addAfterView:(UIView* __strong *)view;

@end
