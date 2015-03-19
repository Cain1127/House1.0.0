//
//  QSPOrderBookTimeViewController.m
//  House
//
//  Created by CoolTea on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderBookTimeViewController.h"
#import "QSCoreDataManager+User.h"
#import "QSPCalendarView.h"
#import "QSPOrderBottomButtonView.h"
#import "UITextField+CustomField.h"
#import "QSPTimeHourPickerView.h"

@interface QSPOrderBookTimeViewController ()<UITextFieldDelegate, QSPTimeHourPickerViewDelegate>

@property (nonatomic,assign) USER_COUNT_TYPE userType;//!<用户类型
@property (nonatomic,strong) UITextField *currentTextField;
@property (nonatomic,strong) QSScrollView *scrollView;

@end

@implementation QSPOrderBookTimeViewController
@synthesize vcType;

#pragma mark - 初始化
///初始化
- (instancetype)init
{
    
    if (self = [super init]) {
        
        ///获取当前用户类型
        self.userType = [QSCoreDataManager getCurrentUserCountType];
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_BOOKTIME];
    
}

///搭建主展示UI
- (void)createMainShowUI
{
    ///由于此页面是放置在tabbar页面上的，所以中间可用的展示高度是设备高度减去导航栏和底部tabbar的高度
    __block CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f;
    __block CGFloat mainOffSetY = 64.0f;
    
    QSPOrderBottomButtonView *buttomButtonsView = nil;
    CGFloat buttomViewHeight = 0.0f;
    
    //底部按钮
    if (vcType == bBookTypeViewControllerBook) {
        
        buttomButtonsView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointZero withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            
            [self hideKeyboard];
            NSLog(@"buttomButtonsView clickButton：%d",buttonType);
            if (buttonType == bBottomButtonTypeOne) {
                //中间按钮
            }
            
        }];
        [buttomButtonsView setCenterBtTitle:TITLE_MYZONE_ORDER_BOOK_TIME_BT_SUBMIT];
        [buttomButtonsView setFrame:CGRectMake(buttomButtonsView.frame.origin.x, SIZE_DEVICE_HEIGHT -buttomButtonsView.frame.size.height, buttomButtonsView.frame.size.width, buttomButtonsView.frame.size.height)];
        buttomViewHeight = buttomButtonsView.frame.size.height;
        
    }else if (vcType == bBookTypeViewControllerChange) {
        
        buttomButtonsView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointZero withButtonCount:2 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            
            [self hideKeyboard];
            
            NSLog(@"buttomButtonsView clickButton：%d",buttonType);
            if (buttonType == bBottomButtonTypeLeft) {
                //左边按钮
            }else if (buttonType == bBottomButtonTypeRight) {
                //右边按钮
            }
            
        }];
        
        [buttomButtonsView setFrame:CGRectMake(buttomButtonsView.frame.origin.x, SIZE_DEVICE_HEIGHT -buttomButtonsView.frame.size.height, buttomButtonsView.frame.size.width, buttomButtonsView.frame.size.height)];
        [buttomButtonsView setLeftBtBackgroundColor:COLOR_CHARACTERS_GRAY];
        buttomViewHeight = buttomButtonsView.frame.size.height;
        
    }
    
    //内容滚动区域
    self.scrollView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, mainOffSetY, SIZE_DEVICE_WIDTH, mainHeightFloat-buttomViewHeight)];
    [self.view addSubview:self.scrollView];
    
    //日历
    QSPCalendarView *calendarView = [[QSPCalendarView alloc] initAtTopLeft:CGPointZero];
    [self.scrollView addSubview:calendarView];
    
    ///预约时段
    __block UITextField *appointmentSlotsField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, calendarView.frame.origin.y+calendarView.frame.size.height+4.0f, SIZE_DEVICE_WIDTH-2.0f*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:nil andLeftTipsInfo:TITLE_MYZONE_ORDER_BOOK_TIME_APPOINTMENT_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsBlack];
    appointmentSlotsField.delegate = self;
    appointmentSlotsField.enabled = NO;
    [self.scrollView addSubview:appointmentSlotsField];
    
    ///分隔线
    UILabel *appointmentSlotsLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(appointmentSlotsField.frame.origin.x, appointmentSlotsField.frame.origin.y + appointmentSlotsField.frame.size.height + 3.5f, appointmentSlotsField.frame.size.width, 0.5f)];
    appointmentSlotsLineLablel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.scrollView addSubview:appointmentSlotsLineLablel];
    
    UIButton *appointmentSlotsBt = [UIButton createBlockButtonWithFrame:appointmentSlotsField.frame andButtonStyle:[[QSBlockButtonStyleModel alloc] init] andCallBack:^(UIButton *button) {
        
        [self hideKeyboard];
        NSLog(@"appointmentSlotsBt");
        
        QSPTimeHourPickerView *timePickerView = nil;
        for (UIView *subView in [self.navigationController.view subviews]) {
            if ([subView isKindOfClass:[QSPTimeHourPickerView class]]) {
                timePickerView = (QSPTimeHourPickerView*)subView;
                break;
            }
        }
        if (!timePickerView) {
            timePickerView = [QSPTimeHourPickerView getTimeHourPickerView];
            [self.navigationController.view addSubview:timePickerView];
        }
        [timePickerView setDelegate:self];
        [timePickerView showTimeHourPickerView];
        
    }];
    [self.scrollView addSubview:appointmentSlotsBt];
    
    ///联系人
    __block UITextField *personNameField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, appointmentSlotsLineLablel.frame.origin.y+appointmentSlotsLineLablel.frame.size.height+4.0f, SIZE_DEVICE_WIDTH-2.0f*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:nil andLeftTipsInfo:TITLE_MYZONE_ORDER_BOOK_TIME_PERSON_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    personNameField.delegate = self;
    personNameField.returnKeyType = UIReturnKeyDone;
    [self.scrollView addSubview:personNameField];
    
    ///分隔线
    UILabel *personNameLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(personNameField.frame.origin.x, personNameField.frame.origin.y + personNameField.frame.size.height + 3.5f, personNameField.frame.size.width, 0.5f)];
    personNameLineLablel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.scrollView addSubview:personNameLineLablel];
    
    ///联系电话
    __block UITextField *phoneNumField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, personNameLineLablel.frame.origin.y+personNameLineLablel.frame.size.height+4.0f, SIZE_DEVICE_WIDTH-2.0f*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:nil andLeftTipsInfo:TITLE_MYZONE_ORDER_BOOK_TIME_PHONE_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    phoneNumField.delegate = self;
    phoneNumField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumField.returnKeyType = UIReturnKeyDone;
    [self.scrollView addSubview:phoneNumField];
    
    ///分隔线
    UILabel *phoneNumLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(phoneNumField.frame.origin.x, phoneNumField.frame.origin.y + phoneNumField.frame.size.height + 3.5f, phoneNumField.frame.size.width, 0.5f)];
    phoneNumLineLablel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.scrollView addSubview:phoneNumLineLablel];
    
    CGFloat buttomOffsetY = phoneNumLineLablel.frame.origin.y+phoneNumLineLablel.frame.size.height;
    
    if (vcType == bBookTypeViewControllerBook) {
        
    }else if (vcType == bBookTypeViewControllerChange) {
        
        ///取消预约
        __block UITextField *cancelAppointmentField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, buttomOffsetY+4.0f, SIZE_DEVICE_WIDTH-2.0f*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:nil andLeftTipsInfo:TITLE_MYZONE_ORDER_BOOK_TIME_CANCEL_APPOINTMENT_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsBlack];
        cancelAppointmentField.delegate = self;
        cancelAppointmentField.enabled = NO;
        [self.scrollView addSubview:cancelAppointmentField];
        
        ///分隔线
        UILabel *cancelAppointmentLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(cancelAppointmentField.frame.origin.x, cancelAppointmentField.frame.origin.y + cancelAppointmentField.frame.size.height + 3.5f, cancelAppointmentField.frame.size.width, 0.5f)];
        cancelAppointmentLineLablel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.scrollView addSubview:cancelAppointmentLineLablel];
        
        UIButton *cancelAppointmentBt = [UIButton createBlockButtonWithFrame:cancelAppointmentField.frame andButtonStyle:[[QSBlockButtonStyleModel alloc] init] andCallBack:^(UIButton *button) {
            
            [self hideKeyboard];
            NSLog(@"cancelAppointmentBt");
            
        }];
        [self.scrollView addSubview:cancelAppointmentBt];
        
        buttomOffsetY = cancelAppointmentLineLablel.frame.origin.y+cancelAppointmentLineLablel.frame.size.height;
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, buttomOffsetY+30.0f)];
    
    if (buttomButtonsView) {
        [self.view addSubview:buttomButtonsView];
    }
    
    ///添加键盘缩放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyboard];
    return YES;
}

- (void)hideKeyboard
{
    if (self.scrollView) {
        for (UIView *view in  [self.scrollView subviews]) {
        
            if ([view isKindOfClass:[UITextField class]]) {
                
                UITextField *textField = (UITextField*)view;
                [textField resignFirstResponder];
                
            }
            
        }
    }
}

- (void)keyboardShow:(NSNotification*)notification
{
    
    NSDictionary* info = [notification userInfo];
    CGRect KBrect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardRect = [self.view convertRect:KBrect fromView:nil];
    CGRect textFieldRect = [self.view convertRect:self.currentTextField.frame fromView:self.currentTextField.superview];
    
    if (textFieldRect.origin.y + textFieldRect.size.height + 2.0f > (self.view.frame.size.height-keyboardRect.size.height)) {

        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x,  ((self.view.frame.size.height-keyboardRect.size.height) - (textFieldRect.origin.y + textFieldRect.size.height + 2.0f)), self.view.frame.size.width, self.view.frame.size.height)];
            
        }];
        
    }
    
}

- (void)keyboardHide:(NSNotification*)notification
{
    
    NSDictionary* info = [notification userInfo];
    CGFloat keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{

        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
        
    }];
    
}

@end
