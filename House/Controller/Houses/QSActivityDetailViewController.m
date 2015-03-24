//
//  QSActivityDetailViewController.m
//  House
//
//  Created by 王树朋 on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSActivityDetailViewController.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"
#import "QSBlockButton.h"
#import "QSBlockButtonStyleModel.h"
#import "QSScrollView.h"
#import "QSLabel.h"
#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"

#import "QSActivityDataModel.h"

#include <objc/runtime.h>

///关联
static char BottomViewKey;  //!<底部按钮关联key
static char RootViewKey;     //!<顶部信息关联key


@interface QSActivityDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain) QSActivityDataModel *activityModel; //!<活动详情模型

@end

@implementation QSActivityDetailViewController

///初始化
-(instancetype)initWithModel:(QSActivityDataModel*)dataModel
{
    
    if (self=[super init]) {
        
        self.activityModel=dataModel;
        
    }
    
    return self;
}


-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"活动详情"];
    
}

-(void)createMainShowUI
{
    
    [super createMainShowUI];
    ///添加活动主view
    QSScrollView *rootView=[[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-128.0f)];
    [self.view addSubview:rootView];
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 83.0f)];
    topView.backgroundColor=COLOR_CHARACTERS_LIGHTYELLOW;
    [rootView addSubview:topView];
    [self createTopUI:topView];
    
    ///头图片
    QSImageView *headerImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, topView.frame.origin.y+topView.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_WIDTH * 562.0f / 750.0f)];
    [headerImageView loadImageWithURL:[self.activityModel.attach_file getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_DETAIL_HEADER_DEFAULT_BG]];
    [rootView addSubview:headerImageView];
    
    ///活动说明
    QSLabel *explainView=[[QSLabel alloc] initWithFrame:CGRectMake(30.0f, headerImageView.frame.origin.y+headerImageView.frame.size.height+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH-60.0f, SIZE_DEVICE_HEIGHT-60.0f-64.0f-topView.frame.size.height-headerImageView.frame.size.height)];
    explainView.text=self.activityModel.content;
    explainView.backgroundColor=[UIColor whiteColor];
    explainView.font=[UIFont systemFontOfSize:16.0f];
    [rootView addSubview:explainView];
    
    rootView.delegate=self;
    rootView.scrollEnabled=YES;
    rootView.contentSize=CGSizeMake(SIZE_DEVICE_WIDTH, rootView.frame.size.height+500.0f);
    objc_setAssociatedObject(self, &RootViewKey, rootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///底部按钮
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT-60.0f, SIZE_DEVICE_WIDTH, 60.0f)];
    [self.view addSubview:bottomView];
    [self createBottomUI:bottomView];
    objc_setAssociatedObject(self, &BottomViewKey, bottomView, OBJC_ASSOCIATION_ASSIGN);
    
}

-(void)createTopUI:(UIView *)view
{
    
    QSLabel *titleLabel=[[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, SIZE_DEVICE_WIDTH, 20.0f)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=self.activityModel.title;
    titleLabel.font=[UIFont systemFontOfSize:20.0f];
    [view addSubview:titleLabel];
    
    QSLabel *signUpLabel=[[QSLabel alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height+8.0f, SIZE_DEVICE_WIDTH*0.5f, 15.0f)];
    signUpLabel.text=[NSString stringWithFormat:@"已报名:%@人",self.activityModel.people_num];
    signUpLabel.textAlignment=NSTextAlignmentCenter;
    signUpLabel.font=[UIFont systemFontOfSize:16.0f];
    [view addSubview:signUpLabel];
    
    QSLabel *endTimeLabel=[[QSLabel alloc] initWithFrame:CGRectMake(signUpLabel.frame.size.width, signUpLabel.frame.origin.y, SIZE_DEVICE_WIDTH*0.5f, 15.0f)];
    endTimeLabel.text=[NSString stringWithFormat:@"截止日期:%@",self.activityModel.end_time];
    endTimeLabel.textAlignment=NSTextAlignmentCenter;
    endTimeLabel.font=[UIFont systemFontOfSize:16.0f];
    [view addSubview:endTimeLabel];
}

-(void)createBottomUI:(UIView *)view
{
    
//    UIView *view=objc_getAssociatedObject(self, &BottomViewKey);
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLabel];
    
    QSBlockButtonStyleModel *buttonStyle=[[QSBlockButtonStyleModel alloc] init];
    buttonStyle.bgColor=COLOR_CHARACTERS_YELLOW;
    buttonStyle.title=@"马上报名";
    buttonStyle.cornerRadio=6.0f;
    buttonStyle.titleNormalColor=COLOR_CHARACTERS_BLACK;
    
    UIButton *signUpButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        APPLICATION_LOG_INFO(@"马上报名按钮事件", nil);
        
    }];
    [view addSubview:signUpButton];
    
}

@end
