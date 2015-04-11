//
//  QSPOrderDetailRejectAndAcceptAppointmentButtonView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailRejectAndAcceptAppointmentButtonView.h"

@implementation QSPOrderDetailRejectAndAcceptAppointmentButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack{
    
    if (self = [super initAtTopLeft:topLeftPoint withButtonCount:2 andCallBack:callBack]) {
        
        [self setLeftBtTitle:@"拒绝预约"];
        [self setRightBtTitle:@"接受预约"];
        
        [self setLeftButtonType:nNormalButtonTypeCornerLightYellow];
        [self setRightButtonType:nNormalButtonTypeCornerYellow];
        
    }
    
    return self;
    
}

@end
