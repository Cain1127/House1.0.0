//
//  QSPOrderCommentStarsView.h
//  House
//
//  Created by CoolTea on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"

@interface QSPOrderCommentStarsView : QSPOrderDetalSubBaseView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withTitleTip:(NSString*)titleStr;

- (instancetype)initWithFrame:(CGRect)frame withTitleTip:(NSString*)titleStr;

- (NSInteger)getSelectedIndex;      //获取当前选择的索引值：0表示无选中

@end
