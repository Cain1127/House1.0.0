//
//  QSPOrderDetailComplaintAndCompletedButtonView.m
//  House
//
//  Created by CoolTea on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailComplaintAndCompletedButtonView.h"

@implementation QSPOrderDetailComplaintAndCompletedButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack{
    
    if (self = [super initAtTopLeft:topLeftPoint withButtonCount:2 andCallBack:callBack]) {
        
        [self setLeftBtTitle:@"我要投诉"];
        [self setRightBtTitle:@"完成看房"];
        
        [self setLeftButtonType:nNormalButtonTypeCornerWhite];
        [self setRightButtonType:nNormalButtonTypeCornerYellow];
        
    }
    
    return self;
    
}

@end
