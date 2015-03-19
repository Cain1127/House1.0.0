//
//  FSCalendarCell.m
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import "FSCalendarCell.h"
#import "FSCalendar.h"
#import "UIView+FSExtension.h"
#import "NSDate+FSExtension.h"

#define kAnimationDuration 0.15

@interface FSCalendarCell ()

@property (strong, nonatomic) CAShapeLayer *backgroundLayer;
@property (strong, nonatomic) CAShapeLayer *eventLayer;

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary;

@end

@implementation FSCalendarCell

#pragma mark - Init and life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleSelectedBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_titleSelectedBgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.font = [UIFont systemFontOfSize:10];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_subtitleLabel];
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
        _backgroundLayer.hidden = YES;
        [self.contentView.layer insertSublayer:_backgroundLayer atIndex:0];
        
        _eventLayer = [CAShapeLayer layer];
        _eventLayer.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer.bounds].CGPath;
        _eventLayer.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
    CGFloat diameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
    _backgroundLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                        (titleHeight-diameter)/2,
                                        diameter,
                                        diameter);
    CGFloat eventSize = _backgroundLayer.frame.size.height/6.0;
    
    [_titleSelectedBgView setFrame:CGRectMake(0, 0, 41, 45)];
    
    _eventLayer.frame = CGRectMake((_backgroundLayer.frame.size.width-eventSize)/2+_backgroundLayer.frame.origin.x, CGRectGetMaxY(_backgroundLayer.frame)+eventSize*0.2, eventSize*0.8, eventSize*0.8);
    _eventLayer.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer.bounds].CGPath;
}


#pragma mark - Setters

- (void)setDate:(NSDate *)date
{
    if (![_date isEqualToDate:date]) {
        _date = date;
    }
    [self configureCell];
}

- (void)setHasEvent:(BOOL)hasEvent
{
    if (_hasEvent != hasEvent) {
        _hasEvent = hasEvent;
        _eventLayer.hidden = !hasEvent;
    }
}

- (void)showAnimation
{
//    _backgroundLayer.hidden = NO;
//    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
//    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
//    _backgroundLayer.anchorPoint = CGPointMake(0.5, 0.5);
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    zoomOut.fromValue = @0.3;
//    zoomOut.toValue = @1.2;
//    zoomOut.duration = kAnimationDuration/4*3;
//    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    zoomIn.fromValue = @1.2;
//    zoomIn.toValue = @1.0;
//    zoomIn.beginTime = kAnimationDuration/4*3;
//    zoomIn.duration = kAnimationDuration/4;
//    group.duration = kAnimationDuration;
//    group.animations = @[zoomOut, zoomIn];
//    [_backgroundLayer addAnimation:group forKey:@"bounce"];
    [self configureCell];
}

- (void)hideAnimation
{
    _backgroundLayer.hidden = YES;
    [self configureCell];
}

#pragma mark - Private

- (void)configureCell
{
    _titleLabel.text = [NSString stringWithFormat:@"%@",@(_date.fs_day)];
    _subtitleLabel.text = _subtitle;
    _titleLabel.textColor = [self colorForCurrentStateInDictionary:_titleColors];
    _subtitleLabel.textColor = [self colorForCurrentStateInDictionary:_subtitleColors];
    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
    
    CGFloat titleHeight = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
    if (_subtitleLabel.text) {
        _subtitleLabel.hidden = NO;
        CGFloat subtitleHeight = [_subtitleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.subtitleLabel.font}].height;
        CGFloat height = titleHeight + subtitleHeight;
        _titleLabel.frame = CGRectMake(0,
                                       (self.contentView.fs_height*5.0/6.0-height)*0.5,
                                       self.fs_width,
                                       titleHeight);
        
        _subtitleLabel.frame = CGRectMake(0,
                                          _titleLabel.fs_bottom - (_titleLabel.fs_height-_titleLabel.font.pointSize),
                                          self.fs_width,
                                          subtitleHeight);
    } else {
        _titleLabel.frame = CGRectMake(0, 0, self.fs_width, floor(self.contentView.fs_height*5.0/6.0));
        _subtitleLabel.hidden = YES;
    }
    
    [_titleSelectedBgView setCenter:_titleLabel.center];
    
    _titleSelectedBgView.hidden = !self.selected;
    _backgroundLayer.hidden = !self.selected && !self.isToday;
    if (_cellStyle == FSCalendarCellStyleCircle) {
        _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
    }else if (_cellStyle == FSCalendarCellStyleRectangle) {
        _backgroundLayer.path = [UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
    }else if (_cellStyle == FSCalendarCellStyleHexagon) {
        
        [_titleSelectedBgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_CALENDAR_DAY_SELECTED_BT]];
        
//        // step 1: 生成六边形路径
//        CGFloat SIZE = _backgroundLayer.bounds.size.width;
//        CGFloat longSide = SIZE * 0.5 * cosf(M_PI * 30 / 180);
//        CGFloat shortSide = SIZE * 0.5 * sin(M_PI * 30 / 180);
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(0, longSide)];
//        [path addLineToPoint:CGPointMake(shortSide, 0)];
//        [path addLineToPoint:CGPointMake(shortSide + SIZE * 0.5, 0)];
//        [path addLineToPoint:CGPointMake(SIZE, longSide)];
//        [path addLineToPoint:CGPointMake(shortSide + SIZE * 0.5, longSide * 2)];
//        [path addLineToPoint:CGPointMake(shortSide, longSide * 2)];
//        [path closePath];
//        
//        // step 2: 根据路径生成蒙板
//        _backgroundLayer.path = [path CGPath];
        
    }
    
    _eventLayer.fillColor = _eventColor.CGColor;
}

- (BOOL)isPlaceholder
{
    //    return !(_date.fs_year == _month.fs_year && _date.fs_month == _month.fs_month) ;
    return !(_date.fs_year == _month.fs_year && _date.fs_month == _month.fs_month) || (_date.fs_month == _currentDate.fs_month && _date.fs_day<_currentDate.fs_day);

}

- (BOOL)isToday
{
    return _date.fs_year == self.currentDate.fs_year && _date.fs_month == self.currentDate.fs_month && _date.fs_day == self.currentDate.fs_day;
}

- (BOOL)isWeekend
{
    return self.date.fs_weekday == 1 || self.date.fs_weekday == 7;
}

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isPlaceholder) {
        return dictionary[@(FSCalendarCellStatePlaceholder)];
    }
    if (self.isSelected) {
        return dictionary[@(FSCalendarCellStateSelected)];
    }
    if (self.isToday) {
        return dictionary[@(FSCalendarCellStateToday)];
    }
    if (self.isWeekend && [[dictionary allKeys] containsObject:@(FSCalendarCellStateWeekend)]) {
        return dictionary[@(FSCalendarCellStateWeekend)];
    }
    return dictionary[@(FSCalendarCellStateNormal)];
}

@end
