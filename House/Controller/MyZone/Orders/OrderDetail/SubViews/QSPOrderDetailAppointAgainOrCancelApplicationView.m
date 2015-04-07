//
//  QSPOrderDetailAppointAgainOrCancelApplicationView.m
//  House
//
//  Created by CoolTea on 15/4/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailAppointAgainOrCancelApplicationView.h"

@implementation QSPOrderDetailAppointAgainOrCancelApplicationView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack{
    
    if (self = [super initAtTopLeft:topLeftPoint withButtonCount:2 andCallBack:callBack]) {
        
        [self setLeftBtTitle:@"再次预约"];
        [self setRightBtTitle:@"取消申请"];
        
        [self setLeftButtonType:nNormalButtonTypeCornerLightYellow];
        [self setRightButtonType:nNormalButtonTypeCornerYellow];
        
    }
    
    return self;
    
}

@end
