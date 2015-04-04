//
//  QSYContactAppointmentCreditInfoView.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactAppointmentCreditInfoView.h"
#import "QSYContactDetailInfoModel.h"

#import <objc/runtime.h>

static char ReplyRateKey;       //!<回复率
static char AppointCountKey;    //!<回复率
static char CoolCountKey;       //!<回复率

@implementation QSYContactAppointmentCreditInfoView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createContactAppoinmentCreditUI
{
    
    ///每一项内空的宽度
    CGFloat width = self.frame.size.width / 3.0f;
    
    ///回复率
    UILabel *replyRateLabel = [[UILabel alloc] initWithFrame:CGRectMake((width - 55.0f) / 2.0f, 20.0f, 40.0f, 20.0f)];
    replyRateLabel.textAlignment = NSTextAlignmentRight;
    replyRateLabel.textColor = COLOR_CHARACTERS_YELLOW;
    replyRateLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self addSubview:replyRateLabel];
    objc_setAssociatedObject(self, &ReplyRateKey, replyRateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *replyUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(replyRateLabel.frame.origin.x + replyRateLabel.frame.size.width, replyRateLabel.frame.origin.y + 5.0f, 15.0f, 15.0f)];
    replyUnitLabel.text = @"%";
    replyUnitLabel.textColor = COLOR_CHARACTERS_LIGHTLIGHTGRAY;
    [self addSubview:replyUnitLabel];
    
    UILabel *replyTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, replyRateLabel.frame.origin.y + replyRateLabel.frame.size.height, width, 20.0f)];
    replyTipsLabel.text = @"在线回复率";
    replyTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    replyTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:replyTipsLabel];
    
    ///分隔线
    UILabel *replySepLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 3.0f, 20.0f, 0.25, 40.0f)];
    replySepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:replySepLabel];
    
    ///预约次数
    UILabel *appointCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - 55.0f / 2.0f, 20.0f, 40.0f, 20.0f)];
    appointCountLabel.textAlignment = NSTextAlignmentRight;
    appointCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    appointCountLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self addSubview:appointCountLabel];
    objc_setAssociatedObject(self, &AppointCountKey, appointCountLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *appointCountUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(appointCountLabel.frame.origin.x + appointCountLabel.frame.size.width, appointCountLabel.frame.origin.y + 5.0f, 15.0f, 15.0f)];
    appointCountUnitLabel.text = @"次";
    appointCountUnitLabel.textColor = COLOR_CHARACTERS_LIGHTLIGHTGRAY;
    [self addSubview:appointCountUnitLabel];
    
    UILabel *appointCountTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - width) / 2.0f, appointCountUnitLabel.frame.origin.y + appointCountUnitLabel.frame.size.height, width, 20.0f)];
    appointCountTipsLabel.text = @"预约次数";
    appointCountTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    appointCountTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:appointCountTipsLabel];
    
    ///分隔线
    UILabel *appointSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 3.0f * 2.0f, 20.0f, 0.25, 40.0f)];
    appointSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:appointSepLabel];
    
    ///爽约率
    UILabel *coolRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - width / 2.0f, 20.0f, 40.0f, 20.0f)];
    coolRateLabel.textAlignment = NSTextAlignmentRight;
    coolRateLabel.textColor = COLOR_CHARACTERS_YELLOW;
    coolRateLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self addSubview:coolRateLabel];
    objc_setAssociatedObject(self, &CoolCountKey, coolRateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *coolRateUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(coolRateLabel.frame.origin.x + coolRateLabel.frame.size.width, coolRateLabel.frame.origin.y + 5.0f, 15.0f, 15.0f)];
    coolRateUnitLabel.text = @"%";
    coolRateUnitLabel.textColor = COLOR_CHARACTERS_LIGHTLIGHTGRAY;
    [self addSubview:coolRateUnitLabel];
    
    UILabel *coolRateTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - width, coolRateUnitLabel.frame.origin.y + coolRateUnitLabel.frame.size.height, width, 20.0f)];
    coolRateTipsLabel.text = @"爽约次数";
    coolRateTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    coolRateTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:coolRateTipsLabel];

    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 0.25f, self.frame.size.width, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:sepLabel];
    
}

#pragma mark - UI搭建
/**
 *  @author             yangshengmeng, 15-04-03 18:04:39
 *
 *  @brief              刷新联系人信用信息
 *
 *  @param userModel    联系人数据模型
 *
 *  @since              1.0.0
 */
- (void)updateContactInfoUI:(QSYContactDetailInfoModel *)userModel
{

    [self updateCoolRate:userModel.break_rate];
    [self updateAppointCount:userModel.reply_rate];
    [self updateReplyRate:userModel.reservation_num];

}

///更新回复率
- (void)updateCoolRate:(NSString *)replyRate
{
    
    UILabel *label = objc_getAssociatedObject(self, &CoolCountKey);
    if (label && [replyRate length] > 0) {
        
        label.text = replyRate;
        
    }
    
}

///更新回复率
- (void)updateAppointCount:(NSString *)replyRate
{
    
    UILabel *label = objc_getAssociatedObject(self, &AppointCountKey);
    if (label && [replyRate length] > 0) {
        
        label.text = replyRate;
        
    }
    
}

///更新回复率
- (void)updateReplyRate:(NSString *)replyRate
{

    UILabel *label = objc_getAssociatedObject(self, &ReplyRateKey);
    if (label && [replyRate length] > 0) {
        
        label.text = replyRate;
        
    }

}

@end
