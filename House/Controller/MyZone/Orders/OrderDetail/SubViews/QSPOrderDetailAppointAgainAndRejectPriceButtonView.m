//
//  QSPOrderDetailAppointAgainAndRejectPriceButtonView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailAppointAgainAndRejectPriceButtonView.h"

@implementation QSPOrderDetailAppointAgainAndRejectPriceButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack{
    
    if (self = [super initAtTopLeft:topLeftPoint withButtonCount:2 andCallBack:callBack]) {
        
        [self setLeftBtTitle:@"再次预约"];
        [self setRightBtTitle:@"拒绝还价"];
        
        [self setLeftButtonType:nNormalButtonTypeCornerYellow];
        [self setRightButtonType:nNormalButtonTypeCornerWhite];
        
    }
    
    return self;
    
}

@end
