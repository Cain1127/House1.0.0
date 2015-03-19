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

@property (nonatomic , strong) NSArray *hourStartList;
@property (nonatomic , strong) NSArray *hourEndList;

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
        
        self.hourStartList = [NSArray arrayWithObjects:@"09:00",@"11:00",@"12:00",@"15:00",@"17:00", nil];
        
        self.hourEndList = [NSArray arrayWithObjects:@"13:00",@"15:00",@"16:00",@"18:00", nil];
        
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
                
            }
            
        }];
        
        [buttomButtonsView setFrame:CGRectMake(buttomButtonsView.frame.origin.x, self.frame.size.height -buttomButtonsView.frame.size.height, buttomButtonsView.frame.size.width, buttomButtonsView.frame.size.height)];
        [buttomButtonsView setLeftBtBackgroundColor:COLOR_CHARACTERS_GRAY];
        
        ///picker
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-216-buttomButtonsView.frame.size.height, SIZE_DEVICE_WIDTH, 216)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator=YES;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(pickerView.frame.origin.x, pickerView.frame.origin.y, pickerView.frame.size.width, buttomButtonsView.frame.origin.y+buttomButtonsView.frame.size.height)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:bgView];
        [self addSubview:pickerView];
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

@end
