//
//  QSPOrderDetailCommentNoteTipsView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailCommentNoteTipsView.h"
#import "NSString+Calculation.h"

@implementation QSPOrderDetailCommentNoteTipsView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint {
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        NSString *tipString = @"温馨提示：\n此次预约已结束，如您已实地了解过房源的具体情况，请您对该物业作出相应评价！";
        
        NSString *remarkTipString = @"如在48小时内没有作出任何评价，系统默认记录您对该房源的购买意向是初步合适。";
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP);
        
        CGFloat tipLabelHeight = [tipString calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_14];
        
        UILabel *markTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, tipLabelHeight)];
        [markTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [markTipLabel setTextColor:COLOR_CHARACTERS_BLACK];
        [markTipLabel setText:tipString];
        [markTipLabel setNumberOfLines:0];
        [self addSubview:markTipLabel];
        
        CGFloat remarkLabelHeight = [remarkTipString calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_14];
        
        UILabel *remarkTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, markTipLabel.frame.origin.y+markTipLabel.frame.size.height+6, labelWidth, remarkLabelHeight)];
        [remarkTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [remarkTipLabel setTextColor:COLOR_CHARACTERS_GRAY];
        [remarkTipLabel setText:remarkTipString];
        [remarkTipLabel setNumberOfLines:0];
        [self addSubview:remarkTipLabel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, remarkTipLabel.frame.origin.y+remarkTipLabel.frame.size.height + 10)];
        
        self.showHeight = self.frame.size.height;
    }
    
    return self;
    
}

@end
