//
//  QSPTimeHourPickerView.m
//  House
//
//  Created by CoolTea on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPTimeHourPickerView.h"
#import "QSPOrderBottomButtonView.h"
#import <CoreText/CoreText.h>

@interface QSPTimeHourPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic , strong) UIPickerView *pickerView;

@property (nonatomic , strong) NSMutableArray *hourStartList;
@property (nonatomic , strong) NSMutableArray *hourEndList;

@property (nonatomic , assign) NSInteger hourStartInt;
@property (nonatomic , assign) NSInteger hourEndInt;

@end

@implementation QSPTimeHourPickerView
@synthesize delegate;

+ (instancetype)getTimeHourPickerView
{
    
    static QSPTimeHourPickerView *hourPickerView;
    
    if (!hourPickerView) {
        
        hourPickerView = [[QSPTimeHourPickerView alloc] initTimeHourPickerView];
        
    }
    [hourPickerView setBackgroundColor:COLOR_CHARACTERS_BLACKH];
    return hourPickerView;
    
}

- (instancetype)initTimeHourPickerView
{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)]) {
        
        self.hourStartList = [NSMutableArray arrayWithCapacity:0];
        self.hourEndList = [NSMutableArray arrayWithCapacity:0];
        _hourStartInt = 0;
        _hourEndInt = 24;
        
        for (int i=_hourStartInt; i<=_hourEndInt; i++) {
            NSString *timeStr = [NSString stringWithFormat:@"%2d:00",i];
            [self.hourStartList addObject:timeStr];
            if (i>-0) {
                [self.hourEndList addObject:timeStr];
            }
        }
        
        UIButton *bgBt = [UIButton createBlockButtonWithFrame:self.frame andButtonStyle:[[QSBlockButtonStyleModel alloc] init] andCallBack:^(UIButton *button) {
            
            [self hideTimeHourPickerView];
            
        }];
        [self addSubview:bgBt];
        
        ///底部按钮
        QSPOrderBottomButtonView *buttomButtonsView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointZero withButtonCount:2 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            
            NSLog(@"QSPTimeHourPickerView buttomButtonsView clickButton：%d",buttonType);
            if (buttonType == bBottomButtonTypeLeft) {
                //左边按钮
                [self hideTimeHourPickerView];
                
            }else if (buttonType == bBottomButtonTypeRight) {
                //右边按钮
                
                [self hideTimeHourPickerView];
                
                if (self.pickerView) {
                    if ([self.pickerView numberOfComponents]==2) {
                        
                        NSInteger startIndex = [self.pickerView selectedRowInComponent:0];
                        NSInteger lastIndex = [self.pickerView selectedRowInComponent:1];
                        
                        NSString *startHourStr = @"";
                        NSString *endHourStr = @"";
                        
                        if ( startIndex!=-1) {
                            startHourStr = [self.hourStartList objectAtIndex:startIndex];
                        }
                        if ( lastIndex!=-1 ) {
                            endHourStr = [self.hourEndList objectAtIndex:lastIndex];
                        }
                        
                        if (delegate) {
                            [delegate changedWithStartHour:startHourStr WithEndHour:endHourStr inView:self];
                        }
                        
                    }
                }
            }
            
        }];
        
        [buttomButtonsView setFrame:CGRectMake(buttomButtonsView.frame.origin.x, self.frame.size.height -buttomButtonsView.frame.size.height, buttomButtonsView.frame.size.width, buttomButtonsView.frame.size.height)];
        [buttomButtonsView setLeftBtBackgroundColor:COLOR_CHARACTERS_LIGHTYELLOW];
        
        ///picker
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-180-buttomButtonsView.frame.size.height, SIZE_DEVICE_WIDTH, 180)];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        self.pickerView.showsSelectionIndicator=YES;
        
        UILabel *pickerTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
        [pickerTipLabel setTextColor:COLOR_CHARACTERS_GRAY];
        [pickerTipLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerTipLabel setBackgroundColor:[UIColor clearColor]];
        [pickerTipLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_16]];
        [pickerTipLabel setText:@"至"];
        [self.pickerView addSubview:pickerTipLabel];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.pickerView.frame.origin.x, self.pickerView.frame.origin.y, self.pickerView.frame.size.width, buttomButtonsView.frame.origin.y+buttomButtonsView.frame.size.height)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:bgView];
        [self addSubview:self.pickerView];
        [self addSubview:buttomButtonsView];
        
        [self setHidden:YES];
    }
    return self;
    
}

