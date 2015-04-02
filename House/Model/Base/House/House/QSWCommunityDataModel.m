//
//  QSWCommunityDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWCommunityDataModel.h"

@implementation QSWCommunityDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"coordinate_x",
                                                    @"coordinate_y"
                                                    ]];
    
    return shared_mapping;
    
}

@end
