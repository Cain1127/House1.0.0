//
//  QSYContactOrderInfoView.m
//  House
//
//  Created by ysmeng on 15/4/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactOrderInfoView.h"

#import "NSDate+Formatter.h"

#import "QSYAskListOrderInfosModel.h"

#import <objc/runtime.h>

///关联
static char CommunityKey;   //!<小区名关联
static char OrderStatusKey; //!<订单状态
static char UserNameKey;    //!<订单的预约人名
static char AppointTimeKey; //!<订单预约人的联系方式

@implementation QSYContactOrderInfoView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        [self createContactOrderInfoUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createContactOrderInfoUI
{

    ///小区
    UILabel *communityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 160.0f, 20.0f)];
    communityLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [self addSubview:communityLabel];
    objc_setAssociatedObject(self, &CommunityKey, communityLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///订单状态
    UILabel *orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 120.0f, 20.0f, 120.0f, 20.0f)];
    orderStatusLabel.textAlignment = NSTextAlignmentRight;
    orderStatusLabel.textColor = COLOR_CHARACTERS_YELLOW;
    orderStatusLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [self addSubview:orderStatusLabel];
    objc_setAssociatedObject(self, &OrderStatusKey, orderStatusLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///预约客户
    UILabel *appointUserNameTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, communityLabel.frame.origin.y + communityLabel.frame.size.height + 10.0f, 80.0f, 15.0f)];
    appointUserNameTipsLabel.text = @"预约客户:";
    appointUserNameTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    appointUserNameTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [self addSubview:appointUserNameTipsLabel];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(appointUserNameTipsLabel.frame.origin.x + appointUserNameTipsLabel.frame.size.width + 5.0f, appointUserNameTipsLabel.frame.origin.y, 160.0f, 15.0f)];
    userNameLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self addSubview:userNameLabel];
    objc_setAssociatedObject(self, &UserNameKey, userNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///预约时间
    UILabel *appointTimeTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, appointUserNameTipsLabel.frame.origin.y + appointUserNameTipsLabel.frame.size.height + 5.0f, 80.0f, 15.0f)];
    appointTimeTipsLabel.text = @"预约时间:";
    appointTimeTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    appointTimeTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [self addSubview:appointTimeTipsLabel];
    
    UILabel *appointTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(appointTimeTipsLabel.frame.origin.x + appointTimeTipsLabel.frame.size.width + 5.0f, appointTimeTipsLabel.frame.origin.y, 160.0f, 15.0f)];
    appointTimeLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self addSubview:appointTimeLabel];
    objc_setAssociatedObject(self, &AppointTimeKey, appointTimeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 0.25f, self.frame.size.width, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:sepLabel];

}

#pragma mark - 刷新UI
/**
 *  @author         yangshengmeng, 15-04-04 11:04:34
 *
 *  @brief          更新用户联系人中，订单的信息
 *
 *  @param model    数据模型
 *
 *  @since          1.0.0
 */
- (void)updateContactOrderInfo:(QSYAskListOrderInfosModel *)model
{

    [self updateAppointedTime:[NSString stringWithFormat:@"%@ %@",model.appoint_date,model.appoint_start_time]];
    [self updateOrderStatus:[NSString getCurrentUserStatusTitleWithStatus:model.order_status andSalerID:model.saler_id andBuyerID:model.buyer_id]];
    [self updateAppointedUserName:model.buyer_name];
    [self updateCommunityInfo:model.buyer_name];

}

///更新用户名
- (void)updateAppointedTime:(NSString *)info
{
    
    UILabel *tempLabel = objc_getAssociatedObject(self, &AppointTimeKey);
    if (tempLabel && [info length] > 0) {
        
        tempLabel.text = info;
        
    }
    
}

///更新用户名
- (void)updateOrderStatus:(NSString *)info
{
    
    UILabel *tempLabel = objc_getAssociatedObject(self, &OrderStatusKey);
    if (tempLabel && [info length] > 0) {
        
        tempLabel.text = info;
        
    }
    
}

///更新用户名
- (void)updateAppointedUserName:(NSString *)info
{

    UILabel *tempLabel = objc_getAssociatedObject(self, &UserNameKey);
    if (tempLabel && [info length] > 0) {
        
        tempLabel.text = info;
        
    }

}

///更新小区
- (void)updateCommunityInfo:(NSString *)info
{

    UILabel *tempLabel = objc_getAssociatedObject(self, &CommunityKey);
    if (tempLabel && [info length] > 0) {
        
        tempLabel.text = info;
        
    }

}

@end
