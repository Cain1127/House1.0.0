//
//  QSNewHouseActivityView.m
//  House
//
//  Created by ysmeng on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNewHouseActivityView.h"

#import "NSDate+Formatter.h"

#import "QSActivityDataModel.h"

#import <objc/runtime.h>

///关联
static char DateLeftKey;        //!<剩余天数关联
static char HourLeftKey;        //!<小时剩余天数关联
static char MiniLeftKey;        //!<分钟剩余天数关联
static char SecondLeftKey;      //!<秒数

static char InfoRootViewKey;    //!<信息的底view

static char EndDataKey;         //!<结束日期关联
static char CommitedCountKey;   //!<已报名人数关联

@interface QSNewHouseActivityView ()

@property (nonatomic,assign) CGFloat totalTime;                     //!<总的活动时间
@property (nonatomic,copy) void(^signupButtonCallBack)(BOOL flag);  //!<报名按钮回调

@end

@implementation QSNewHouseActivityView

#pragma mark - 初始化
///初始化
/**
 *  @author                     yangshengmeng, 15-03-11 12:03:16
 *
 *  @brief                      根据报名按钮点击后的回调，创建活动页面
 *
 *  @param frame                大小和位置
 *  @param signButtonCallBack   点击报名按钮的回调
 *
 *  @return                     返回活动页
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSignUpButtonCallBack:(void(^)(BOOL flag))signButtonCallBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
        
        ///保存回调
        if (signButtonCallBack) {
            
            self.signupButtonCallBack = signButtonCallBack;
            
        }
        
        ///UI搭建
        [self createNewHouseActivityViewUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createNewHouseActivityViewUI
{
    
    ///图片宽度
    CGFloat widthOfImage = self.frame.size.height * 40.0f / 253.0f;
    
    ///左右图片
    QSImageView *leftImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, widthOfImage, self.frame.size.height)];
    leftImageView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_NEW_ACTIVITY_LEFT];
    [self addSubview:leftImageView];
    
    QSImageView *rightImageView = [[QSImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - widthOfImage, 0.0f, widthOfImage, self.frame.size.height)];
    rightImageView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_NEW_ACTIVITY_RIGHT];
    [self addSubview:rightImageView];
    
    ///计时信息底view
    UIView *infoRootView = [[UIView alloc] initWithFrame:CGRectMake(widthOfImage + 15.0f, 15.0f, self.frame.size.width - 2.0f * (widthOfImage + 15.0f), self.frame.size.height - 30.0f)];
    [self addSubview:infoRootView];
    objc_setAssociatedObject(self, &InfoRootViewKey, infoRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///天数
    UILabel *dateNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 25.0f)];
    dateNumLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    dateNumLabel.textColor = COLOR_CHARACTERS_BLACK;
    dateNumLabel.textAlignment = NSTextAlignmentRight;
    dateNumLabel.text = @"121";
    [infoRootView addSubview:dateNumLabel];
    objc_setAssociatedObject(self, &DateLeftKey, dateNumLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *dateUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateNumLabel.frame.origin.x + dateNumLabel.frame.size.width, dateNumLabel.frame.origin.y + 10.0f, 15.0f, 15.0f)];
    dateUnitLabel.text = @"天";
    dateUnitLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [infoRootView addSubview:dateUnitLabel];
    
    ///小时
    UILabel *hourNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateUnitLabel.frame.origin.x + dateUnitLabel.frame.size.width, dateNumLabel.frame.origin.y, 40.0f, dateNumLabel.frame.size.height)];
    hourNumLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    hourNumLabel.textColor = COLOR_CHARACTERS_BLACK;
    hourNumLabel.textAlignment = NSTextAlignmentRight;
    hourNumLabel.text = @"11";
    [infoRootView addSubview:hourNumLabel];
    objc_setAssociatedObject(self, &HourLeftKey, hourNumLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *hourUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(hourNumLabel.frame.origin.x + hourNumLabel.frame.size.width, dateUnitLabel.frame.origin.y, 30.0f, 15.0f)];
    hourUnitLabel.text = @"小时";
    hourUnitLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [infoRootView addSubview:hourUnitLabel];
    
    ///分
    UILabel *miniNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(hourUnitLabel.frame.origin.x + hourUnitLabel.frame.size.width, dateNumLabel.frame.origin.y, 40.0f, dateNumLabel.frame.size.height)];
    miniNumLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    miniNumLabel.textColor = COLOR_CHARACTERS_BLACK;
    miniNumLabel.textAlignment = NSTextAlignmentRight;
    miniNumLabel.text = @"30";
    [infoRootView addSubview:miniNumLabel];
    objc_setAssociatedObject(self, &MiniLeftKey, miniNumLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *miniUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(miniNumLabel.frame.origin.x + miniNumLabel.frame.size.width, dateUnitLabel.frame.origin.y, 15.0f, 15.0f)];
    miniUnitLabel.text = @"分";
    miniUnitLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [infoRootView addSubview:miniUnitLabel];
    
    ///秒
    UILabel *secondNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(miniUnitLabel.frame.origin.x + miniUnitLabel.frame.size.width, dateNumLabel.frame.origin.y, 40.0f, dateNumLabel.frame.size.height)];
    secondNumLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    secondNumLabel.textColor = COLOR_CHARACTERS_BLACK;
    secondNumLabel.textAlignment = NSTextAlignmentRight;
    secondNumLabel.text = @"50";
    [infoRootView addSubview:secondNumLabel];
    objc_setAssociatedObject(self, &SecondLeftKey, secondNumLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *secondUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondNumLabel.frame.origin.x + secondNumLabel.frame.size.width, dateUnitLabel.frame.origin.y, 15.0f, 15.0f)];
    secondUnitLabel.text = @"秒";
    secondUnitLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [infoRootView addSubview:secondUnitLabel];
    
    ///结束提示
    UILabel *endTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoRootView.frame.size.width - 45.0f, dateUnitLabel.frame.origin.y, 45.0f, 20.0f)];
    endTipsLabel.text = @"后结束";
    endTipsLabel.textAlignment = NSTextAlignmentRight;
    endTipsLabel.font =[UIFont systemFontOfSize:FONT_BODY_14];
    [infoRootView addSubview:endTipsLabel];
    
    ///日期
    UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateNumLabel.frame.origin.x, dateNumLabel.frame.origin.y + dateNumLabel.frame.size.height + 5.0f, 80.0f, 20.0f)];
    endDateLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    endDateLabel.text = @"2015-01-01";
    [infoRootView addSubview:endDateLabel];
    objc_setAssociatedObject(self, &EndDataKey, endDateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///看房团说明
    UILabel *lookedTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(endDateLabel.frame.origin.x+ endDateLabel.frame.size.width + 5.0f, endDateLabel.frame.origin.y, 90.0f, 20.0f)];
    lookedTipsLabel.text = @"看房团报名中";
    lookedTipsLabel.textAlignment = NSTextAlignmentRight;
    lookedTipsLabel.font =[UIFont systemFontOfSize:FONT_BODY_14];
    [infoRootView addSubview:lookedTipsLabel];
    
    ///已报名
    UILabel *havedTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoRootView.frame.size.width - 80.0f, endDateLabel.frame.origin.y, 80.0f, 20.0f)];
    havedTipsLabel.text = @"已报名119名";
    havedTipsLabel.textAlignment = NSTextAlignmentRight;
    havedTipsLabel.font =[UIFont systemFontOfSize:FONT_BODY_14];
    [infoRootView addSubview:havedTipsLabel];
    objc_setAssociatedObject(self, &CommitedCountKey, havedTipsLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///报名按钮
    UIButton *signUpButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, infoRootView.frame.size.height - 44.0f, self.frame.size.width - 2.0f * widthOfImage - 30.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
    }];
    [signUpButton setTitle:@"马上报名" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUpButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    signUpButton.backgroundColor = [UIColor redColor];
    signUpButton.layer.cornerRadius = 6.0f;
    [infoRootView addSubview:signUpButton];

}

#pragma mark - 刷新UI
/**
 *  @author         yangshengmeng, 15-03-11 12:03:37
 *
 *  @brief          根据给定的数据模型，更新活动UI
 *
 *  @param model    活动模型
 *
 *  @since          1.0.0
 */
