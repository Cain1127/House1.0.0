//
//  QSPOrderDetailOrderCancelByOwnerTipView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailOrderCancelByOwnerTipView.h"
#import "NSString+Calculation.h"

@implementation QSPOrderDetailOrderCancelByOwnerTipView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withRemarkTip:(NSString*)tipStr{
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withRemarkTip:tipStr];
}

- (instancetype)initWithFrame:(CGRect)frame withRemarkTip:(NSString*)tipStr
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP);
        CGFloat labelHeight = [tipStr calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_14];
        
        UILabel *markTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, labelHeight)];
        [markTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [markTipLabel setTextColor:[UIColor blackColor]];
        [markTipLabel setText:tipStr];
        [markTipLabel setNumberOfLines:0];
        [self addSubview:markTipLabel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, markTipLabel.frame.origin.y+markTipLabel.frame.size.height + 10)];
        
        self.showHeight = self.frame.size.height;
    }
    
    return self;
    
}

@end
