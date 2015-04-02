//
//  QSPOrderDetailConfirmOrderButtonView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailConfirmOrderButtonView.h"

@implementation QSPOrderDetailConfirmOrderButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack{
    
    if (self = [super initAtTopLeft:topLeftPoint withButtonCount:1 andCallBack:callBack]) {
        
        [self setCenterBtTitle:@"房源非常满意，我要成交！"];
        
        [self setCenterButtonType:nNormalButtonTypeCornerYellow];
        
    }
    
    return self;
    
}

@end
