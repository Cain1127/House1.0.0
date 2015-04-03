//
//  QSHousePriceCommentDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseCommentDataModel.h"


/*!
 *  @author wangshupeng, 15-03-11 12:03:03
 *
 *  @brief  房子评论基本数据模型
 *
 *  @since 1.0.0
 */
@implementation QSHouseCommentDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"type",
                                                    @"obj_id",
                                                    @"title",
                                                    @"content",
                                                    @"update_time",
                                                    @"status",
                                                    @"create_time",
                                                    @"num",
                                                    
                                                    @"user_type",
                                                    @"email",
                                                    @"mobile",
                                                    @"realname",
                                                    @"sex",
                                                    @"avatar",
                                                    
                                                    @"nickname",
                                                    @"username",
                                                    @"sign",
                                                    @"web",
                                                    @"qq",
                                                    @"age",
                                                    @"idcard",
                                                    @"vocation",
                                                    @"tj_secondHouse_num",
                                                    @"tj_rentHouse_num"
                                                    ]];

    
    return shared_mapping;
    
}

@end
