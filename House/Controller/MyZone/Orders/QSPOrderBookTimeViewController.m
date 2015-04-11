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
#import "NSString+Format.h"
#import "QSPAppointmentOrderReturnData.h"
#import "QSPOrderSubmitResultViewController.h"
#import "QSWSecondHouseInfoDataModel.h"
#import "QSWRentHouseInfoDataModel.h"
#import "QSPOrderDetailBookedViewController.h"
#import "QSCustomHUDView.h"
#import "QSOrderDetailInfoDataModel.h"
#import "QSPOrderDetailActionReturnBaseDataModel.h"

@interface QSPOrderBookTimeViewController ()<UITextFieldDelegate, QSPTimeHourPickerViewDelegate>

@property (nonatomic, assign) USER_COUNT_TYPE userType;//!<用户类型
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) QSScrollView *scrollView;
@property (nonatomic, strong) UITextField *appointmentSlotsField;
@property (nonatomic, strong) QSPCalendarView *calendarView;
@property (nonatomic, strong) NSString *startHour;
@property (nonatomic, strong) NSString *endHour;
@property (nonatomic, strong) UITextField *personNameField;
@property (nonatomic, strong) UITextField *phoneNumField;

@property (nonatomic,copy) void(^blockButtonCallBack)(BOOKTIME_RESULT_TYPE resultTag);

@end

@implementation QSPOrderBookTimeViewController
@synthesize vcType, houseInfo, orderID;

#pragma mark - 初始化

- (instancetype)initWithSubmitCallBack:(void(^)(BOOKTIME_RESULT_TYPE resultTag))callBack
{
    if (self = [self init]) {
        
        self.blockButtonCallBack = callBack;
        
    }
    return self;
    
}

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
                if ([self checkInputSource]) {
                    
                    [self addAppointmentOrder];

                }
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
                //左边取消按钮
                [self cancelAppointmentOrder];
                
            }else if (buttonType == bBottomButtonTypeRight) {
                //右边确定按钮
                
                if ([self checkInputSource]) {
                    [self resetAppointmentOrder];
                }
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
    NSString *cycleStr = nil;
    if (self.houseInfo) {
        if ([self.houseInfo isKindOfClass:[QSWSecondHouseInfoDataModel class]]) {
            cycleStr = ((QSWSecondHouseInfoDataModel*)(self.houseInfo)).cycle;
        }else if ([self.houseInfo isKindOfClass:[QSWRentHouseInfoDataModel class]]) {
            cycleStr = ((QSWRentHouseInfoDataModel*)(self.houseInfo)).cycle;
        }else if ([self.houseInfo isKindOfClass:[QSOrderDetailInfoHouseDataModel class]]) {
            cycleStr = ((QSOrderDetailInfoHouseDataModel*)(self.houseInfo)).cycle;
        }
    }
    self.calendarView = [[QSPCalendarView alloc] initAtTopLeft:CGPointZero withCycle:cycleStr];
    [self.scrollView addSubview:self.calendarView];
    
    ///预约时段
    self.appointmentSlotsField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.calendarView.frame.origin.y+self.calendarView.frame.size.height+4.0f, SIZE_DEVICE_WIDTH-2.0f*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:nil andLeftTipsInfo:TITLE_MYZONE_ORDER_BOOK_TIME_APPOINTMENT_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsBlack];
    self.appointmentSlotsField.delegate = self;
    self.appointmentSlotsField.enabled = NO;
    [self.scrollView addSubview:self.appointmentSlotsField];
    
    ///分隔线
    UILabel *appointmentSlotsLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(self.appointmentSlotsField.frame.origin.x, self.appointmentSlotsField.frame.origin.y + self.appointmentSlotsField.frame.size.height + 3.5f, self.appointmentSlotsField.frame.size.width, 0.5f)];
    appointmentSlotsLineLablel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.scrollView addSubview:appointmentSlotsLineLablel];
    
    UIButton *appointmentSlotsBt = [UIButton createBlockButtonWithFrame:self.appointmentSlotsField.frame andButtonStyle:[[QSBlockButtonStyleModel alloc] init] andCallBack:^(UIButton *button) {
        
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
        if (self.houseInfo) {
            
            NSString *startHour = nil;
            NSString *endHour = nil;
            
            if ([self.houseInfo isKindOfClass:[QSWSecondHouseInfoDataModel class]]) {
                
                startHour = ((QSWSecondHouseInfoDataModel*)(self.houseInfo)).time_interval_start;
                endHour = ((QSWSecondHouseInfoDataModel*)(self.houseInfo)).time_interval_end;
                
                
            }else if ([self.houseInfo isKindOfClass:[QSWRentHouseInfoDataModel class]]) {
                
                startHour = ((QSWRentHouseInfoDataModel*)(self.houseInfo)).time_interval_start;
                endHour = ((QSWRentHouseInfoDataModel*)(self.houseInfo)).time_interval_end;
                
            }else if ([self.houseInfo isKindOfClass:[QSOrderDetailInfoHouseDataModel class]]) {
                
                startHour = ((QSOrderDetailInfoHouseDataModel*)(self.houseInfo)).time_interval_start;
                endHour = ((QSOrderDetailInfoHouseDataModel*)(self.houseInfo)).time_interval_end;
                
            }
            
            [timePickerView updateDataFormHour:startHour toHour:endHour];
            
        }
        [timePickerView showTimeHourPickerView];
        
    }];
    [self.scrollView addSubview:appointmentSlotsBt];
    
    ///联系人
    self.personNameField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, appointmentSlotsLineLablel.frame.origin.y+appointmentSlotsLineLablel.frame.size.height+4.0f, SIZE_DEVICE_WIDTH-2.0f*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:nil andLeftTipsInfo:TITLE_MYZONE_ORDER_BOOK_TIME_PERSON_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    self.personNameField.delegate = self;
    self.personNameField.returnKeyType = UIReturnKeyDone;
    [self.scrollView addSubview:self.personNameField];
    
    ///分隔线
    UILabel *personNameLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(self.personNameField.frame.origin.x, self.personNameField.frame.origin.y + self.personNameField.frame.size.height + 3.5f, self.personNameField.frame.size.width, 0.5f)];
    personNameLineLablel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.scrollView addSubview:personNameLineLablel];
    
    ///联系电话
    self.phoneNumField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, personNameLineLablel.frame.origin.y+personNameLineLablel.frame.size.height+4.0f, SIZE_DEVICE_WIDTH-2.0f*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:nil andLeftTipsInfo:TITLE_MYZONE_ORDER_BOOK_TIME_PHONE_TIP andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsBlack];
    self.phoneNumField.delegate = self;
    self.phoneNumField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumField.returnKeyType = UIReturnKeyDone;
    [self.scrollView addSubview:self.phoneNumField];
    
    ///分隔线
    UILabel *phoneNumLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(self.phoneNumField.frame.origin.x, self.phoneNumField.frame.origin.y + self.phoneNumField.frame.size.height + 3.5f, self.phoneNumField.frame.size.width, 0.5f)];
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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    ///添加键盘缩放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
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

