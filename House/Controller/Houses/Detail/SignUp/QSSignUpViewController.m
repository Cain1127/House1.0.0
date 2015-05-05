//
//  QSSignUpViewController.m
//  House
//
//  Created by 王树朋 on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSignUpViewController.h"

#import "UITextField+CustomField.h"
#import "QSTextField.h"
#import "QSCustomHUDView.h"
#import "QSPCalendarView.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+App.h"
#import "QSPAppointmentOrderReturnData.h"

#import "MJRefresh.h"

#include <objc/runtime.h>

@interface QSSignUpViewController ()<UITextFieldDelegate>

@property (nonatomic,copy) NSString *userID;            //!<业主ID
@property (nonatomic,copy) NSString *activityID;        //!<活动ID
@property (nonatomic,copy) NSString *loupanID;          //!<楼盘ID
@property (nonatomic,copy) NSString *title;             //!<活动标题
@property (nonatomic,copy) NSString *number;            //!<活动人数
@property (nonatomic,copy) NSString *endTime;           //!<活动结束时间
@property (nonatomic,copy) NSString *houseTitle;        //!<新房名称
@property (nonatomic,strong) UITextField *linkManView;  //!<联系人UI
@property (nonatomic,strong) UITextField *phoneView;    //!<联系电话UI
@property (nonatomic,strong) UITextField *numberView;   //!<报名人数UI
@property (nonatomic,strong) UIView *middleView;        //!<所有输入框底UI
@property (nonatomic,strong) UIView *bottomView;        //!<底部UI
@property (nonatomic,strong) QSScrollView *rootView;    //!<主UI



@property (nonatomic, strong) QSPCalendarView *calendarView;

@end

@implementation QSSignUpViewController

-(instancetype)initWithtitle:(NSString *)houseTitle andloupanID:(NSString *)loupanID anduserID:(NSString *)userID
{
    
    if (self = [super init]) {
        
        self.houseTitle=houseTitle;
        self.loupanID=loupanID;
        self.userID=userID;
        
    }
    
    return self;
    
}

-(instancetype)initWithactivityID:(NSString*)activityID andTitle:(NSString *)title andNumber:(NSString *)number andEndTime:(NSString *)endTime andloupanID:(NSString *)loupanID anduserID:(NSString *)userID
{
    
    if (self = [super init]) {
        
        self.activityID = activityID;
        self.title = title;
        self.number = number;
        self.endTime = endTime;
        self.loupanID = loupanID;
        self.userID = userID;
    }
    
    return self;
    
}

-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"填写信息"];
    
}

-(void)createMainShowUI
{
    
    [super createMainShowUI];
    ///添加活动主view
    _rootView=[[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-124.0f)];
    [self.view addSubview:_rootView];
    
    ///添加刷新
    [_rootView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getSignUpInfo)];
    
    ///底部按钮
    _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-60.0f, SIZE_DEVICE_WIDTH, 60.0f)];
    [self.view addSubview:_bottomView];
    [self createBottomUI:_bottomView];
    
    [_rootView.header beginRefreshing];
}

#pragma mark -创建UI
-(void)createSignUpInfoViewUI
{
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 83.0f)];
    topView.backgroundColor=COLOR_CHARACTERS_LIGHTYELLOW;
    [_rootView addSubview:topView];
    [self createTopUI:topView];
    
    UIView *middleView=[[UIView alloc] initWithFrame:CGRectMake(25.0f, topView.frame.origin.y+topView.frame.size.height, SIZE_DEVICE_WIDTH-50.0f, 44.0f * 3.0f)];
    [_rootView addSubview:middleView];
    [self createMiddleUI:middleView];
    
}

-(void)createTopUI:(UIView *)view
{
    
    QSLabel *titleLabel=[[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, SIZE_DEVICE_WIDTH, 20.0f)];
    
    if (self.activityID) {
        
        titleLabel.text=self.title;
        
    }
    else if(!self.activityID)
    {
        titleLabel.text=self.houseTitle;
    }
    
    titleLabel.font=[UIFont systemFontOfSize:20.0f];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    [view addSubview:titleLabel];
    
    if (self.activityID) {
        
        QSLabel *signUpLabel=[[QSLabel alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height+8.0f, SIZE_DEVICE_WIDTH*0.5f, 15.0f)];
        signUpLabel.text=[NSString stringWithFormat:@"已报名:%@人",self.number];
        signUpLabel.textAlignment=NSTextAlignmentCenter;
        signUpLabel.font=[UIFont systemFontOfSize:16.0f];
        [view addSubview:signUpLabel];
        
        QSLabel *endTimeLabel=[[QSLabel alloc] initWithFrame:CGRectMake(signUpLabel.frame.size.width, signUpLabel.frame.origin.y, SIZE_DEVICE_WIDTH*0.5f, 15.0f)];
        endTimeLabel.text=[NSString stringWithFormat:@"截止日期:%@",self.endTime];
        endTimeLabel.textAlignment=NSTextAlignmentCenter;
        endTimeLabel.font=[UIFont systemFontOfSize:16.0f];
        [view addSubview:endTimeLabel];
        
    }
    
    
}

