//
//  QSConfigurationDataModel.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSConfigurationDataModel : QSBaseModel

@property (nonatomic,copy) NSString *conf;  //!<配置根目录
@property (nonatomic,copy) NSString *c_v;   //!<配置版本

@end