- (void)changedWithStartHour:(NSString*)startHourStr WithEndHour:(NSString*)endHourStr inView:(QSPTimeHourPickerView*)pickerView
{
    
    self.startHour = startHourStr;
    self.endHour = endHourStr;
    
    NSString *resultStr = [NSString stringWithFormat:@"%@-%@",startHourStr,endHourStr];
    [self.appointmentSlotsField setText:resultStr];
    
}

- (BOOL)checkInputSource
{
    
    BOOL flag = YES;
    
    NSString *selectedDay = nil;
    if (self.calendarView) {
        
        selectedDay = [self.calendarView getSelectedDayStr];
        
    }
    
    if (!selectedDay ) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择预约日期", 1.0f, ^(){})
        flag = NO;
        return flag;
    }
    
    if (!self.startHour || [self.startHour isEqualToString:@""] || !self.endHour || [self.endHour isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择预约时段", 1.0f, ^(){})
        flag = NO;
        return flag;
    }
    
    if (!self.personNameField || [self.personNameField.text isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入联系人名字", 1.0f, ^(){})
        flag = NO;
        return flag;
    }
    
    if (!self.phoneNumField || [self.phoneNumField.text isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入联系人手机号码", 1.0f, ^(){})
        flag = NO;
        return flag;
    }
    
    if (![NSString isValidateMobile:self.phoneNumField.text]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入正确的手机号码格式", 1.0f, ^(){})
        flag = NO;
        return flag;
    }
    
    return flag;
    
}

- (void)addAppointmentOrder
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
//    user_id	true	int	用户id
//    appoint_date	true	string	预定的日期，格式 年-月-日 eg:2015-02-10
//    appoint_start_time	true	string	预定当天的开始时间，格式 时:分 eg:17:00
//    appoint_end_time	true	string	预定当天的结束时间，格式 时:分 eg:18:00
//    buyer_name	true	string	购买者的姓名，前端输入的
//    buyer_phone	true	string	电话号码，一定是11位的手机号码
//    order_type	true	string	订单类型，具体看配置项:ORDERTYPE ,默认为500101也就是一手房购买订单 ,不能为空,500102 二手房，500103出租房 eg: 500101
//    source_id	true	string	来源的房源id，类型可能是二手房，一手房或者是出租房，具体和order_type对应
//    source_ask_for_id	true	string	关联的求租/求购订单id，如果没关联可以不传递，或者传递0
//    saler_id	true	string	出售/出租者id，也就是销售/出租该房子的直接操控者
//    add_type	true	string	添加的类型，不必要填写，主要用与区分是后台添加还是来源客户端，默认是0，也是就是来源客户端的添加
    
    if (!self.houseInfo || (![self.houseInfo isKindOfClass:[QSWSecondHouseInfoDataModel class]] && ![self.houseInfo isKindOfClass:[QSWRentHouseInfoDataModel class]] && ![self.houseInfo isKindOfClass:[QSOrderDetailInfoHouseDataModel class]])) {
        NSLog(@"获取房源信息出错！");
        return;
    }
    
//    //获取用户ID
//    NSString *userID = [QSCoreDataManager getUserID];
//    [tempParam setObject:(userID ? userID : @"1") forKey:@"user_id"];
    [tempParam setObject:[self.calendarView getSelectedDayStr] forKey:@"appoint_date"];
    [tempParam setObject:[self.startHour stringByReplacingOccurrencesOfString:@" " withString:@"0"] forKey:@"appoint_start_time"];
    [tempParam setObject:[self.endHour stringByReplacingOccurrencesOfString:@" " withString:@"0"] forKey:@"appoint_end_time"];
    [tempParam setObject:self.personNameField.text forKey:@"buyer_name"];
    [tempParam setObject:self.phoneNumField.text forKey:@"buyer_phone"];
    [tempParam setObject:@"500102" forKey:@"order_type"];
    [tempParam setObject:@"" forKey:@"source_ask_for_id"];
    [tempParam setObject:@"0" forKey:@"add_type"];
    
    if (self.houseInfo) {
        if ([self.houseInfo isKindOfClass:[QSWSecondHouseInfoDataModel class]]) {
            
            [tempParam setObject:((QSWSecondHouseInfoDataModel*)(self.houseInfo)).id_ forKey:@"source_id"];
            [tempParam setObject:((QSWSecondHouseInfoDataModel*)(self.houseInfo)).user_id forKey:@"saler_id"];
            
        }else if ([self.houseInfo isKindOfClass:[QSWRentHouseInfoDataModel class]]) {
            
            [tempParam setObject:((QSWRentHouseInfoDataModel*)(self.houseInfo)).id_ forKey:@"source_id"];
            [tempParam setObject:((QSWRentHouseInfoDataModel*)(self.houseInfo)).user_id forKey:@"saler_id"];
            
        }else if ([self.houseInfo isKindOfClass:[QSOrderDetailInfoHouseDataModel class]]) {
            
            [tempParam setObject:((QSOrderDetailInfoHouseDataModel*)(self.houseInfo)).id_ forKey:@"source_id"];
            [tempParam setObject:((QSOrderDetailInfoHouseDataModel*)(self.houseInfo)).user_id forKey:@"saler_id"];
            
        }
    }
    
    NSLog(@"请求参数：%@",tempParam);

    [QSRequestManager requestDataWithType:rRequestTypeOrderAddAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///转换模型
        QSPAppointmentOrderReturnData *headerModel = resultData;
        if (rRequestResultTypeSuccess == resultStatus) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
    
                QSPOrderSubmitResultViewController *srVc = [[QSPOrderSubmitResultViewController alloc] initWithResultType:oOrderSubmitResultTypeBookSuccessed andAutoBackCallBack:^(ORDER_SUBMIT_RESULT_BACK_TYPE backType){
                    
                    switch (backType) {
                        case oOrderSubmitResultBackTypeAuto:
                            
                            NSLog(@"auto back");
                            [self.navigationController popViewControllerAnimated:NO];
                            
                            break;
                        case oOrderSubmitResultBackTypeToDetail:
                            
                            NSLog(@"back 查看预约详情");
                            {
                                QSPOrderDetailBookedViewController *bookedVc = [[QSPOrderDetailBookedViewController alloc] init];
                                [bookedVc setOrderID:headerModel.msg];
                                [bookedVc setTurnBackDistanceStep:2];
                                [self.navigationController pushViewController:bookedVc animated:NO];
                                
                            }
                            break;
                        case oOrderSubmitResultBackTypeToMoreHouse:
                            
                            NSLog(@"back 查看推荐房源");
                            
                            break;
                        default:
                            break;
                    }
                    
                    
                }];
                
                [self presentViewController:srVc animated:YES completion:^{
                    
                }];
                
            })
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(bBookResultTypeSucess);
            }
            
        }else{

            TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){})
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(bBookResultTypeFail);
            }
        }
        
        [hud hiddenCustomHUD];
        
    }];
    
}

