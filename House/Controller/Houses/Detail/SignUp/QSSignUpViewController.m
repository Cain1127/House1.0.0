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
static char RootViewKey;     //!<顶部信息关联key

@interface QSSignUpViewController ()

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
    
}

-(void)createTopUI:(UIView *)view
{
    
    QSLabel *titleLabel=[[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, SIZE_DEVICE_WIDTH, 20.0f)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    if (self.activityID) {
        
        titleLabel.text=self.title;

    }
    titleLabel.text=self.houseTitle;

    titleLabel.font=[UIFont systemFontOfSize:20.0f];
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
    [view addSubview:linkMan];
    
    ///分隔线
    UILabel *linkManLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,linkMan.frame.size.height- 0.25f, linkMan.frame.size.width,  0.25f)];
    linkManLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:linkManLineLabel];
    
    
    UITextField *phone=[UITextField createCustomTextFieldWithFrame:CGRectMake(0.0f, linkMan.frame.origin.y+linkMan.frame.size.height, view.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"联系人电话:" andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
    phone.clearButtonMode=UITextFieldViewModeWhileEditing;
    [view addSubview:phone];
    
    ///分隔线
    UILabel *phoneLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,phone.frame.origin.y+phone.frame.size.height- 0.25f, phone.frame.size.width,  0.25f)];
    phoneLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:phoneLineLabel];
    
    if (self.activityID) {
        
        UITextField *SignUpNum=[UITextField createCustomTextFieldWithFrame:CGRectMake(0.0f, phone.frame.origin.y+phone.frame.size.height, view.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"报名人数:" andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleLeftTipsGray];
        SignUpNum.clearButtonMode=UITextFieldViewModeWhileEditing;
        [view addSubview:SignUpNum];
        
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
    
    
    UIButton *signUpButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        APPLICATION_LOG_INFO(@"提交按钮事件", nil);
        
    }];
    [view addSubview:signUpButton];
    
}

-(void)getSignUpInfo
{

    QSScrollView *rootView=objc_getAssociatedObject(self, &RootViewKey);
    [self createSignUpInfoViewUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rootView.header endRefreshing];
    });


}

@end
