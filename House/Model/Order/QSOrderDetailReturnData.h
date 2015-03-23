//
//  QSOrderDetailReturnData.h
//  House
//
//  Created by CoolTea on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSOrderDetailInfoDataModel.h"

@interface QSOrderDetailReturnData : QSHeaderDataModel

@property (nonatomic,strong) QSOrderDetailInfoDataModel *orderDetailData;    //!<配置的msg头信息

@end
