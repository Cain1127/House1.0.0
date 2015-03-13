//
//  QSPOrderDetailTitleLabel.m
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailTitleLabel.h"

@implementation QSPOrderDetailTitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:COLOR_CHARACTERS_LIGHTYELLOW];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setText:TITLE_MYZONE_ORDER_DETAIL_WAIT_FOR_CONFIRN_TIP];
        [self setFont:[UIFont boldSystemFontOfSize:FONT_NAVIGATIONBAR_TITLE]];
        
    }
    
    return self;
    
}

@end
