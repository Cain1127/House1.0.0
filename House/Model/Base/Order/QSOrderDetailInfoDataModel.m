//
//  QSOrderDetailInfoDataModel.m
//  House
//
//  Created by CoolTea on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderDetailInfoDataModel.h"

@implementation QSOrderDetailInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
//    RKObjectMapping *shared_mapping = nil;
//    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
     RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house_msg" toKeyPath:@"house_msg" withMapping:[QSOrderDetailInfoHouseDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"appoint_list" toKeyPath:@"appoint_list" withMapping:[QSOrderDetailAppointTimeDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"saler_msg" toKeyPath:@"saler_msg" withMapping:[QSOrderListOrderInfoPersonInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}


- (void)setAllViewsFlagWithFlag:(BOOL)flag
{
    //重置Flag
    self.isShowTitleView = flag;
    self.isShowShowingsTimeView = flag;
    self.isShowShowingsActivitiesView = flag;
    self.isShowHouseInfoView = flag;
    self.isShowHousePriceView = flag;
    self.isShowAddressView = flag;
    self.isShowOwnerInfoView = flag;
    self.isShowActivitiesPhoneView = flag;
    self.isShowOtherPriceView = flag;
    self.isShowMyPriceView = flag;
    self.isShowInputMyPriceView = flag;
    self.isShowTransactionPriceView = flag;
    self.isShowBargainingPriceHistoryView = flag;
    self.isShowRemarkRejectPriceView = flag;
    self.isShowOrderCancelByOwnerTipView = flag;
    self.isShowCommentNoteTipsView = flag;
    self.isShowOrderCancelByMeTipView = flag;
    self.isShowComplaintAndCommentButtonView = flag;
    self.isShowAppointAgainAndPriceAgainButtonView = flag;
    self.isShowAppointAgainAndRejectPriceButtonView = flag;
    self.isShowRejectAndAcceptAppointmentButtonView = flag;
    self.isShowCancelTransAndWarmBuyerButtonView = flag;
    self.isShowChangeOrderButtonView = flag;
    self.isShowConfirmOrderButtonView = flag;
    self.isShowSubmitPriceButtonView = flag;
    self.isShowAppointmentSalerAgainButtonView = flag;
    self.isShowChangeAppointmentButtonView = flag;
    
}

- (void)updateViewsFlags
{
    
    [self setAllViewsFlagWithFlag:NO];
    
    
    
    
}

@end


@implementation QSOrderDetailAppointTimeDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"time"
                                                    ]];
    
    return shared_mapping;
    
}

@end


@implementation QSOrderDetailInfoHouseDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///继承
     RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"user_id",
                                                    @"title_second",
                                                    @"village_id",
                                                    @"village_name",
                                                    @"introduce",
                                                    @"content",
                                                    @"floor_num",
                                                    @"floor_which",
                                                    @"house_nature",
                                                    @"building_year",
                                                    @"house_face",
                                                    @"decoration_type",
                                                    @"building_structure",
                                                    @"used_year",
                                                    @"installation",
                                                    @"features",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"elevator",
                                                    @"cycle",
                                                    @"time_interval_start",
                                                    @"time_interval_end",
                                                    @"name",
                                                    @"tel",
                                                    @"entrust",
                                                    @"entrust_company",
                                                    @"view_count",
                                                    @"provinceid",
                                                    @"areaid",
                                                    @"commend",
                                                    @"update_time",
                                                    @"sort_desc",
                                                    @"status",
                                                    @"create_time",
                                                    @"video_url",
                                                    @"reservation_num",
                                                    @"property_type",
                                                    @"attention_count",
                                                    @"favorite_count",
                                                    @"tj_condition",
                                                    @"tj_environment",
                                                    @"coordinate_x",
                                                    @"coordinate_y"]];
    return shared_mapping;
    
}

@end
