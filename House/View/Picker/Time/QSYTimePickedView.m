//
//  QSYTimePickedView.m
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYTimePickedView.h"

#import "QSBlockButtonStyleModel+Normal.h"

///内部使用tag
#define TAG_STARTIME_PICKER 340
#define TAG_ENDTIME_PICKER 341

@interface QSYTimePickedView () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIPickerView *starTimePicker;  //!<开始时间的滚动器
@property (nonatomic,strong) UIPickerView *endTimePicker;   //!<结束时间的选择滚动器

///开始和结束时间段的数据源
@property (nonatomic,retain) NSMutableArray *starTimeDataSource;
@property (nonatomic,retain) NSMutableArray *endTimeDataSource;

///选择时间段后的回调
@property (nonatomic,copy) void(^timePickedCallBack)(TIME_PICKED_ACTION_TYPE actionType,NSString *startTime,NSString *endTime);
@property (nonatomic,copy) NSString *startTime;             //!<开始时间
@property (nonatomic,copy) NSString *endTime;               //!<结束时间

@end

@implementation QSYTimePickedView

/**
 *  @author         yangshengmeng, 15-03-27 13:03:48
 *
 *  @brief          创建一个时间段选择窗口
 *
 *  @param frame    大小和位置
 *  @param starHour 默认的开始时间
 *  @param endTime  默认的结束时间
 *  @param callBack 选择时间后的回调
 *
 *  @return         返回当前创建的里德段选择器
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andStarTime:(NSString *)starHour andEndTime:(NSString *)endTime andPickedCallBack:(void(^)(TIME_PICKED_ACTION_TYPE actionType,NSString *startTime,NSString *endTime))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背影颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存开始时间
        if ([starHour length] > 0) {
            
            self.startTime = starHour;
            
        } else {
        
            self.startTime = @"9:00";
        
        }
        
        ///保存结束时间
        if ([endTime length] > 0 && ([endTime intValue] < [self.startTime intValue])) {
            
            self.endTime = endTime;
            
        } else {
        
            self.endTime = @"18:00";
        
        }
        
        ///保存回调
        if (callBack) {
            
            self.timePickedCallBack = callBack;
            
        }
        
        ///初始化数据源
        [self initPickedItemDataSource];
        
        ///创建UI
        [self createTimePickedUI];
        
    }
    
    return self;

}

#pragma mark - 数据源创建
- (void)initPickedItemDataSource
{

    ///开始时间数据源
    self.starTimeDataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 24; i++) {
        
        NSString *titleString = [NSString stringWithFormat:@"%02d:00",i];
        [self.starTimeDataSource addObject:titleString];
        
    }
    
    ///结束时间数据源
    self.endTimeDataSource = [[NSMutableArray alloc] init];
    [self resetEndTimeDataSource];

}

#pragma mark - 重构结束时间可选择的时间段
- (void)resetEndTimeDataSource
{
    
    ///清空
    [self.endTimeDataSource removeAllObjects];

    int startTime = [self.startTime intValue];
    for (int i = startTime + 1; i < [self.starTimeDataSource count]; i++) {
        
        [self.endTimeDataSource addObject:self.starTimeDataSource[i]];
        
    }

}

#pragma mark - UI搭建
- (void)createTimePickedUI
{
    
    ///相关尺寸和坐标
    CGFloat xpointLeft = 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat widthMiddel = 40.0f;
    CGFloat widthOfPicker = (self.frame.size.width - 2.0f * xpointLeft - widthMiddel) / 2.0f;

    ///开始时间选择器
    self.starTimePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(xpointLeft, 10.0f, widthOfPicker, 44.0f * 3.0f)];
    self.starTimePicker.tag = TAG_STARTIME_PICKER;
    self.starTimePicker.delegate = self;
    self.starTimePicker.showsSelectionIndicator = YES;
    [self addSubview:self.starTimePicker];
    
    ///结束时间选择器
    self.endTimePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(self.frame.size.width - widthOfPicker - xpointLeft, 10.0f, widthOfPicker, 44.0f * 3.0f)];
    self.endTimePicker.tag = TAG_ENDTIME_PICKER;
    self.endTimePicker.delegate = self;
    [self addSubview:self.endTimePicker];
    
    ///中间标题
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - 10.0f, 10.0f + 44.0f * 3.0f / 2.0f - 10.0f, 20.0f, 20.0f)];
    tipsLabel.text = @"至";
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.tintColor = COLOR_CHARACTERS_GRAY;
    [self addSubview:tipsLabel];
    
    ///按钮
    CGFloat height = 44.0f;
    CGFloat width = (self.frame.size.width - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 8.0f) / 2.0f;
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    
    ///取消按钮
    buttonStyle.title = @"取消";
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(xpointLeft, self.frame.size.height - 44.0f - 20.0f, width, height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.timePickedCallBack) {
            
            self.timePickedCallBack(tTimePickedActionTypeCancel,nil,nil);
            
        }
        
    }];
    [self addSubview:cancelButton];
    
    ///确认按钮
    buttonStyle.title = @"确认";
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width + 8.0f, self.frame.size.height - 44.0f - 20.0f, width, height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断是否有数据
        if ([self.startTime length] > 0 && ([self.endTime length] > 0)) {
            
            ///回调
            if (self.timePickedCallBack) {
                
                self.timePickedCallBack(tTimePickedActionTypePicked,self.startTime,self.endTime);
                
            }
            
        } else {
            
            ///回调
            if (self.timePickedCallBack) {
                
                self.timePickedCallBack(tTimePickedActionTypeCancel,nil,nil);
                
            }
            
        }
        
    }];
    [self addSubview:confirmButton];
    
    ///1秒后，让选择器选择对应项
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.starTimePicker selectRow:[self.startTime integerValue] inComponent:0 animated:YES];
        [self.endTimePicker selectRow:[self searchEndTimeIndex] inComponent:0 animated:YES];
        
    });

}

#pragma mark - 查找当前给定的结束时间下标
///查找当前给定的结束时间下标
- (NSInteger)searchEndTimeIndex
{

    for (int i = 0; i < [self.endTimeDataSource count]; i++) {
        
        NSString *title = self.endTimeDataSource[i];
        if ([title isEqualToString:self.endTime]) {
            
            return i;
            
        }
        
    }
    
    return 0;

}

#pragma mark - 选择器相关设置
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (TAG_STARTIME_PICKER == pickerView.tag) {
        
        return [self.starTimeDataSource count];
        
    }
    
    if (TAG_ENDTIME_PICKER == pickerView.tag) {
        
        return [self.endTimeDataSource count];
        
    }
    
    return 1;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (TAG_STARTIME_PICKER == pickerView.tag) {
        
        return self.starTimeDataSource[row];
        
    }
    
    if (TAG_ENDTIME_PICKER == pickerView.tag) {
        
        return self.endTimeDataSource[row];
        
    }
    
    return @"08:00";

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{

    return 44.0f;

}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{

    return pickerView.frame.size.width - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (TAG_STARTIME_PICKER == pickerView.tag) {
        
        self.startTime = self.starTimeDataSource[row];
        
        [self resetEndTimeDataSource];
        [self.endTimePicker reloadComponent:0];
        
    }
    
    if (TAG_ENDTIME_PICKER == pickerView.tag) {
        
        ///保存当前结束时间
        self.endTime = self.endTimeDataSource[row];
        
    }

}

@end
