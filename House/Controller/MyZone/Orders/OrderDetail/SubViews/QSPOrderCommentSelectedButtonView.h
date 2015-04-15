//
//  QSPOrderCommentSelectedButtonView.h
//  House
//
//  Created by CoolTea on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"

@interface QSPOrderCommentSelectedButtonView : QSPOrderDetalSubBaseView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withTitleTip:(NSString*)titleStr andCallBack:(void(^)(UIButton *button))callBack;

- (instancetype)initWithFrame:(CGRect)frame withTitleTip:(NSString*)titleStr andCallBack:(void(^)(UIButton *button))callBack;

- (BOOL)getSelectedState;      //获取当前选择的状态：YES:选中  NO:无选中

- (void)setSelectState:(BOOL)flag;

@end
