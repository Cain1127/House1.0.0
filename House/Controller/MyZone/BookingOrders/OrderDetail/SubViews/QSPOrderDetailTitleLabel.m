//
//  QSPOrderDetailTitleLabel.m
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailTitleLabel.h"

@implementation QSPOrderDetailTitleLabel

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)titleStr
{
    
    if (self = [super initWithFrame:frame]) {
        
        
        [self setBackgroundColor:COLOR_CHARACTERS_LIGHTYELLOW];
        if (titleStr&&[titleStr isKindOfClass:[NSString class]]) {
//            if ([titleStr isEqualToString:TITLE_MYZONE_ORDER_DETAIL_WAIT_FOR_CONFIRN_TIP]) {
//                [self setBackgroundColor:COLOR_CHARACTERS_LIGHTYELLOW];
//                
//            }else
            if ([titleStr isEqualToString:TITLE_MYZONE_ORDER_DETAIL_CANCEL_TITLE_TIP]) {
                [self setBackgroundColor:COLOR_CHARACTERS_LIGHTGRAY];
                
            }
        }
        
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setText:titleStr];
        [self setFont:[UIFont boldSystemFontOfSize:FONT_NAVIGATIONBAR_TITLE]];
        
    }
    
    return self;
    
}

@end
