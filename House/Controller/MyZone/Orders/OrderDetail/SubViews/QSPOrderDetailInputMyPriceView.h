//
//  QSPOrderDetailInputMyPriceView.h
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"

@interface QSPOrderDetailInputMyPriceView : QSPOrderDetalSubBaseView

/**
 *  创建我的出还价输入控件
 *
 *  @param topLeftPoint 相对左上角坐标
 *
 *  @return 控件
 */
- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint;

- (instancetype)initWithFrame:(CGRect)frame;

- (NSString*)getInputPrice;

@end
