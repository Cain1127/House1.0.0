//
//  QSOrderListOrderInfoDataModel.m
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListOrderInfoDataModel.h"
#import "QSCoreDataManager+User.h"

@implementation QSOrderListOrderInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
    // RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"order_type",
                                                    @"add_time",
                                                    @"order_status",
                                                    @"status",
                                                    @"buyer_name",
                                                    @"buyer_phone",
                                                    @"last_buyer_bid",
                                                    @"last_saler_bid",
                                                    @"buyer_id",
                                                    @"saler_id",
                                                    @"appoint_date",
                                                    @"appoint_start_time",
                                                    @"appoint_end_time"
                                                    ]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"buyer_msg" toKeyPath:@"buyer_msg" withMapping:[QSOrderListOrderInfoPersonInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

- (USER_COUNT_TYPE)getUserType
{
    return -1;
}


/*
 '500201'=>'预约状态',
 '500202'=>'再预约中状态',
 '500210'=>'待看房中',
 '500211'=>'待看房中->客户已选定时间',
 '500212'=>'待看房中->客户不同意时间--> 这里暂时还没有',
 '500213'=>'待看房中->房主已选定时间',
 '500214'=>'待看房中->房主不同意时间--> 不同意就直接取消了',
 '500215'=>'看房待确认状态',
 '500216'=>'房客修改看房时间',
 '500217'=>'房主修改看房时间',
 '500230'=>'看房待确认',
 '500231'=>'看房待确认-->用户已确认',
 '500232'=>'看房待确认-->房主已确认',
 '500233'=>'看房待确认-->房主投诉用户',
 '500234'=>'看房待确认-->用户投诉',
 '500235'=>'看房待确认-->用户不合适',
 '500250'=>'议价状态',
 '500251'=>'客户接受价格',
 '500252'=>'客户已还价格',
 '500253'=>'客户申请议价',
 '500254'=>'房主拒绝还价',
 '500255'=>'系统帮忙接受价格',
 '500256'=>'房主接受价格',
 '500257'=>'房主已还价格',
 '500258'=>'已经到了最后一个议价阶段价格',//2015 03 10
 '500259'=>'一口价待接受',
 '500220'=>'成功',
 '500221'=>'客户确认成功',
 '500222'=>'商家确认成功',
 '500223'=>'双方都确认成功',
 '500240'=>'系统取消',
 '500241'=>"客户取消",
 '500246'=>"房主取消"
 //TODO 要分清取消的类型
 '500241'=>'客户不合适结束',
 '500242'=>'客户不提价结束',
 '500243'=>'客户投诉商家结束',
 '500244'=>'客户不接受价格结束',
 '500245'=>'客户/商家接受价格结束',
 '500246'=>'商家不接受看房结束',
 '500247'=>'商家投诉客户看房结束',
 '500248'=>'商家不接受价格结束',
 '500249'=>'双方投诉看房结束',
 */

- (NSString*)getStatusStr
{
    
    NSString *statusStr = @"";
    
    if (self.order_status&&[self.order_status isKindOfClass:[NSString class]]) {
        
        if ([self.order_status isEqualToString:@"500201"] || [self.order_status isEqualToString:@"500215"] || [self.order_status isEqualToString:@"500216"]) {
            //@"预约状态",@"看房待确认状态",@"房客修改看房时间"
            statusStr = @"待确认";
        }else if ([self.order_status isEqualToString:@"500202"]) {
            statusStr = @"再预约中状态";
        }else if ([self.order_status isEqualToString:@"500210"]) {
            statusStr = @"待看房";
        }else if ([self.order_status isEqualToString:@"500230"]) {
            statusStr = @"看房待确认";
        }else if ([self.order_status isEqualToString:@"500231"]) {
            statusStr = @"用户已确认";
        }else if ([self.order_status isEqualToString:@"500232"]) {
            statusStr = @"房主已确认";
        }else if ([self.order_status isEqualToString:@"500233"]) {
            statusStr = @"房主投诉用户";
        }else if ([self.order_status isEqualToString:@"500234"]) {
            statusStr = @"用户投诉";
        }else if ([self.order_status isEqualToString:@"500235"]) {
            statusStr = @"用户不合适";
        }else if ([self.order_status isEqualToString:@"500250"]) {
            statusStr = @"议价状态";
        }else if ([self.order_status isEqualToString:@"500251"]) {
            statusStr = @"客户接受价格";
        }else if ([self.order_status isEqualToString:@"500252"]) {
            statusStr = @"客户已还价格";
        }else if ([self.order_status isEqualToString:@"500253"]) {
            statusStr = @"客户申请议价";
        }else if ([self.order_status isEqualToString:@"500254"]) {
            statusStr = @"房主拒绝还价";
        }else if ([self.order_status isEqualToString:@"500255"]) {
            statusStr = @"系统帮忙接受价格";
        }else if ([self.order_status isEqualToString:@"500256"]) {
            statusStr = @"房主接受价格";
        }else if ([self.order_status isEqualToString:@"500257"]) {
            statusStr = @"房主已还价格";
        }else if ([self.order_status isEqualToString:@"500258"]) {
            statusStr = @"最后一个议价阶段价格";
        }else if ([self.order_status isEqualToString:@"500259"]) {
            statusStr = @"一口价待接受";
        }else if ([self.order_status isEqualToString:@"500220"]) {
            statusStr = @"成功";
        }else if ([self.order_status isEqualToString:@"500221"]) {
            statusStr = @"客户确认成功";
        }else if ([self.order_status isEqualToString:@"500222"]) {
            statusStr = @"商家确认成功";
        }else if ([self.order_status isEqualToString:@"500223"]) {
            statusStr = @"双方都确认成功";
        }else if ([self.order_status isEqualToString:@"500240"]) {
            statusStr = @"系统取消";
        }else if ([self.order_status isEqualToString:@"500241"]) {
            statusStr = @"客户取消";
        }else if ([self.order_status isEqualToString:@"500246"]) {
            statusStr = @"房主取消";
        }else if ([self.order_status isEqualToString:@"500241"]) {
            statusStr = @"客户不合适结束";
        }else if ([self.order_status isEqualToString:@"500242"]) {
            statusStr = @"客户不提价结束";
        }else if ([self.order_status isEqualToString:@"500243"]) {
            statusStr = @"客户投诉商家结束";
        }else if ([self.order_status isEqualToString:@"500244"]) {
            statusStr = @"客户不接受价格结束";
        }else if ([self.order_status isEqualToString:@"500245"]) {
            statusStr = @"客户/商家接受价格结束";
        }else if ([self.order_status isEqualToString:@"500246"]) {
            statusStr = @"商家不接受看房结束";
        }else if ([self.order_status isEqualToString:@"500247"]) {
            statusStr = @"商家投诉客户看房结束";
        }else if ([self.order_status isEqualToString:@"500248"]) {
            statusStr = @"商家不接受价格结束";
        }else if ([self.order_status isEqualToString:@"500249"]) {
            statusStr = @"双方投诉看房结束";
        }
        
    }
    
    return statusStr;
    
}

- (NSArray*)getButtonAction
{
    NSMutableArray *btList = [NSMutableArray arrayWithCapacity:0];
    
    if (self.order_status&&[self.order_status isKindOfClass:[NSString class]]) {
        
        if ([self.order_status isEqualToString:@"500201"]) {
            //预约状态
            
            QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
            rightBt.bottionActionTag = [self.order_status integerValue];
            rightBt.buttonName = @"咨询";
            rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
            rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
            [btList addObject:rightBt];
            
            QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
            leftBt.bottionActionTag = [self.order_status integerValue];
            leftBt.buttonName = @"电话";
            leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
            leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
            [btList addObject:leftBt];
            
        }else if ([self.order_status isEqualToString:@"500202"]) {
            //再预约中状态
        }else if ([self.order_status isEqualToString:@"500210"]) {
            //待看房中
        }else if ([self.order_status isEqualToString:@"500211"]) {
            //客户已选定时间
        }else if ([self.order_status isEqualToString:@"500212"]) {
            //客户不同意时间
        }else if ([self.order_status isEqualToString:@"500213"]) {
            //房主已选定时间
        }else if ([self.order_status isEqualToString:@"500214"]) {
            //房主不同意时间
        }else if ([self.order_status isEqualToString:@"500215"]) {
            //看房待确认状态
        }else if ([self.order_status isEqualToString:@"500216"]) {
            //房客修改看房时间
        }else if ([self.order_status isEqualToString:@"500217"]) {
            //房主修改看房时间
        }else if ([self.order_status isEqualToString:@"500230"]) {
            //看房待确认
        }else if ([self.order_status isEqualToString:@"500231"]) {
            //用户已确认
        }else if ([self.order_status isEqualToString:@"500232"]) {
            //房主已确认
        }else if ([self.order_status isEqualToString:@"500233"]) {
            //房主投诉用户
        }else if ([self.order_status isEqualToString:@"500234"]) {
            //用户投诉
        }else if ([self.order_status isEqualToString:@"500235"]) {
            //用户不合适
        }else if ([self.order_status isEqualToString:@"500250"]) {
            //议价状态
        }else if ([self.order_status isEqualToString:@"500251"]) {
            //客户接受价格
        }else if ([self.order_status isEqualToString:@"500252"]) {
            //客户已还价格
        }else if ([self.order_status isEqualToString:@"500253"]) {
            //客户申请议价
        }else if ([self.order_status isEqualToString:@"500254"]) {
            //房主拒绝还价
        }else if ([self.order_status isEqualToString:@"500255"]) {
            //系统帮忙接受价格
        }else if ([self.order_status isEqualToString:@"500256"]) {
            //房主接受价格
        }else if ([self.order_status isEqualToString:@"500257"]) {
            //房主已还价格
        }else if ([self.order_status isEqualToString:@"500258"]) {
            //最后一个议价阶段价格
        }else if ([self.order_status isEqualToString:@"500259"]) {
            //一口价待接受
        }else if ([self.order_status isEqualToString:@"500220"]) {
            //成功
        }else if ([self.order_status isEqualToString:@"500221"]) {
            //客户确认成功
        }else if ([self.order_status isEqualToString:@"500222"]) {
            //商家确认成功
        }else if ([self.order_status isEqualToString:@"500223"]) {
            //双方都确认成功
        }else if ([self.order_status isEqualToString:@"500240"]) {
            //系统取消
        }else if ([self.order_status isEqualToString:@"500241"]) {
            //客户取消
        }else if ([self.order_status isEqualToString:@"500246"]) {
            //房主取消
        }else if ([self.order_status isEqualToString:@"500241"]) {
            //客户不合适结束
        }else if ([self.order_status isEqualToString:@"500242"]) {
            //客户不提价结束
        }else if ([self.order_status isEqualToString:@"500243"]) {
            //客户投诉商家结束
        }else if ([self.order_status isEqualToString:@"500244"]) {
            //客户不接受价格结束
        }else if ([self.order_status isEqualToString:@"500245"]) {
            //客户/商家接受价格结束
        }else if ([self.order_status isEqualToString:@"500246"]) {
            //商家不接受看房结束
        }else if ([self.order_status isEqualToString:@"500247"]) {
            //商家投诉客户看房结束
        }else if ([self.order_status isEqualToString:@"500248"]) {
            //商家不接受价格结束
        }else if ([self.order_status isEqualToString:@"500249"]) {
            //双方投诉看房结束
        }
        
    }
    
    return btList;
}

- (NSString*)getTimeStr
{
    NSString *timeStr = @"";
    
    if (self.appoint_date) {
        timeStr = self.appoint_date;
    }
    
    if (self.appoint_start_time) {
        timeStr = [NSString stringWithFormat:@"%@ %@",timeStr,self.appoint_start_time];
    }
    
    if (self.appoint_end_time) {
        timeStr = [NSString stringWithFormat:@"%@-%@",timeStr,self.appoint_end_time];
    }
    
    return timeStr;
}

@end

@implementation QSOrderListOrderInfoPersonInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
    // RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"username",
                                                    @"mobile",
                                                    @"id_",
                                                    @"level"
                                                    ]];
    
    return shared_mapping;
    
}

@end


@implementation QSOrderButtonActionModel


@end
