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

@property ( strong, nonatomic ) NSDate *selectedDate;
@property ( strong, nonatomic ) FSCalendarHeader *header;
@property ( strong, nonatomic ) FSCalendar *calendar;

@end


@implementation QSPCalendarView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withCycle:(NSString*)cycle
{
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withCycle:cycle];
}

- (instancetype)initWithFrame:(CGRect)frame withCycle:(NSString*)cycle
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        NSArray *cycleList = nil;
        if (cycle && [cycle isKindOfClass:[NSString class]] && ![cycle isEqualToString:@""]) {
            cycleList = [cycle componentsSeparatedByString:@","];
        }
        
        self.header = [[FSCalendarHeader alloc] initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, 44)];
        [self addSubview:self.header];
        ///分隔线
        UILabel *headerBottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.header.frame.origin.y+self.header.frame.size.height-0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
        [headerBottomLineLablel setBackgroundColor:COLOR_CHARACTERS_LIGHTGRAY];
        
        self.calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, self.header.frame.origin.y+self.header.frame.size.height, SIZE_DEVICE_WIDTH, 580.0f*SIZE_DEVICE_WIDTH/750.0f) withCycleList:cycleList];
        self.calendar.header = self.header;
        self.calendar.delegate = self;
        [self addSubview:self.calendar];
    
        //上个月按钮
        UIImageView *leftBtBgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.header.frame.origin.x, self.header.frame.origin.y, 100.0f/375.0f*SIZE_DEVICE_WIDTH, self.header.frame.size.height)];
        [leftBtBgView setBackgroundColor:COLOR_CHARACTERS_YELLOW];
        [self addSubview:leftBtBgView];
        
        UIImageView *leftBtIconView = [[UIImageView alloc] initWithFrame:CGRectMake((leftBtBgView.frame.size.width-30.f)/2, (leftBtBgView.frame.size.height-30.f)/2, 30.0f, 30.0f)];
        [leftBtIconView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_CALENDAR_MONTH_LEFT_BT]];
        [leftBtBgView addSubview:leftBtIconView];
        
        QSBlockButtonStyleModel *leftBtStyle = [[QSBlockButtonStyleModel alloc] init];
        UIButton *leftBt = [UIButton createBlockButtonWithFrame:leftBtBgView.frame andButtonStyle:leftBtStyle andCallBack:^(UIButton *button) {
            
            [self.calendar goToNextMonth:PGCalendarMonthLast];
            
        }];
        [self addSubview:leftBt];
        
        //下个月按钮
        UIImageView *rightBtBgView = [[UIImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-leftBtBgView.frame.size.width, self.header.frame.origin.y, leftBtBgView.frame.size.width, self.header.frame.size.height)];
        [rightBtBgView setBackgroundColor:COLOR_CHARACTERS_YELLOW];
        [self addSubview:rightBtBgView];
        
        UIImageView *rightBtIconView = [[UIImageView alloc] initWithFrame:CGRectMake((rightBtBgView.frame.size.width-30.f)/2, (rightBtBgView.frame.size.height-30.f)/2, 30.0f, 30.0f)];
        [rightBtIconView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_CALENDAR_MONTH_RIGHT_BT]];
        [rightBtBgView addSubview:rightBtIconView];
        
        QSBlockButtonStyleModel *rightBtStyle = [[QSBlockButtonStyleModel alloc] init];
        UIButton *rightBt = [UIButton createBlockButtonWithFrame:rightBtBgView.frame andButtonStyle:rightBtStyle andCallBack:^(UIButton *button) {
            
            [self.calendar goToNextMonth:PGCalendarMonthNext];
            
        }];
        
        [self addSubview:rightBt];
        
        [self addSubview:headerBottomLineLablel];
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.calendar.frame.origin.y+self.calendar.frame.size.height+0.5f + 8.0f, SIZE_DEVICE_WIDTH, 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_LIGHTGRAY];
        [self addSubview:bottomLineLablel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomLineLablel.frame.origin.y+bottomLineLablel.frame.size.height)];
        
    }
    
    return self;
    
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    self.selectedDate = date;
    NSLog(@"didSelectDate:%@",date);
}

- (NSString*)getSelectedDayStr
{
    
    NSString *dayStr = nil;
    if (self.selectedDate&&[self.selectedDate isKindOfClass:[NSDate class]]) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        dayStr = [dateFormat stringFromDate:self.selectedDate];

    }
    return dayStr;
    
}

- (void)setCanAppointCycle:(NSString*)cycleStr
{
    
    
}

- (void)reloadData
{

    if (self.calendar) {
        [self.calendar reloadData];
        
        [self.calendar goToNextMonth:99];
        
    }
    
}

@end