- (void)showTimeHourPickerView
{
    
    [self setHidden:NO];
    
}

- (void)hideTimeHourPickerView
{
    
    [self setHidden:YES];
    [self removeFromSuperview];
}

- (void)updateData:(id)data
{
    
}

#pragma mark -
#pragma mark Picker Date Source Methods

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    
    if (component==0) {
        count = [self.hourStartList count];
    }else if (component==1) {
        count = [self.hourEndList count];
    }
    
    return count;
}

#pragma mark Picker Delegate Methods

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *nameStr = @"";
    
    if (component == 0) {
        nameStr = [self.hourStartList objectAtIndex:row];
    }else if (component == 1) {
        nameStr = [self.hourEndList objectAtIndex:row];
    }
    return nameStr;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setAdjustsFontSizeToFitWidth:YES];
        [pickerLabel setTextColor:COLOR_CHARACTERS_YELLOW];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_30]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0) {
        if ([pickerView numberOfComponents]==2) {
            
            NSInteger tempStartHourInt = 0;
            
            NSString *startHourStr = nil;
            if (row<[self.hourStartList count]) {
                startHourStr = [self.hourStartList objectAtIndex:row];
            }
            
            if (startHourStr) {
                NSArray *startList = [startHourStr componentsSeparatedByString:@":"];
                if ([startList count]>0) {
                    tempStartHourInt = [[startList objectAtIndex:0] integerValue];
                }
            }
            
            NSInteger lastEndIndex = [pickerView selectedRowInComponent:1];
            lastEndIndex += (24- [pickerView numberOfRowsInComponent:1]);
            [self.hourEndList removeAllObjects];
            for (int i=tempStartHourInt+1; i<=_hourEndInt; i++) {
                NSString *timeStr = [NSString stringWithFormat:@"%2d:00",i];
                [self.hourEndList addObject:timeStr];
            }
            [pickerView reloadComponent:1];
            NSInteger tempEndIndex = (24 -[self.hourEndList count]);
            if (lastEndIndex<tempEndIndex) {
                [pickerView selectRow:0 inComponent:1 animated:NO];
            }else{
                [pickerView selectRow:lastEndIndex-tempEndIndex inComponent:1 animated:NO];
            }
            
        }
        
    }
    
}

- (void)updateDataFormHour:(NSString*)startHourStr toHour:(NSString*)endHourStr
{
    
    NSLog(@"预约时段 startHourStr:%@ endHourStr:%@",startHourStr,endHourStr);
    
    BOOL hadStartHour = NO;
    if (startHourStr) {
        
        //判断可能是时间戳
        if ([startHourStr length]==10) {
         
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"HH"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:startHourStr.integerValue];
            startHourStr = [formatter stringFromDate:confromTimesp];
            
        }
        
        NSArray *startList = [startHourStr componentsSeparatedByString:@":"];
        if ([startList count]>0) {
            
            _hourStartInt = [[startList objectAtIndex:0] integerValue];
            [self.hourStartList removeAllObjects];
            hadStartHour = YES;
            
        }
    }
    
    if (!hadStartHour) {
        _hourStartInt = 0;
    }
    
    BOOL hadEndHour = NO;
    if (endHourStr) {
        
        //判断可能是时间戳
        if ([endHourStr length]==10) {
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"HH"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:endHourStr.integerValue];
            endHourStr = [formatter stringFromDate:confromTimesp];
            
        }
        
        NSArray *endList = [endHourStr componentsSeparatedByString:@":"];
        if ([endList count]>0) {
            
            _hourEndInt = [[endList objectAtIndex:0] integerValue];
            if (_hourEndInt==0) {
                _hourEndInt = 24;
            }
            [self.hourEndList removeAllObjects];
            hadEndHour = YES;
        }
    }
    
    if (!hadEndHour) {
        _hourEndInt = 24;
    }
    
    if (_hourStartInt>_hourEndInt) {
        [self.pickerView reloadAllComponents];
        return;
    }
    
    for (int i=_hourStartInt; i<=_hourEndInt; i++) {
        NSString *timeStr = [NSString stringWithFormat:@"%2d:00",i];
        if (i!=_hourEndInt) {
            [self.hourStartList addObject:timeStr];
        }
        if (i>_hourStartInt) {
            [self.hourEndList addObject:timeStr];
        }
    }
    
    if (self.pickerView) {
        [self.pickerView reloadAllComponents];
    }
    
}

@end
