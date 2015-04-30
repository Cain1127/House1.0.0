//
//  QSDeveloperActivityDetailDataModel.m
//  House
//
//  Created by 王树朋 on 15/4/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDeveloperActivityDetailDataModel.h"

@implementation QSDeveloperActivityDetailDataModel

+(RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    
                                                    @"buyer_name",
                                                    @"buyer_phone",
                                                    @"o_expand_2"
                                                    
                                                    ]];
    
    return shared_mapping;
    
}

@end
