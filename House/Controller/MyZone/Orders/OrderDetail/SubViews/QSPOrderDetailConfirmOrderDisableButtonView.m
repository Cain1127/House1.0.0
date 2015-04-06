//
//  QSPOrderDetailConfirmOrderDisableButtonView.m
//  House
//
//  Created by CoolTea on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailConfirmOrderDisableButtonView.h"

@implementation QSPOrderDetailConfirmOrderDisableButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack{
    
    if (self = [super initAtTopLeft:topLeftPoint withButtonCount:1 andCallBack:callBack]) {
        
        [self setCenterBtTitle:@"房源非常满意，我要成交！"];
        
        [self setCenterButtonType:nNormalButtonTypeCornerWhite];
        
    }
    
    return self;
    
}

@end