- (void)resetAppointmentOrder
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
//    user_id	true	int	修改人id
//    appoint_date	true	string	预定的日期,格式2015-06-31
//    oppoint_start_time	true	string	预定的开始时间
//    oppoint_end_time	true	string	预定的结束时间
//    buyer_name	true	string	联系人
//    buyer_phone	true	string	联系电话(11位数字)
//    order_id	true	string	订单id
//    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        NSLog(@"订单ID有错！");
        return;
    }
    
//    //获取用户ID
//    NSString *userID = [QSCoreDataManager getUserID];
//    [tempParam setObject:(userID ? userID : @"1") forKey:@"user_id"];
    [tempParam setObject:[self.calendarView getSelectedDayStr] forKey:@"appoint_date"];
    [tempParam setObject:[self.startHour stringByReplacingOccurrencesOfString:@" " withString:@"0"] forKey:@"appoint_start_time"];
    [tempParam setObject:[self.endHour stringByReplacingOccurrencesOfString:@" " withString:@"0"] forKey:@"appoint_end_time"];
    [tempParam setObject:self.personNameField.text forKey:@"buyer_name"];
    [tempParam setObject:self.phoneNumField.text forKey:@"buyer_phone"];
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    //    NSLog(@"请求参数：%@",tempParam);
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderResetAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///转换模型
        QSPAppointmentOrderReturnData *headerModel = resultData;
        if (rRequestResultTypeSuccess == resultStatus) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                QSPOrderSubmitResultViewController *srVc = [[QSPOrderSubmitResultViewController alloc] initWithResultType:oOrderSubmitResultTypeBookSuccessed andAutoBackCallBack:^(ORDER_SUBMIT_RESULT_BACK_TYPE backType){
                    
                    switch (backType) {
                        case oOrderSubmitResultBackTypeAuto:
                            
                            NSLog(@"auto back");
                            [self.navigationController popViewControllerAnimated:NO];
                            
                            break;
                        case oOrderSubmitResultBackTypeToDetail:
                            
                            NSLog(@"back 查看预约详情");
                        {
                            QSPOrderDetailBookedViewController *bookedVc = [[QSPOrderDetailBookedViewController alloc] init];
                            [bookedVc setOrderID:headerModel.msg];
                            [bookedVc setTurnBackDistanceStep:2];
                            [self.navigationController pushViewController:bookedVc animated:NO];
                            
                        }
                            break;
                        case oOrderSubmitResultBackTypeToMoreHouse:
                            
                            NSLog(@"back 查看推荐房源");
                            
                            break;
                        default:
                            break;
                    }
                    
                    
                }];
                
                [self presentViewController:srVc animated:YES completion:^{
                    
                }];
            })
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(bBookResultTypeSucess);
            }
            
        }else{
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){})
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(bBookResultTypeFail);
            }
        }
        
        [hud hiddenCustomHUD];
        
    }];
    
}

#pragma mark - 请求取消预约订单
- (void)cancelAppointmentOrder
{
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	int	用户id
    //    order_id	true	string	订单id
    //    cause	true	string	取消的原因，字符串（暂定）
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            [self.navigationController popViewControllerAnimated:YES];
        })
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    //TODO:取消原因选择
    [tempParam setObject:@"" forKey:@"cause"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCancelAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        ///转换模型
        if (headerModel) {
            
            if (headerModel&&[headerModel isKindOfClass:[QSHeaderDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                    
                    if (rRequestResultTypeSuccess == resultStatus) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                })
            }
            
        }
        
        [hud hiddenCustomHUD];
        
    }];
}


@end