-(void)createMiddleUI:(UIView *)view
{
    
    _linkManView = [UITextField createCustomTextFieldWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"联系人:" andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    _linkManView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _linkManView.delegate = self;
    //linkMan.keyboardType = UIKeyboardTypeASCIICapable;
    [view addSubview:_linkManView];
    
    ///分隔线
    UILabel *linkManLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,_linkManView.frame.size.height- 0.25f, _linkManView.frame.size.width,  0.25f)];
    linkManLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:linkManLineLabel];
    
    
    _phoneView = [UITextField createCustomTextFieldWithFrame:CGRectMake(0.0f, _linkManView.frame.origin.y+_linkManView.frame.size.height, view.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"联系人电话:" andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    
    _phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneView.delegate = self;
    //_phoneView.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:_phoneView];
    
    ///分隔线
    UILabel *phoneLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,_phoneView.frame.origin.y+_phoneView.frame.size.height- 0.25f, _phoneView.frame.size.width,  0.25f)];
    phoneLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:phoneLineLabel];
    
    if (self.activityID) {
        
        _numberView = [UITextField createCustomTextFieldWithFrame:CGRectMake(0.0f, _phoneView.frame.origin.y+_phoneView.frame.size.height, view.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"报名人数:" andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
        
        _numberView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberView.delegate=self;
        // _numberView.keyboardType=UIKeyboardTypeNumberPad;
        [view addSubview:_numberView];
        
        ///分隔线
        UILabel *SignUpNumLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,_numberView.frame.origin.y+_numberView.frame.size.height- 0.25f, _numberView.frame.size.width,  0.25f)];
        SignUpNumLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
        [view addSubview:SignUpNumLineLabel];
        
    }
    
}

-(void)createBottomUI:(UIView *)view
{
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLabel];
    
    QSBlockButtonStyleModel *buttonStyle=[[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor=COLOR_CHARACTERS_YELLOW;
    buttonStyle.title=@"提交";
    buttonStyle.cornerRadio=6.0f;
    buttonStyle.titleNormalColor=COLOR_CHARACTERS_BLACK;
    
    UIButton *signUpButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        
        ///联系人有效性数据
        NSString *linkManString = _linkManView.text;
        if ([linkManString length] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入联系人姓名", 1.0f, ^(){
                
                [_linkManView becomeFirstResponder];
                
            })
            return;
        }
        
        
        ///手机有效性数据
        NSString *phoneString = _phoneView.text;
        if ([phoneString length] <= 0) {
            
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入手机号码", 1.0f, ^(){
                
                [_phoneView becomeFirstResponder];
                
            })
            return;
            
        }
        
        if (![NSString isValidateMobile:phoneString]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"手机号码应为11位数字，以13/14/15/17/18开头", 1.0f, ^(){
                
                [_phoneView becomeFirstResponder];
                
            })
            return;
        }
        
        if (self.activityID) {
            
            ///报名人数有效性数据
            NSString *numberString = _numberView.text;
            if ([numberString length] <= 0) {
                
                TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入报名人数", 1.0f, ^(){
                    
                    [_linkManView becomeFirstResponder];
                    
                })
                
                return;
            }
        }
        ///回收键盘
        [_linkManView resignFirstResponder];
        [_phoneView resignFirstResponder];
        [_numberView resignFirstResponder];
        
        ///网络请求
        [self postSignUpInfo];
        
    }];
    [view addSubview:signUpButton];
    
}

#pragma mark - 回调键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for (UIView *obj in [self.middleView subviews]) {
        
        if ([obj isKindOfClass:[UITextField class]]) {
            
            [((UITextField *)obj) resignFirstResponder];
            
        }
        
    }
    
}

#pragma mark -创建UI结束刷新
-(void)getSignUpInfo
{
    
    [self createSignUpInfoViewUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_rootView.header endRefreshing];
        
    });
    
}

- (void)postSignUpInfo
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
    
    //TODO:获取用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    [tempParam setObject:(userID ? userID : @"1") forKey:@"user_id"];
    [tempParam setObject:@" " forKey:@"appoint_date"];
    [tempParam setObject:@" " forKey:@"appoint_start_time"];
    [tempParam setObject:@" " forKey:@"appoint_end_time"];
    [tempParam setObject:self.linkManView.text forKey:@"buyer_name"];
    [tempParam setObject:self.phoneView.text forKey:@"buyer_phone"];
    [tempParam setObject:@"500101" forKey:@"order_type"];
    [tempParam setObject:self.loupanID ? self.loupanID : @" " forKey:@"source_id"];
    [tempParam setObject:@"0" forKey:@"source_ask_for_id"];
    [tempParam setObject:self.userID forKey:@"saler_id"];
    [tempParam setObject:@"0" forKey:@"add_type"];
    
    NSLog(@"请求参数：%@",tempParam);
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderAddAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///转换模型
        QSPAppointmentOrderReturnData *headerModel = resultData;
        if (rRequestResultTypeSuccess == resultStatus) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                
                [self.navigationController popViewControllerAnimated:YES];
                
            })
            
        }else{
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){})
        }
        
        [hud hiddenCustomHUD];
        
    }];
    
}
@end
