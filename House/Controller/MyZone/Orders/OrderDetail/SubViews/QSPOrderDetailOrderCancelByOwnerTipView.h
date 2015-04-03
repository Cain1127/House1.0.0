//
//  QSPOrderDetailOrderCancelByOwnerTipView.h
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"

@interface QSPOrderDetailOrderCancelByOwnerTipView : QSPOrderDetalSubBaseView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withRemarkTip:(NSString*)tipStr;
- (instancetype)initWithFrame:(CGRect)frame withRemarkTip:(NSString*)tipStr;

@end
