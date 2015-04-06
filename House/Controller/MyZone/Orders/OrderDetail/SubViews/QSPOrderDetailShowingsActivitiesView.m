//
//  QSPOrderDetailShowingsActivitiesView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailShowingsActivitiesView.h"
#import "NSString+Calculation.h"

@implementation QSPOrderDetailShowingsActivitiesView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withActivityData:(id)activityData
{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withActivityData:activityData];
    
}

- (instancetype)initWithFrame:(CGRect)frame withActivityData:(id)activityData
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:COLOR_CHARACTERS_LIGHTLIGHTGRAY];
//        [self setBackgroundColor:COLOR_CHARACTERS_LIGHTYELLOW];
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        NSString *titleString = @"2015年04月02日水暖凤凰阁看房团";
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP);
        
        CGFloat titleLabelHeight = [titleString calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_20];
        
        //标题Label
        UILabel *activityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, titleLabelHeight)];
        [activityTitleLabel setFont:[UIFont systemFontOfSize:FONT_BODY_20]];
        [activityTitleLabel setTextColor:COLOR_CHARACTERS_BLACK];
        [activityTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [activityTitleLabel setText:titleString];
        [activityTitleLabel setNumberOfLines:0];
        [self addSubview:activityTitleLabel];
        
        //报名人数
        UILabel *personNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, activityTitleLabel.frame.origin.y+activityTitleLabel.frame.size.height+4, SIZE_DEVICE_WIDTH/2, 20.0f)];
        [personNumLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [personNumLabel setTextColor:COLOR_CHARACTERS_BLACK];
        [personNumLabel setTextAlignment:NSTextAlignmentLeft];
        [personNumLabel setText:@"已报名：118人"];
        [personNumLabel setNumberOfLines:0];
        [self addSubview:personNumLabel];
        
        //截止时间
        UILabel *timeOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-(SIZE_DEVICE_WIDTH/2), personNumLabel.frame.origin.y, SIZE_DEVICE_WIDTH/2, personNumLabel.frame.size.height)];
        [timeOutLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [timeOutLabel setTextColor:COLOR_CHARACTERS_BLACK];
        [timeOutLabel setTextAlignment:NSTextAlignmentRight];
        [timeOutLabel setText:@"截止时间：2015年04月02日"];
        [timeOutLabel setNumberOfLines:0];
        [self addSubview:timeOutLabel];
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, timeOutLabel.frame.origin.y+timeOutLabel.frame.size.height+CONTENT_TOP_BOTTOM_OFFSETY+0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_LIGHTGRAY];
//        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_YELLOW];
        
        [self addSubview:bottomLineLablel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomLineLablel.frame.origin.y+bottomLineLablel.frame.size.height)];
        
        self.showHeight = self.frame.size.height;
        
    }
    
    return self;
    
}

@end
