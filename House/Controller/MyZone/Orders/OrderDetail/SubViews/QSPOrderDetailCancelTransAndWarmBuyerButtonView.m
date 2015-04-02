//
//  QSPOrderDetailCancelTransAndWarmBuyerButtonView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailCancelTransAndWarmBuyerButtonView.h"

@implementation QSPOrderDetailCancelTransAndWarmBuyerButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack{
    
    if (self = [super initAtTopLeft:topLeftPoint withButtonCount:2 andCallBack:callBack]) {
        
        [self setLeftBtTitle:@"取消成交"];
        [self setRightBtTitle:@"提醒房客"];
        
        [self setLeftButtonType:nNormalButtonTypeCornerWhite];
        [self setRightButtonType:nNormalButtonTypeCornerYellow];
        
    }
    
    return self;
    
}

@end
