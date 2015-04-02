//
//  QSFilterDataModel.m
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSFilterDataModel.h"
#import "QSBaseConfigurationDataModel.h"

@implementation QSFilterDataModel

/**
 *  @author yangshengmeng, 15-03-27 00:03:32
 *
 *  @brief  重写初始化，添加自定义属性的初始化
 *
 *  @return 返回当前创建的过滤器模型
 *
 *  @since  1.0.0
 */
- (instancetype)init
{

    if (self = [super init]) {
        
        ///标签数组
        self.features_list = [[NSMutableArray alloc] init];
        self.installations = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

- (NSString *)getFeaturesPostParams
{

    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (QSBaseConfigurationDataModel *obj in self.features_list) {
        
        [tempString appendString:obj.key];
        
    }
    
    return [NSString stringWithString:tempString];

}

- (NSString *)getInstallationPostParams
{

    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (QSBaseConfigurationDataModel *obj in self.installations) {
        
        [tempString appendString:obj.key];
        
    }
    
    return [NSString stringWithString:tempString];

}

@end
