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

#import "MJRefresh.h"

#include <objc/runtime.h>

///关联
static char BottomViewKey;  //!<底部按钮关联key
static char RootViewKey;    //!<顶部信息关联key
static char MiddleViewKey;  //!<中间输入框关联key
static char linkManViewKey; //!<联系人关联key
static char phoneViewKey;   //!<联系电话关联key
static char numberViewKey;  //!<报名人数关联key

@interface QSSignUpViewController ()<UITextFieldDelegate>

@property (nonatomic,copy) NSString *activityID;  //!<活动ID
@property (nonatomic,copy) NSString *title;       //!<活动标题
@property (nonatomic,copy) NSString *number;      //!<活动人数
@property (nonatomic,copy) NSString *endTime;     //!<活动结束时间
@property (nonatomic,copy) NSString *houseTitle;  //!<新房名称

@end

@implementation QSSignUpViewController

-(instancetype)initWithtitle:(NSString *)houseTitle
{

    if (self = [super init]) {
        
        self.houseTitle=houseTitle;
        
    }
    
    return self;

}

-(instancetype)initWithactivityID:(NSString*)activityID andTitle:(NSString *)title andNumber:(NSString *)number andEndTime:(NSString *)endTime
{
    
    if (self = [super init]) {
        
        self.activityID=activityID;
        self.title=title;
        self.number=number;
        self.endTime=endTime;
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
    QSScrollView *rootView=[[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-124.0f)];
    [self.view addSubview:rootView];
    objc_setAssociatedObject(self, &RootViewKey, rootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加刷新
    [rootView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getSignUpInfo)];
    
    ///底部按钮
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-60.0f, SIZE_DEVICE_WIDTH, 60.0f)];
    [self.view addSubview:bottomView];
    [self createBottomUI:bottomView];
    objc_setAssociatedObject(self, &BottomViewKey, bottomView, OBJC_ASSOCIATION_ASSIGN);

    [rootView.header beginRefreshing];
}

#pragma mark -创建UI
-(void)createSignUpInfoViewUI
{
    
    QSScrollView *rootView=objc_getAssociatedObject(self, &RootViewKey);
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 83.0f)];
    topView.backgroundColor=COLOR_CHARACTERS_LIGHTYELLOW;
    [rootView addSubview:topView];
    [self createTopUI:topView];
    
    UIView *middleView=[[UIView alloc] initWithFrame:CGRectMake(25.0f, topView.frame.origin.y+topView.frame.size.height, SIZE_DEVICE_WIDTH-50.0f, 44.0f * 3.0f)];
    [rootView addSubview:middleView];
    [self createMiddleUI:middleView];
    objc_setAssociatedObject(self, &MiddleViewKey, middleView, OBJC_ASSOCIATION_ASSIGN);
    
}

-(void)createTopUI:(UIView *)view
{
    
    QSLabel *titleLabel=[[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, SIZE_DEVICE_WIDTH, 20.0f)];
    
    if (self.activityID) {
        
        titleLabel.text=self.title;

    }
    titleLabel.text=self.houseTitle;

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

    UITextField *linkMan = [UITextField createCustomTextFieldWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"联系人:" andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    linkMan.clearButtonMode = UITextFieldViewModeWhileEditing;
    linkMan.delegate = self;
    //linkMan.keyboardType = UIKeyboardTypeASCIICapable;
    [view addSubview:linkMan];
    objc_setAssociatedObject(self, &linkManViewKey, linkMan, OBJC_ASSOCIATION_ASSIGN);
    
    
    ///分隔线
    UILabel *linkManLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,linkMan.frame.size.height- 0.25f, linkMan.frame.size.width,  0.25f)];
    linkManLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:linkManLineLabel];
    
    
    UITextField *phone = [UITextField createCustomTextFieldWithFrame:CGRectMake(0.0f, linkMan.frame.origin.y+linkMan.frame.size.height, view.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"联系人电话:" andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    
    phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    phone.delegate = self;
    phone.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:phone];
    objc_setAssociatedObject(self, &phoneViewKey, phone, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *phoneLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,phone.frame.origin.y+phone.frame.size.height- 0.25f, phone.frame.size.width,  0.25f)];
    phoneLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:phoneLineLabel];
    
    if (self.activityID) {
        
        UITextField *SignUpNum = [UITextField createCustomTextFieldWithFrame:CGRectMake(0.0f, phone.frame.origin.y+phone.frame.size.height, view.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"报名人数:" andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
        
        SignUpNum.clearButtonMode = UITextFieldViewModeWhileEditing;
        SignUpNum.delegate=self;
        SignUpNum.keyboardType=UIKeyboardTypeNumberPad;
        [view addSubview:SignUpNum];
        objc_setAssociatedObject(self, &numberViewKey, SignUpNum, OBJC_ASSOCIATION_ASSIGN);
        
        ///分隔线
        UILabel *SignUpNumLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,SignUpNum.frame.origin.y+SignUpNum.frame.size.height- 0.25f, SignUpNum.frame.size.width,  0.25f)];
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
    
    UITextField *linkManView = objc_getAssociatedObject(self, &linkManViewKey);
    UITextField *phoneView = objc_getAssociatedObject(self, &phoneViewKey);
    UITextField *numberView = objc_getAssociatedObject(self, &numberViewKey);
    
    UIButton *signUpButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        APPLICATION_LOG_INFO(@"提交按钮事件", nil);
        
        ///联系人有效性数据
        NSString *linkManString = linkManView.text;
        if ([linkManString length] <=0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入联系人姓名", 1.0f, ^(){
                
                [linkManView becomeFirstResponder];
                
            })
            return;
        }
        
        
        ///手机有效性数据
        NSString *phoneString = phoneView.text;
        if ([phoneString length] <= 0) {
            
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入手机号码", 1.0f, ^(){
                
                [phoneView becomeFirstResponder];
                
            })
            return;
            
        }
        
        if (![NSString isValidateMobile:phoneString]) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"手机号码应为11位数字，以13/14/15/17/18开头", 1.0f, ^(){
                
                [phoneView becomeFirstResponder];
                
            })
            return;
        }

        ///报名人数有效性数据
        NSString *numberString = numberView.text;
        if ([numberString length] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入报名人数", 1.0f, ^(){
                
                [linkManView becomeFirstResponder];
                
            })
            
            return;
        }
        
        ///回收键盘
        [phoneView resignFirstResponder];
        [numberView resignFirstResponder];
        [linkManView resignFirstResponder];
        
        ///网络请求
        
        
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
    
    UIView *middleView = objc_getAssociatedObject(self, &MiddleViewKey);
    for (UIView *obj in [middleView subviews]) {
        
        if ([obj isKindOfClass:[UITextField class]]) {
            
            [((UITextField *)obj) resignFirstResponder];
            
        }
        
    }
    
}

#pragma mark -创建UI结束刷新
-(void)getSignUpInfo
{

    QSScrollView *rootView=objc_getAssociatedObject(self, &RootViewKey);
    [self createSignUpInfoViewUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rootView.header endRefreshing];
    });


}

@end
