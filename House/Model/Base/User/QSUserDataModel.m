//
//  QSUserDataModel.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserDataModel.h"

@implementation QSUserDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"sex",
                                                    @"web",
                                                    @"vocation",
                                                    @"qq",
                                                    @"age",
                                                    @"idcard",
                                                    @"tel",
                                                    @"developer_name",
                                                    @"developer_intro",
                                                    @"ischeck_mail",
                                                    @"ischeck_mobile",
                                                    @"last_login_time"]];
    
    return shared_mapping;
    
}

@end
