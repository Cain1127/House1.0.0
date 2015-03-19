//
//  QSPCalendarView.m
//  House
//
//  Created by CoolTea on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPCalendarView.h"
#import "FSCalendar.h"

@interface QSPCalendarView ()<FSCalendarDelegate>

@end


@implementation QSPCalendarView
@synthesize selectedDate;

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint
{
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        FSCalendarHeader *header = [[FSCalendarHeader alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, 44)];
        [self addSubview:header];
        ///分隔线
        UILabel *headerBottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, header.frame.origin.y+header.frame.size.height-0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
        [headerBottomLineLablel setBackgroundColor:COLOR_CHARACTERS_LIGHTGRAY];
        
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, header.frame.origin.y+header.frame.size.height, SIZE_DEVICE_WIDTH, 580.0f*SIZE_DEVICE_WIDTH/750.0f)];
        calendar.header = header;
        calendar.delegate = self;
        [self addSubview:calendar];
    
        //上个月按钮
        UIImageView *leftBtBgView = [[UIImageView alloc] initWithFrame:CGRectMake(header.frame.origin.x, header.frame.origin.y, 100.0f/375.0f*SIZE_DEVICE_WIDTH, header.frame.size.height)];
        [leftBtBgView setBackgroundColor:COLOR_CHARACTERS_YELLOW];
        [self addSubview:leftBtBgView];
        
        UIImageView *leftBtIconView = [[UIImageView alloc] initWithFrame:CGRectMake((leftBtBgView.frame.size.width-30.f)/2, (leftBtBgView.frame.size.height-30.f)/2, 30.0f, 30.0f)];
        [leftBtIconView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_CALENDAR_MONTH_LEFT_BT]];
        [leftBtBgView addSubview:leftBtIconView];
        
        QSBlockButtonStyleModel *leftBtStyle = [[QSBlockButtonStyleModel alloc] init];
        UIButton *leftBt = [UIButton createBlockButtonWithFrame:leftBtBgView.frame andButtonStyle:leftBtStyle andCallBack:^(UIButton *button) {
            
            [calendar goToNextMonth:PGCalendarMonthLast];
            
        }];
        [self addSubview:leftBt];
        
        //下个月按钮
        UIImageView *rightBtBgView = [[UIImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-leftBtBgView.frame.size.width, header.frame.origin.y, leftBtBgView.frame.size.width, header.frame.size.height)];
        [rightBtBgView setBackgroundColor:COLOR_CHARACTERS_YELLOW];
        [self addSubview:rightBtBgView];
        
        UIImageView *rightBtIconView = [[UIImageView alloc] initWithFrame:CGRectMake((rightBtBgView.frame.size.width-30.f)/2, (rightBtBgView.frame.size.height-30.f)/2, 30.0f, 30.0f)];
        [rightBtIconView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_CALENDAR_MONTH_RIGHT_BT]];
        [rightBtBgView addSubview:rightBtIconView];
        
        QSBlockButtonStyleModel *rightBtStyle = [[QSBlockButtonStyleModel alloc] init];
        UIButton *rightBt = [UIButton createBlockButtonWithFrame:rightBtBgView.frame andButtonStyle:rightBtStyle andCallBack:^(UIButton *button) {
            
            [calendar goToNextMonth:PGCalendarMonthNext];
            
        }];
        
        [self addSubview:rightBt];
        
        [self addSubview:headerBottomLineLablel];
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, calendar.frame.origin.y+calendar.frame.size.height+0.5f + 8.0f, SIZE_DEVICE_WIDTH, 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_LIGHTGRAY];
        [self addSubview:bottomLineLablel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomLineLablel.frame.origin.y+bottomLineLablel.frame.size.height)];
        
    }
    
    return self;
    
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    selectedDate = date;
    NSLog(@"didSelectDate:%@",date);
}

@end