- (void)updateNewHouseActivityUI:(QSActivityDataModel *)model
{

    ///更新活动结束日期
    UILabel *endDataLabel = objc_getAssociatedObject(self, &EndDataKey);
    endDataLabel.text = [[NSDate formatNSTimeToNSDateString:model.end_time] substringToIndex:10];
    
    ///已报名人数
    UILabel *commitLabel = objc_getAssociatedObject(self, &CommitedCountKey);
    commitLabel.text = [NSString stringWithFormat:@"已报名%@名",model.people_num];
    
    ///更新倒计时
    CGFloat activityTime = [model.end_time floatValue];
    CGFloat currentTime = [[NSDate currentDateTimeStamp] floatValue];
    CGFloat timeStampGap = activityTime - currentTime;
    
    if (timeStampGap > 0.0f) {
        
        ///保存总时长
        self.totalTime = timeStampGap;
        
        ///开始倒计时
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCountdownInfo:) userInfo:nil repeats:YES];
        [timer fire];
        
    } else {
    
        ///显示活动过期
        [self activityOverTime];
    
    }

}

#pragma mark - 开始倒计时
///开始倒计时
- (void)updateCountdownInfo:(NSTimer *)timer
{
    
    ///时间控件
    UILabel *dateLabel = objc_getAssociatedObject(self, &DateLeftKey);
    UILabel *hourLabel = objc_getAssociatedObject(self, &HourLeftKey);
    UILabel *miniLabel = objc_getAssociatedObject(self, &MiniLeftKey);
    UILabel *secondLabel = objc_getAssociatedObject(self, &SecondLeftKey);
    
    ///如果倒计时已经小于一秒，则显示活动过期
    if (self.totalTime <= 0.0f) {
        
        ///停止定时器
        [timer invalidate];
        timer = nil;
        [self activityOverTime];
        return;
        
    }
    
    ///将秒数转为整数
    NSInteger sumSecond = (NSInteger)self.totalTime;
    
    ///更新秒数
    NSInteger leftSecond = sumSecond % 60;
    sumSecond = (sumSecond - leftSecond) / 60;
    secondLabel.text = [NSString stringWithFormat:@"%d",(int)leftSecond];
    
    ///更新分钟数
    NSInteger leftMini = sumSecond % 60;
    sumSecond = sumSecond / 60;
    miniLabel.text = [NSString stringWithFormat:@"%d",(int)leftMini];
    
    ///更新倒计时的小时
    NSInteger leftHour = sumSecond % 60;
    sumSecond = sumSecond / 24;
    hourLabel.text = [NSString stringWithFormat:@"%d",(int)leftHour];
    
    ///更新倒计时的天数
    dateLabel.text = [NSString stringWithFormat:@"%d",(int)sumSecond];
    
    ///更新秒数
    self.totalTime = self.totalTime - 1.0f;

}

#pragma mark - 显示活动过期
///显示活动过期
- (void)activityOverTime
{

    ///清空原信息
    UIView *rootView = objc_getAssociatedObject(self, &InfoRootViewKey);
    
    for (UIView *obj in [rootView subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///显示已过期
    UILabel *overTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, rootView.frame.size.width - 20.0f, rootView.frame.size.height - 20.0f)];
    overTimeLabel.text = @"活动已结束";
    overTimeLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    overTimeLabel.textAlignment = NSTextAlignmentCenter;
    overTimeLabel.textColor = COLOR_CHARACTERS_GRAY;
    [rootView addSubview:overTimeLabel];

}

@end
