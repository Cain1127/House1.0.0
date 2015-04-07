//
//  QSYContactDetailInfoModel.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactDetailInfoModel.h"
#import "QSUserSimpleDataModel.h"

@implementation QSYContactDetailInfoModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_type",
                                                    @"username",
                                                    @"mobile",
                                                    @"avatar",
                                                    @"reservation_num",
                                                    @"reply_rate",
                                                    @"break_rate",
                                                    @"linkman_id",
                                                    @"is_import",
                                                    @"remark",
                                                    @"more_remark",
                                                    @"is_order"]];
        
    return shared_mapping;
    
}

/**
 *  @author yangshengmeng, 15-04-07 09:04:32
 *
 *  @brief  将联系人数据模型，转换为普通用户数据模型
 *
 *  @since  1.0.0
 */
- (QSUserSimpleDataModel *)contactDetailChangeToSimpleUserModel
{

    QSUserSimpleDataModel *simpleModel = [[QSUserSimpleDataModel alloc] init];
    simpleModel.id_ = self.linkman_id;
    simpleModel.user_type = self.user_type;
    simpleModel.nickname = self.remark;
    simpleModel.username = self.username;
    simpleModel.avatar = self.avatar;
    simpleModel.mobile = self.mobile;
    simpleModel.level = self.level;
    
    return simpleModel;

}

@end
