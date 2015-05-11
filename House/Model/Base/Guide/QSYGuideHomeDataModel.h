//
//  QSYGuideHomeDataModel.h
//  House
//
//  Created by ysmeng on 15/5/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSYGuideHomeDataModel : QSBaseModel

@property (nonatomic,copy) NSString *house_num;     //!<房源总数
@property (nonatomic,copy) NSString *house_user_num;//!<房客总数

@end
